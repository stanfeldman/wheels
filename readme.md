# Web framework for node.js in CoffeeScript. Simple and sexy.

Object-oriented web framework on node.js written in CoffeeScript.

# Installation

* Get npm (http://npmjs.org)
* run <pre>npm install kiss.js</pre>
* (optionaly) If you want write project in CoffeeScript <pre>npm install coffee-script</pre>
* Done

# Usage

* Create project(it is just good files structure, you can configure it via application options) <pre>kiss new path/to/new/project</pre>
* index.js
	<pre>
	kiss = require "kiss.js"
	controllers = require "../controllers/controllers"
	options =
		events:
			"/$": controllers.MyController.index,
			"/2$": controllers.MyController.fileview,
			"not_found": controllers.MyController.on_not_found
	app = new kiss.core.Application(options)
	app.start()
	</pre>
* controllers.js
	<pre>
	kiss = require "kiss.js"
	class MyController
		@index = (params, args) ->
			req = args[0] 
			res = args[1]
			translator = new kiss.views.Translator()
			console.log translator.translate req, "hello"
			console.log translator.translate req, 'hello, {0}', "Стас"
			context = { template_name: "view.html", foo: 'hello', names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
			for i in [0..10]
				context.numbers.push "bla bla " + i
			v = new kiss.views.TextViewer()
			v.render req, res, context

	exports.MyController = MyController
	</pre>
* view.html
	Now I use dust templates. See project folder.
