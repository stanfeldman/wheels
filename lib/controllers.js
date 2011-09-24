require("mootools.js").apply(GLOBAL);
var url = require("url")
var core = require("./core");
var path = require('path');

var Router = new Class
({
	route: function(req, res)
	{
		var page_url = url.parse(req.url);
		req.url = page_url;
		var filepath = '.' + req.url;
		var extname = path.extname(filepath);
		var contentType = 'text/html';
		switch (extname) 
		{
			case '.js':
				contentType = 'text/javascript';
				break;
			case '.css':
				contentType = 'text/css';
				break;
		}	
		console.log(filepath);
		path.exists(filepath, function(exists) 
		{
			console.log(exists);
			if (exists) 
			{
				fs.readFile(filepath, function(error, content) {
					response.writeHead(200, { 'Content-Type': contentType });
					response.end(content, 'utf-8');
					return;
				});
			}
		});
		this.eventer = new core.Eventer();
		this.eventer.emit("before_action", req, res);
		this.eventer.emit(page_url.pathname, req, res);
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
