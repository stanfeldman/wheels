require("mootools.js").apply(GLOBAL);
var url = require("url")
var core = require("./core");

var Router = new Class
({
	route: function(req, res)
	{
		var page_url = url.parse(req.url);
		req.url = page_url;
		this.eventer = new core.Eventer();
		this.eventer.emit("before_action", req, res);
		this.eventer.emit(page_url.pathname, req, res);
	}
});

exports.Router = Router;
