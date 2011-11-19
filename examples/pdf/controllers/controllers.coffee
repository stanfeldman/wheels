kiss = require "kiss.js"
path = require 'path'
fs = require "fs"
pdf = require "pdf.js"
uuid = require 'node-uuid'

class MyController
	get: (req, res) ->
		app = new kiss.core.application.Application()
		pdf = new pdf()
		filename = uuid() + ".pdf"
		filepath = path.join app.options.views.static_path, filename
		pdf.text "hello, world!\nlalala345"
		pdf.write filepath, ->
			res.file filepath, {filename: "out.pdf", delete_after: true}

exports.MyController = MyController
