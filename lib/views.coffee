core = require "./core"
TemplateEngine = require 'dust'
path = require 'path'
mime = require 'mime'
fs = require "fs"
findit = require 'findit'

class TextViewer
	@instance: undefined
	
	constructor: ->
		if TextViewer.instance isnt undefined
			return TextViewer.instance
		@template_path = new core.Application().options.views.template_path;
		finder = findit.find path.normalize @template_path
		finder.on 'file', (file) =>
			filepath = path.normalize file
			data = fs.readFileSync filepath, 'utf-8'
			tname = filepath.substring (path.normalize @template_path).length
			compiled = TemplateEngine.compile data, tname
			TemplateEngine.loadSource compiled
		TextViewer.instance = this
	
	render: (req, res, context) ->
		TemplateEngine.render context.template_name, context, (err, out) =>
			res.writeHead 200, {'Content-Type': 'text/html'}
			res.end out
			new core.Eventer().emit "after_action", req, res

class FileView
	constructor: (file_path) ->
		@file = file_path
		@mimetype = mime.lookup this.file
		@filename = path.basename this.file
	
	render: (req, res, options) ->
		res.setHeader 'Content-disposition', 'attachment; filename=' + options.filename
		res.setHeader 'Content-type', @mimetype
		filestream = fs.createReadStream this.file
		filestream.on 'data', (chunk) =>
			res.write chunk
		filestream.on 'end', ->
			res.end()
			new core.Eventer().emit "after_action", req, res
			
class Translator
	@instance: undefined
	
	constructor: ->
		if Translator.instance isnt undefined
			return Translator.instance
		@app = new core.Application()
		@translations = {}
		@files = fs.readdirSync path.normalize @app.options.views.locale_path
		for file in @files
			data = fs.readFileSync @app.options.views.locale_path+file, 'utf-8'
			#json file with name "<lang>.json"
			@translations[file.substring 0, file.length-5] = JSON.parse data
		Translator.instance = this
	
	#file format:
	#"<words> {0} <words>" : "<trans_words> {0} <trans_words>"
	translate: (req, str) ->
		msg = ""
		lang = @translations[@get_lang req];
		if(lang)
			msg = lang[str]
			if msg and arguments.length > 2
				args = Array.prototype.slice.call arguments, 2
				msg = @substitute msg, args
		return msg || ""
	
	substitute: (str, arr) ->
		for i in [0..arr.length]
			pattern = "\\{" + i + "\\}"
			re = new RegExp(pattern, "g")
			str = str.replace re, arr[i] 
		return str || ""
	
	get_lang: (request) ->
		if typeof request is 'object'
		    language_header = request.headers['accept-language']
		    languages = []
		    regions = []
		    if language_header
		        (language_header.split ',').forEach (l) ->
		            header = (l.split ';', 1)[0]
		            lr = header.split '-', 2
		            if lr[0]
		            	languages.push lr[0].toLowerCase()
		            if lr[1]
		                regions.push lr[1].toLowerCase()

		        if languages.length > 0
		            request.languages = languages
		            request.language = languages[0]

		        if regions.length > 0
		            request.regions = regions
		            request.region = regions[0]
		    return request.language

exports.TextViewer = TextViewer;
exports.FileView = FileView;
exports.Translator = Translator;
