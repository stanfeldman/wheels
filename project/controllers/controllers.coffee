class MyController
	get: (req, res) ->
		#translator = new kiss.views.Translator()
		#console.log translator.translate req, "hello"
		#console.log translator.translate req, 'hello, {0}', "Стас"
		req.session.views ?= 0
		req.session.views++
		context = 
			foo: req.session.views
			pagename: 'awesome people'
			authors: ['Paul', 'Jim', 'Jane']
		res.template "views/templates/view.html", context
		
	post: (req, res) ->
		res.text "hello from post"

exports.MyController = MyController
