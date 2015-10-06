# Web framework for node.js in CoffeeScript. Simple and sexy.

	Wheels - object-oriented web framework on Node.js, written in CoffeeScript.

# Installation

	* Get npm (http://npmjs.org)
	* run npm install wheels
	* (optionaly) If you want write project in CoffeeScript <pre>npm install coffee-script</pre>
	* Done

# Usage

	Create project(it is just good files structure, you can configure it via application options) <pre>wheels new path/to/new/project</pre>
	
# core/app.coffee

	wheels = require "wheels"
	controllers = require "../controllers/controllers"
	args = process.argv.splice 2
	address = "127.0.0.1"
	port = 1337
	if args[0]
		address = args[0]
	if args[1]
		port = parseInt args[1]	
	my_controller = new controllers.MyController()
	options =
		application:
			address: address || "127.0.0.1"
			port: port || 1337
		views:
			static_path: __dirname + "/../views/static/"
			template_path: __dirname + "/../"
			locale_path: __dirname + "/../views/locales/"
			cookie_secret: "ertyu78f020fk"
		urls:
			"/": my_controller
			"/user":
				"/posts": my_controller
	app = new wheels.core.Application(options)
	app.start()

# controllers.js

	wheels = require "wheels"
	class MyController
		get: (req, res) ->
			req.session.views ?= 0
			req.session.views++
			context = { foo: req.session.views, names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
			for i in [0..10]
				context.numbers.push "bla bla " + i
			res.template "view.html", context
		
		post: (req, res) ->
			res.text "hello from post"
	exports.MyController = MyController

# view.html
	wheels uses Django-like templates from swig. See project folder.
	Client-side coffee scripts will be compiled on the start.
	For styling use Stylus, it is also compiled on the start.
	
# License

	This software is licensed under the BSD License. See the license file in the top distribution directory for the full license text.
