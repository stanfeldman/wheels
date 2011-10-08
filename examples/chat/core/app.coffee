kiss = require "kiss.js"
controllers = require "../controllers/controllers"

options =
	events:
		"/$": controllers.MyController.index
app = new kiss.core.Application(options)
app.start()
