core = require "./core"
swig = require 'swig'
html_minifier = require "html-minifier"
min_options =
	removeComments: true
	collapseBooleanAttributes: true
	removeCDATASectionsFromCDATA: true
	collapseWhitespace: true
	removeAttributeQuotes: true
	removeEmptyAttributes: true
path = require 'path'
mime = require 'mime'
mime.define { 'application/coffeescript': ['coffee'] }
fs = require "fs"
findit = require 'findit'
uglify = require "uglify-js"
coffeescript = require "coffee-script"
mime = require "mime"
zlib = require "zlib"
url = require "url"
stylus = require "stylus"
connect = require "connect"

class TextViewer
	@instance: undefined
	
	constructor: (options)->
		if TextViewer.instance isnt undefined
			return TextViewer.instance
		@template_path = options.template_path
		@static_path = options.static_path
		unless @template_path.length > 0
			return
		unless @static_path.length > 0
			return
		swig.init {root: @template_path}
		compiler = new Compiler(@static_path)
		finder = findit.find @static_path
		finder.on 'file', (file) ->
			filepath = path.normalize file
			fs.readFile filepath, 'utf-8', (err, data) ->
				mimetype = mime.lookup filepath
				switch mimetype
					when "text/css"
						new_css = filepath[0..filepath.length-5] + ".c.css"
						bname = path.basename filepath, ".css"
						if bname[bname.length-2..bname.length] isnt ".c"
							compiler.compile_css data, (err, res) ->
								fs.writeFile new_css, res, 'utf-8'
					when "application/javascript"
						new_js = filepath[0..filepath.length-4] + ".c.js"
						bname = path.basename filepath, ".js"
						if bname[bname.length-2..bname.length] isnt ".c"
							compiler.compile_js data, (err, res) ->
								fs.writeFile new_js, res, 'utf-8'
					when "application/coffeescript"
						new_cf = filepath[0..filepath.length-8] + ".c.js"
						bname = path.basename filepath, ".js"
						if bname[bname.length-2..bname.length] isnt ".c"
							compiler.compile_coffee data, (err, res) ->
								fs.writeFile new_cf, res, 'utf-8'
		TextViewer.instance = this
		
	middleware: () ->
		return (req, res, next) =>
			res.render = (template, context) ->
				tmpl = swig.compileFile template
				out = html_minifier.minify (tmpl.render context), min_options
				zlib.gzip out, (e, o) ->
					res.writeHead 200, {'Content-Type': 'text/html', "Content-Encoding": "gzip"}
					res.end o
			next()

class Compiler
	@instance: undefined
	
	constructor: (options) ->
		if Compiler.instance isnt undefined
			return Compiler.instance
		@static_path = options.static_path
		Compiler.instance = this
				
	compile_css: (str, callback) ->
		stylus.render str, {compress: true}, (err, res) ->
			callback err, res
			
	compile_js: (js, callback) ->
		ast = uglify.parser.parse js
		ast = uglify.uglify.ast_mangle ast
		ast = uglify.uglify.ast_squeeze ast
		callback null, uglify.uglify.gen_code ast
		
	compile_coffee: (coffee, callback) ->
		cf = coffeescript.compile coffee
		@compile_js cf, (err, js) ->
			callback err, js

class FileViewer
	constructor: (options) ->
		@static_path = options.static_path
	
	middleware: () ->
		return (req, res, next) =>
			res.send = (filepath, options) =>
				res.setHeader 'Content-disposition', 'attachment; filename=' + options.filename
				#res.setHeader 'Content-type', @mimetype
				filestream = fs.createReadStream filepath
				filestream.on 'data', (chunk) =>
					res.write chunk
				filestream.on 'end', ->
					res.end()
					if options.delete_after
						fs.unlink filepath
					return true
			next()
	
	render: (req, res, options) ->
		res.setHeader 'Content-disposition', 'attachment; filename=' + options.filename
		res.setHeader 'Content-type', @mimetype
		filestream = fs.createReadStream this.file
		filestream.on 'data', (chunk) =>
			res.write chunk
		filestream.on 'end', ->
			res.end()
			#new core.Eventer().emit "after_action", req, res
			
class Translator
	@instance: undefined
	
	constructor: (options) ->
		if Translator.instance isnt undefined
			return Translator.instance
		unless path.existsSync options.locale_path
			return
		@translations = {}
		@files = fs.readdirSync path.normalize options.locale_path
		for file in @files
			data = fs.readFileSync options.locale_path+file, 'utf-8'
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

exports.TextViewer = TextViewer
exports.FileViewer = FileViewer
exports.Translator = Translator
exports.Compiler = Compiler
