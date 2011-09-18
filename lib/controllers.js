require("mootools.js").apply(GLOBAL);
var url = require("url")

var Router = new Class
({
	initialize: function(mapping)
	{
		this.mapping = mapping;
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
				var C = this.mapping[key];
				req.params = params.splice(1, params.length-1);
				req.url = page_url;
				var c = new C();
				switch(req.method)
				{
					case "GET":
						c.get(req, res);
						is_found = true;
						break;
					case "POST":
						c.post(req, res);
						is_found = true;
						break;
					case "PUT":
						c.put(req, res);
						is_found = true;
						break;
					case "DELETE":
						c.del(req, res);
						is_found = true;
						break;
				}
				if(is_found)
					break;
			}
		}
		if(!is_found)
		{
		    res.writeHead(200, {'Content-Type': 'text/html'});
		    res.end("404");
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
