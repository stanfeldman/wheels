kiss = require "kiss.js"
controllers = require "../controllers/controllers"

options =
	events:
		"application_started": controllers.MyController.on_app_started
		"/$": controllers.MyController.index
app = new kiss.core.Application(options)
app.start()
