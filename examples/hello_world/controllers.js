require("mootools.js").apply(GLOBAL);
var kiss = require("kiss.js");

var Controller1 = new Class
({
	Extends: kiss.controllers.Controller,
	
	get: function(req, res)
	{
		var context = { foo: "bar", names: ["Stas", "Boris"], numbers: [] };
		for(var i = 0; i < 10; ++i)
		    context.numbers.push("bla bla " + i);
		var v = new kiss.views.View(__dirname + "/view1.html");
		v.render(res, context);
	}
});

var Controller2 = new Class
({
	Extends: kiss.controllers.Controller,
	
	get: function(req, res)
	{
		//console.log(req.url);
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.end("view2");
	}
});

exports.Controller1 = Controller1;
exports.Controller2 = Controller2;
