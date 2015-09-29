uglify = require "uglify-js"
coffeescript = require "coffee-script"
stylus = require "stylus"
mime = require 'mime'
mime.define { 'application/coffeescript': ['coffee'] }
fs = require "fs"
findit = require 'findit'
path = require 'path'

class Compiler
	@instance: undefined
	
	constructor: (options) ->
		if Compiler.instance isnt undefined
			return Compiler.instance
		@static_path = options.static_path
		finder = findit @static_path
		finder.on 'file', (file) =>
			filepath = path.normalize file
			fs.readFile filepath, 'utf-8', (err, data) =>
				mimetype = mime.lookup filepath
				switch mimetype
					when "text/css"
						new_css = filepath[0..filepath.length-5] + ".c.css"
						bname = path.basename filepath, ".css"
						if bname[bname.length-2..bname.length] isnt ".c"
							@compile_css data, (err, res) ->
								fs.writeFile new_css, res, 'utf-8'
					when "application/javascript"
						new_js = filepath[0..filepath.length-4] + ".c.js"
						bname = path.basename filepath, ".js"
						if bname[bname.length-2..bname.length] isnt ".c"
							@compile_js data, (err, res) ->
								fs.writeFile new_js, res, 'utf-8'
					when "application/coffeescript"
						new_cf = filepath[0..filepath.length-8] + ".c.js"
						bname = path.basename filepath, ".js"
						if bname[bname.length-2..bname.length] isnt ".c"
							@compile_coffee data, (err, res) ->
								fs.writeFile new_cf, res, 'utf-8'
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
			callback null, js

exports.Compiler = Compiler
