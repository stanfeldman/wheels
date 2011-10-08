kiss = require "kiss.js"
controllers = require "../controllers/controllers"

args = process.argv.splice 2
port = 1337
if args[0]
	port = parseInt args[0]
options =
	application:
		port: port
	events:
		"application_started": controllers.MyController.on_app_started
		"/$": controllers.MyController.index
app = new kiss.core.Application(options)
app.start()
