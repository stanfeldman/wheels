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
	var mapping = 
	{
		"/$": controllers.Controller1,
		"/2/?$": controllers.Controller2,
		"/(\\d+).(\\d+)/?$": controllers.Controller2
	};
	var app = new kiss.core.Application(mapping);
	app.start("127.0.0.1", 1337);
	</pre>
* controllers.js
	<pre>
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
			var v = new kiss.views.View(__dirname + "/view.html");
			v.render(res, context);
		}
	});
	exports.Controller1 = Controller1;
	</pre>
* view.html
	Use django-like template tags. See examples.
