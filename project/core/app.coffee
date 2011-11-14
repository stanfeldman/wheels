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
		address: address || "127.0.0.1"
		port: port || 1337
	views:
		static_path: __dirname + "/../views/static/"
		template_path: "."
		locale_path: "./views/locales/"
		cookie_secret: "ertyu78f020fk"
	urls:
		"/c": my_controller
		"/user":
			"/posts": my_controller
app = new kiss.core.Application(options)
app.start()
