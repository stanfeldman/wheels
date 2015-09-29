controllers = require "../controllers/controllers"

args = process.argv.splice 2
address = "127.0.0.1"
port = 3000
if args[0]
	address = args[0]
if args[1]
	port = parseInt args[1]	
my_controller = new controllers.MyController()
options =
	application:
		address: address || "127.0.0.1"
		port: port || 3000
	views:
		static_path: __dirname + "/../views/static/"
		template_path: __dirname + "/../"
		locale_path: __dirname + "/../views/locales/"
		cookie_secret: "ertyu78f020fk"
	urls:
		"/": my_controller
		"/user":
			"/posts": my_controller
exports.options = options
