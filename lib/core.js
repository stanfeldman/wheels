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
	
	start: function(options)
	{
		this.options = Object.merge(this.options, options);
		var mapping = this.mapping;
		var rtr = new controllers.Router(mapping);
		function on_request(req, res)
		{
		    rtr.route(req, res);
		};
		var server = http.createServer(on_request);
		server.listen(this.options.port, this.options.address);
		console.log("Server started on http://" + this.options.address + ":" + this.options.port + "/");
	},
	
	options: {
		address: "127.0.0.1",
		port: 1337
	}
});

exports.Application = Application;
