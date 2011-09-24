require("mootools.js").apply(GLOBAL);
var http = require('http');
var controllers = require("./controllers");
var models = require("./models");
var views = require("./views");
var events = require("events");

var Application = new Class
({
	initialize: function(options)
	{
		if(typeof Application.instance == "object")
			return Application.instance;
		this.options = Object.merge(this.options, options);
		this.eventer = new Eventer(this.options.events);
		this.router = new controllers.Router(this.options.controllers);
		this.text_viewer = new views.TextViewer();
		this.translator = new views.Translator(this.options.views.translation_path);
		//new models.Manager(this.options.models);
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
		},
		events:
		{
			"not_found": controllers.Controller.on_not_found
		},
		views:
		{
			template_path: "./templates/"
		}
	}
});

//Existing events: "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
var Eventer = new Class
({
	initialize: function(events)
	{
		if(typeof Eventer.instance == "object")
			return Eventer.instance;
		this.events = Object.merge(this.events, events);
		Eventer.instance = this;
	},

	emit: function(event)
	{
		var args = Array.prototype.slice.call(arguments, 1);
		var found = false;
		for(regex in this.events)
		{
			var re = new RegExp(regex, "ig");
			var params = re.exec(event);
			if(params)
			{
				var handler = this.events[regex];
				params = params.splice(1, params.length-1);
				found = true;
				handler(params, args);
			}
		}
		if(!found)
		{
			console.log(event);
			if(!(event in ["not_found", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"]))
				this.emit.apply(this, ["not_found"].append(args));
			else if(event == "not_found")
			{
				res.writeHead(200, {'Content-Type': 'text/html'});
				res.end("not found");
			}
		}
	},
	
	events: {}
});

exports.Application = Application;
exports.Eventer = Eventer;
