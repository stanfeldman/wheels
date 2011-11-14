core = require "./core"
dust = require 'dust.js'
path = require 'path'
mime = require 'mime'
fs = require "fs"
findit = require 'findit'
uglify = require "uglify-js"
coffeescript = require "coffee-script"
mime = require "mime"
zlib = require "zlib"
url = require "url"

class TextViewer
	@instance: undefined
	
	constructor: (options)->
		if TextViewer.instance isnt undefined
			return TextViewer.instance
		@template_path = options.template_path
		unless @template_path.length > 0
			return
		finder = findit.find path.normalize @template_path
		finder.on 'file', (file) =>
			filepath = path.normalize file
			if (mime.lookup filepath) is "text/html"
				data = fs.readFileSync filepath, 'utf-8'
				compiled = dust.compile data, path.basename filepath
				dust.loadSource compiled
		TextViewer.instance = this
		
	middleware: () ->
		return (req, res, next) =>
			res.render = (template, context) ->
				dust.render template, context, (err, out) ->
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
		
	middleware: () ->
		return (req, res, next) =>
			if 'GET' isnt req.method
				return next()
			p = url.parse(req.url).pathname
			console.log p
			if /\.js$/.test(p)
				comp_path = path.join @static_path, p
				orig_path = path.join @static_path, p.replace '.js', '.coffee'
				fs.stat orig_path, (err, orig_path_stats) =>
					fs.stat comp_path, (e, comp_path_stats) =>
						if e
							if 'ENOENT' == e.code
								@compile(orig_path, comp_path, next)
							else
							  next e
						else
							if orig_path_stats?.mtime > comp_path_stats?.mtime
								@compile(orig_path, comp_path, next)
							else next()
			else next()
							
	compile: (from, to, next) ->
		console.log "compiling #{from}"
		fs.readFile from, 'utf8', (err, str) =>
			@compile_coffee str, (e, res) ->
				console.log res
				fs.writeFile to, res, 'utf8', next
			
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
