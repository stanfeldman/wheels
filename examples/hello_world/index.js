require.paths.push('/usr/lib/node_modules');
var kiss = require("kiss.js");
var controllers = require("./controllers");
var path = require('path');

var options =
{
	events:
	{
		"/$": controllers.MyController.index,
		"/2/?$": controllers.MyController.view2,
		"/(\\d+).(\\d+)/?$": controllers.MyController.view2,
		"before_action": controllers.MyController.on_before_action,
		"after_action": controllers.MyController.on_after_action,
		"not_found": controllers.MyController.on_not_found
	},
	models:
	{
		//adapter: kiss.models.adapters.MongodbAdapter, 
		host: "127.0.0.1",
		port: 27017, 
		name: "test"
	}
};
var app = new kiss.core.Application(options);
app.start();
