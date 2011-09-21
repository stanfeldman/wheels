require.paths.push('/usr/lib/node_modules');
var kiss = require("kiss.js");
var controllers = require("./controllers");

var options =
{
	address: "127.0.0.1",
	port: 1337,
	mapping:
	{
		"/$": controllers.Controller1,
		"/2/?$": controllers.Controller2,
		"/(\\d+).(\\d+)/?$": controllers.Controller2
	},
	db:
	{
		adapter: kiss.models.adapters.MongodbAdapter, 
		host: "127.0.0.1",
		port: 27017, 
		name: "test_db", 
		user: "root", 
		password: "!1ebet2@"
	}
};
var app = new kiss.core.Application(options);
app.start();
