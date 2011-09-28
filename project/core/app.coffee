kiss = require "kiss.js"
controllers = require "../controllers/controllers"

options =
	events:
		"/$": controllers.MyController.index,
		"/2$": controllers.MyController.fileview,
		"not_found": controllers.MyController.on_not_found
app = new kiss.core.Application(options)
app.start()
