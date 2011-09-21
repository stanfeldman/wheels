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
		new Eventer(this.options.eventer);
		Application.instance = this;
	},
	
	start: function()
	{
		var rtr = this.router;
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

//Existing events: "before_request", "after_response", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
var Eventer = new Class
({
	Extends: events.EventEmitter,
	
	initialize: function(options)
	{
		if(typeof Eventer.instance == "object")
			return Eventer.instance;
		this.options = options;
		for(opt in this.options)
			this.addListener(opt, this.options[opt]);
		Eventer.instance = this;
	}
});

exports.Application = Application;
exports.Eventer = Eventer;
