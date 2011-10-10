kiss = require "kiss.js"
controllers = require "../controllers/controllers"
models = require "../models/models"

args = process.argv.splice 2
address = "127.0.0.1"
port = 1337
if args[0]
	address = args[0]
if args[1]
	port = parseInt args[1]
options =
	application:
		address: address
		port: port
	events:
		"/$": controllers.MyController.index,
		"not_found": controllers.MyController.on_not_found
app = new kiss.core.Application(options)
app.start()
