require("mootools.js").apply(GLOBAL);
var http = require('http'),
	controllers = require("./controllers"),
	models = require("./models"),
	views = require("./views"),
	events = require("events");

var Application = new Class
({
	initialize: function(options)
	{
		if(typeof Application.instance == "object")
			return Application.instance;
		this.options = Object.merge(this.options, options);
		Application.instance = this;
		this.eventer = new Eventer();
		this.router = new controllers.Router();
		this.text_viewer = new views.TextViewer();
		this.translator = new views.Translator();
		//new models.Manager();
	},
	
	start: function()
	{
		if(this.started) return;
		var rtr = this.router;
		function on_request(req, res)
		{
		    rtr.route(req, res);
		};
		var server = http.createServer(on_request);
		server.listen(this.options.application.port, this.options.application.address);
		this.started = true;
		console.log("Server started on http://" + this.options.application.address + ":" + this.options.application.port + "/");
	},
	
	options: 
	{
		application:
		{
			address: "127.0.0.1",
			port: 1337,
			mode: "debug"
		},
		events:
		{
			"not_found": controllers.Controller.on_not_found
		},
		views:
		{
			template_path: "./views/templates/",
			static_path: "./views/static/",
			locale_path: "./views/locales/"
		}
	}
});

//Existing events: "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
var Eventer = new Class
({
	initialize: function()
	{
		if(typeof Eventer.instance == "object")
			return Eventer.instance;
		Eventer.instance = this;
		this.app = new Application();
	},

	emit: function(event)
	{
		var args = Array.prototype.slice.call(arguments, 1);
		var found = false;
		for(regex in this.app.options.events)
		{
			var re = new RegExp(regex, "ig");
			var params = re.exec(event);
			if(params)
			{
				var handler = this.app.options.events[regex];
				params = params.splice(1, params.length-1);
				found = true;
				handler(params, args);
			}
		}
		if(!found && !["not_found", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains(event))
			this.emit.apply(this, ["not_found"].append(args));
	}
});

exports.Application = Application;
exports.Eventer = Eventer;
