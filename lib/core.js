var http = require('http');
var controllers = require("./controllers");
require("mootools.js").apply(GLOBAL);

var Application = new Class
({
	initialize: function(mapping)
	{
		if(typeof Application.instance == "object")
			return Application.instance;
		this.mapping = mapping;
		Application.instance = this;
	},
	
	start: function()
	{
		var mapping = this.mapping;
		var rtr = new controllers.Router(mapping);
		function on_request(req, res)
		{
		    rtr.route(req, res);
		};
		var server = http.createServer(on_request);
		server.listen(1337, "127.0.0.1");
		console.log("Сервер запущен на http://127.0.0.1:1337/");
	}
});

exports.Application = Application;
