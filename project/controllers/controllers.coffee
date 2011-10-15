kiss = require "kiss.js"

class MyController
	get: (req, res) ->
		#translator = new kiss.views.Translator()
		#console.log translator.translate req, "hello"
		#console.log translator.translate req, 'hello, {0}', "Стас"
		req.session.views ?= 0
		req.session.views++
		context = { template_name: "view.html", foo: req.session.views, names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
		for i in [0..10]
			context.numbers.push "bla bla " + i
		v = new kiss.views.TextViewer()
		v.render req, res, context

	not_found: (req, res) ->
		res.writeHead 404, {'Content-Type': 'text/html'}
		res.end "custom 404"

exports.MyController = MyController
