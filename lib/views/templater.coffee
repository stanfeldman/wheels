swig = require 'swig'
htmlMinifier = require "html-minifier"
min_options =
	removeComments: true
	collapseBooleanAttributes: true
	removeCDATASectionsFromCDATA: true
	collapseWhitespace: true
	removeAttributeQuotes: true
	removeEmptyAttributes: true
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
		swig.setDefaults {root: @template_path}		
		Templater.instance = this
		
	middleware: ->
		return (req, res, next) =>
			res.template = (template, context) ->
				tmpl = swig.compileFile template
				out = htmlMinifier.minify (tmpl context), min_options
				res.html out
			next()

module.exports = Templater
