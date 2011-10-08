kiss = require "kiss.js"
controllers = require "../controllers/controllers"

options =
	events:
		"/$": controllers.MyController.fileview
app = new kiss.core.Application(options)
app.start()
