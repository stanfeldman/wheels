kiss = require "kiss.js"
controllers = require "../controllers/controllers"

args = process.argv.splice 2
address = "127.0.0.1"
port = 1337
if args[0]
	address = args[0]
if args[1]
	port = parseInt args[1]
	
my_controller = new controllers.MyController()
options =
	application:
		address: address
		port: port
	events:
		"application_started": my_controller
		"/$": my_controller
app = new kiss.core.application.Application(options)
app.start()
