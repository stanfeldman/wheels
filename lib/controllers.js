require("mootools.js").apply(GLOBAL);
var	url = require("url"),
	core = require("./core"),
	path = require('path'),
	paperboy = require('paperboy');

var Router = new Class
({
	initialize: function()
	{
		if(typeof Router.instance == "object")
			return Router.instance;
		Router.instance = this;
		this.app = new core.Application();
	},
	route: function(req, res)
	{
		function find_action()
		{
			var page_url = url.parse(req.url);
			req.url = page_url;
			this.eventer = new core.Eventer();
			this.eventer.emit("before_action", req, res);
			this.eventer.emit(page_url.pathname, req, res);
		}
		if(this.app.options.application.mode == "debug")
			paperboy.deliver(path.normalize(this.app.options.views.static_path), req, res).otherwise(function(err) 
			{
				find_action();
			});
		else find_action();
	}
});

var Controller = {};
Controller.on_not_found = function(params, args)
{
	var req = args[0], res = args[1];
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.end("404");
}

exports.Router = Router;
exports.Controller = Controller;
