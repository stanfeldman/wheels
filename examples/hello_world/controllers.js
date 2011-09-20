require("mootools.js").apply(GLOBAL);
var kiss = require("kiss.js");
var Pdf = require("pdfkit");
var path = require('path');
var uuid = require('node-uuid');
var fs = require("fs");

var Controller1 = new Class
({
	Extends: kiss.controllers.Controller,
	
	get: function(req, res)
	{
		var context = { foo: "bar", names: ["Stas", "Boris"], numbers: [] };
		for(var i = 0; i < 10; ++i)
		    context.numbers.push("bla bla " + i);
		var v = new kiss.views.TextView(path.join(__dirname, "view1.html"));
		v.render(res, context);
	}
});

var Controller2 = new Class
({
	Extends: kiss.controllers.Controller,
	
	get: function(req, res)
	{
		var pdf = new Pdf();
		var filename = uuid() + ".pdf";
		pdf.text("hello, world!\nlalala345");
		pdf.write(filename, function()
		{
			var v = new kiss.views.FileView(path.join(__dirname, filename));
			v.render(res, {filename: "out.pdf"});
			fs.unlink(path.join(__dirname, filename));
		});
	}
});

exports.Controller1 = Controller1;
exports.Controller2 = Controller2;
