kiss = require "kiss.js"
path = require 'path'
fs = require "fs"
Pdf = require "pdfkit"
uuid = require 'node-uuid'

class MyController
	@index = (req, res) ->
		context = { template_name: "view.html", foo: 'hello', names: ["Stas", "Boris"], numbers: [], name: -> "Bob " + "Marley"  }
		for i in [0..10]
			context.numbers.push "bla bla " + i
		v = new kiss.views.TextViewer()
		v.render req, res, context

exports.MyController = MyController
