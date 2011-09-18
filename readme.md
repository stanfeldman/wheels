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
	app.start();
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
	<pre>
	<html>
		<head>
		<meta charset="UTF-8"/>
		</head>
		<body>
		<h1>Hello from kiss.js</h1>
		<h2>{{foo}}</h2>
		    <ul>
		        {% for name in names %}
		        <li>{{name}}</li>
		        {% end %}
		    </ul>
		    <h2>some strings</h2>
		    <ul>
		        {% for num in numbers %}
		        <li>{{num}}</li>
		        {% end %}
		    </ul>
		</body>
	</html>
	</pre>
