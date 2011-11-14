kiss = require "kiss.js"

class MyController
	get: (req, res) ->
		#translator = new kiss.views.Translator()
		#console.log translator.translate req, "hello"
		#console.log translator.translate req, 'hello, {0}', "Стас"
		req.session.views ?= 0
		req.session.views++
		context = { template_name: "views/templates/view.html", foo: req.session.views, names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
		for i in [0..10]
			context.numbers.push "bla bla " + i
		v = new kiss.views.TextViewer()
		v.render req, res, context
		
	post: (req, res) ->
		res.text "hello from post"

	not_found: (req, res) ->
		res.writeHead 404, {'Content-Type': 'text/html'}
		res.end "custom 404"
		
class PostController
	get: (req, res) ->
		context = { template_name: "views/templates/view.html", foo: "post controller", names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
		for i in [0..10]
			context.numbers.push "post controller " + i
		v = new kiss.views.TextViewer()
		v.render req, res, context

exports.MyController = MyController
exports.PostController = PostController
