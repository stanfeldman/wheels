require.paths.push('/usr/lib/node_modules');
var kiss = require("kiss.js");
var controller = require("./controllers/controller");

var options =
{
	events:
	{
		"/$": controller.index,
		"not_found": controller.on_not_found
	}
};
var app = new kiss.core.Application(options);
app.start();
