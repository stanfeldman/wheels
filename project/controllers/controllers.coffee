kiss = require "kiss.js"
path = require 'path'
fs = require "fs"
Pdf = require "pdfkit"
uuid = require 'node-uuid'

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

	#Pdf file example
	@fileview = (params, args) ->
		req = args[0]
		res = args[1]
		pdf = new Pdf()
		filename = uuid() + ".pdf"
		filepath = path.join __dirname, filename
		pdf.text "hello, world!\nlalala345"
		pdf.write filepath, ->
			v = new kiss.views.FileView(filepath)
			v.render req, res, {filename: "out.pdf"}
			fs.unlink(filepath)

	@on_not_found = (params, args) ->
		req = args[0]
		res = args[1]
		res.writeHead 404, {'Content-Type': 'text/html'}
		res.end "custom 404"

exports.MyController = MyController
