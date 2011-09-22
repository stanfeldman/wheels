require("mootools.js").apply(GLOBAL);
var http = require('http');
var controllers = require("./controllers");
var models = require("./models");
var events = require("events");

var Application = new Class
({
	initialize: function(options)
	{
		if(typeof Application.instance == "object")
			return Application.instance;
		this.options = Object.merge(this.options, options);
		this.router = new controllers.Router(this.options.controllers);
		//new models.Manager(this.options.models);
		this.eventer = new Eventer(this.options.eventer);
		Application.instance = this;
	},
	
	start: function()
	{
		if(this.options.application.started) return;
		var rtr = this.router;
		function on_request(req, res)
		{
		    rtr.route(req, res);
		};
		var server = http.createServer(on_request);
		server.listen(this.options.application.port, this.options.application.address);
		this.options.application.started = true;
		console.log("Server started on http://" + this.options.application.address + ":" + this.options.application.port + "/");
	},
	
	options: 
	{
		application:
		{
			address: "127.0.0.1",
			port: 1337,
			started: false
		}
	}
});

//Existing events: "before_request", "after_response", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
var Eventer = new Class
({
	initialize: function(listeners)
	{
		if(typeof Eventer.instance == "object")
			return Eventer.instance;
		this.listeners = Object.merge(this.listeners, listeners);
		Eventer.instance = this;
	},

	emit: function(event)
	{
		for(regex in this.listeners)
		{
			var re = new RegExp(regex, "ig");
			var params = re.exec(event);
			if(params)
			{
				var handler = this.listeners[regex];
				params = params.splice(1, params.length-1);
				var args = Array.prototype.slice.call(arguments, 1);
				handler(event, params, args);
			}
		}
	},
	
	listeners: {}
});

exports.Application = Application;
exports.Eventer = Eventer;
