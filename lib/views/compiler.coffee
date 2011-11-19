uglify = require "uglify-js"
coffeescript = require "coffee-script"
stylus = require "stylus"

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

exports.Compiler = Compiler
