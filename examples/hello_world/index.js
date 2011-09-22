require.paths.push('/usr/lib/node_modules');
var kiss = require("kiss.js");
var controllers = require("./controllers");

var options =
{
	application:
	{
		address: "127.0.0.1",
		port: 1337,
	},
	controllers:
	{
		"/$": controllers.Controller1,
		"/2/?$": controllers.Controller2,
		"/(\\d+).(\\d+)/?$": controllers.Controller2
	},
	models:
	{
		//adapter: kiss.models.adapters.MongodbAdapter, 
		host: "127.0.0.1",
		port: 27017, 
		name: "test"
	},
	eventer:
	{
		"before_request": function(event, params, args)
		{ 
			console.log("event: " + event);
			console.log("params: " + params);
			console.log("args: " + args);
			console.log("method: " + args[0].method);
		}
	}
};
var app = new kiss.core.Application(options);
app.start();
