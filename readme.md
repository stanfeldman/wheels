# Web framework for node.js. Simple and sexy.

Object-oriented web framework on node.js.

# Installation

* Get npm (http://npmjs.org)
* run <pre>npm install kiss.js</pre>
* Done

# Usage

* index.js
	<pre>
	var kiss = require("kiss.js");
	var controllers = require("./controllers");
	
	var options =
	{
		application:
		{
			address: "127.0.0.1",
			port: 1337,
		},
		events:
		{
			"/$": controllers.MyController.index,
			"/2/?$": controllers.MyController.view2,
			"/(\\d+).(\\d+)/?$": controllers.MyController.view2,
			"before_action": controllers.MyController.on_before_action,
			"not_found": controllers.MyController.on_not_found
		},
		models:
		{
			//adapter: kiss.models.adapters.MongodbAdapter, 
			host: "127.0.0.1",
			port: 27017, 
			name: "test"
		}
	};
	var app = new kiss.core.Application(options);
	app.start();
	</pre>
* controllers.js
	<pre>
	require("mootools.js").apply(GLOBAL);
	var kiss = require("kiss.js");
	var Pdf = require("pdfkit");
	var path = require('path');
	var uuid = require('node-uuid');
	var fs = require("fs");

	exports.MyController = {};

	exports.MyController.index = function(params, args)
	{
		var req = args[0], res = args[1];
		var context = { foo: "bar", names: ["Stas", "Boris"], numbers: [] };
		for(var i = 0; i < 10; ++i)
			context.numbers.push("bla bla " + i);
		var v = new kiss.views.TextView(path.join(__dirname, "view1.html"));
		v.render(req, res, context);
	}

	exports.MyController.view2 = function(params, args)
	{
		var req = args[0], res = args[1];
		var pdf = new Pdf();
		var filename = uuid() + ".pdf";
		pdf.text("hello, world!\nlalala345");
		pdf.write(filename, function()
		{
			var v = new kiss.views.FileView(path.join(__dirname, filename));
			v.render(req, res, {filename: "out.pdf"});
			fs.unlink(path.join(__dirname, filename));
		});
	}

	exports.MyController.on_before_action = function(params, args)
	{
		console.log("params: " + params);
		console.log("args: " + args);
		console.log("method: " + args[0].method);
	}

	exports.MyController.on_not_found = function(params, args)
	{
		var req = args[0], res = args[1];
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.end("404");
	}
	</pre>
* view.html
	Use django-like template tags. See examples.
