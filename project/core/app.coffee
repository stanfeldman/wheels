kiss = require "kiss.js"
controllers = require "../controllers/controllers"
models = require "../models/models"

args = process.argv.splice 2
port = 1337
if args[0]
	port = parseInt args[0]
options =
	application:
		port: port
	events:
		"/$": controllers.MyController.index,
		"not_found": controllers.MyController.on_not_found
	models:
		objects: [new models.MyModel(56, "some str")]
		user: "root"
		password: "!1ebet2@"
		database: "kiss_project"
app = new kiss.core.Application(options)
app.start()
