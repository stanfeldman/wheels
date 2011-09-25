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
	//var translator = new kiss.views.Translator();
	//console.log(translator.translate(req, "hello"));
	//console.log(translator.translate(req, 'hello, {0}', "Стас"));
	var context = { template_name: "view1", foo: 'hello', names: ["Stas", "Boris"], numbers: [], name: function() { return "Bob"; } };
	for(var i = 0; i < 10; ++i)
	    context.numbers.push("bla bla " + i);
	var v = new kiss.views.TextViewer();
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
	console.time("view rendering time");
}

exports.MyController.on_after_action = function(params, args)
{
	console.timeEnd("view rendering time");
}

exports.MyController.on_not_found = function(params, args)
{
	var req = args[0], res = args[1];
	res.writeHead(404, {'Content-Type': 'text/html'});
	res.end("custom 404");
}
