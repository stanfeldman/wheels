require("mootools.js").apply(GLOBAL);
var url = require("url")
var core = require("./core");

var Router = new Class
({
	initialize: function(mapping)
	{
		this.mapping = mapping;
		for(km in mapping)
		{
			var C = mapping[km];
			mapping[km] = new C();
			if(!instanceOf(mapping[km], Controller))
				throw new TypeError("Your controller must be inherited from controllers.Controller");
		}
	},
	
	route: function(req, res)
	{
		var page_url = url.parse(req.url);
		var is_found = false;
		for(key in this.mapping)
		{
			var re = new RegExp(key, "ig");
			var params = re.exec(page_url.pathname);
			if(params)
			{
				new core.Eventer().emit("before_request", req, res);
				var c = this.mapping[key];
				req.params = params.splice(1, params.length-1);
				req.url = page_url;
				switch(req.method)
				{
					case "GET":
						c.get(req, res);
						break;
					case "POST":
						c.post(req, res);
						break;
					case "PUT":
						c.put(req, res);
						break;
					case "DELETE":
						c.del(req, res);
						break;
				}
				break;
			}
		}
	}
});

var Controller = new Class
({
	get: function(req, res) { not_found(); },
	
	post: function(req, res) { not_found(); },
	
	put: function(req, res) { not_found(); },
	
	del: function(req, res) { not_found(); },
	
	not_found: function()
	{
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.end("404");
	}
});

exports.Router = Router;
exports.Controller = Controller;
