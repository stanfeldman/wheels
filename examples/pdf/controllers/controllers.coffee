kiss = require "kiss.js"
path = require 'path'
fs = require "fs"
Pdf = require "pdfkit"
uuid = require 'node-uuid'

class MyController
	#Pdf file example
	get: (req, res) ->
		pdf = new Pdf()
		filename = uuid() + ".pdf"
		filepath = path.join __dirname, filename
		pdf.text "hello, world!\nlalala345"
		pdf.write filepath, ->
			v = new kiss.views.FileView(filepath)
			v.render req, res, {filename: "out.pdf"}
			fs.unlink(filepath)

exports.MyController = MyController
