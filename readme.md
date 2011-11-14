# Web framework for node.js in CoffeeScript. Simple and sexy.

Object-oriented web framework on Node.js, written in CoffeeScript.

# Installation

* Get npm (http://npmjs.org)
* run <pre>npm install kiss.js</pre>
* (optionaly) If you want write project in CoffeeScript <pre>npm install coffee-script</pre>
* Done

# Usage

* Create project(it is just good files structure, you can configure it via application options) <pre>kiss new path/to/new/project</pre>
* core/app.coffee
	<pre>
	kiss = require "kiss.js"
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
			"/c": my_controller
			"/user":
				"/posts": my_controller
	app = new kiss.core.Application(options)
	app.start()
	</pre>
* controllers.js
	<pre>
kiss = require "kiss.js"
class MyController
	get: (req, res) ->
		req.session.views ?= 0
		req.session.views++
		context = { foo: req.session.views, names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
		for i in [0..10]
			context.numbers.push "bla bla " + i
		res.render "view.html", context
		
	post: (req, res) ->
		res.text "hello from post"
exports.MyController = MyController
	</pre>
* view.html
	Kiss.js uses dust templates. See project folder.
	Client-side coffee scripts will be compile on the fly.
	For styling use Stylus, it also compiles on the fly.
