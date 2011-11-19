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
zlib = require "zlib"
url = require "url"
compiler = require "./compiler"

class Templater
	@instance: undefined
	
	constructor: (options)->
		if Templater.instance isnt undefined
			return Templater.instance
		@template_path = options.template_path
		@static_path = options.static_path
		unless @template_path.length > 0
			return
		unless @static_path.length > 0
			return
		swig.init {root: @template_path}
		compiler = new compiler.Compiler(@static_path)
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
		Templater.instance = this
		
	middleware: () ->
		return (req, res, next) =>
			res.template = (template, context) ->
				tmpl = swig.compileFile template
				out = html_minifier.minify (tmpl.render context), min_options
				zlib.gzip out, (e, o) ->
					res.writeHead 200, {'Content-Type': 'text/html', "Content-Encoding": "gzip"}
					res.end o
			next()

exports.Templater = Templater
