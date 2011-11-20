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
		Templater.instance = this
		
	middleware: ->
		return (req, res, next) =>
			res.template = (template, context) ->
				tmpl = swig.compileFile template
				out = html_minifier.minify (tmpl.render context), min_options
				res.html out
			next()

exports.Templater = Templater
