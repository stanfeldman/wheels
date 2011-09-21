var http = require('http');
var controllers = require("./controllers");
require("mootools.js").apply(GLOBAL);

var Application = new Class
({
	initialize: function(options)
	{
		if(typeof Application.instance == "object")
			return Application.instance;
		this.options = Object.merge(this.options, options);
		Application.instance = this;
	},
	
	start: function()
	{
		var rtr = new controllers.Router(this.options.mapping);
		function on_request(req, res)
		{
		    rtr.route(req, res);
		};
		var server = http.createServer(on_request);
		server.listen(this.options.port, this.options.address);
		console.log("Server started on http://" + this.options.address + ":" + this.options.port + "/");
	},
	
	options: 
	{
		address: "127.0.0.1",
		port: 1337
	}
});

exports.Application = Application;
