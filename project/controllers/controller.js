require("mootools.js").apply(GLOBAL);
var kiss = require("kiss.js");
var path = require('path');
var fs = require("fs");

exports.index = function(params, args)
{
	var req = args[0], res = args[1];
	var translator = new kiss.views.Translator();
	//console.log(translator.translate(req, "hello"));
	//console.log(translator.translate(req, 'hello, {0}', "Стас"));
	var context = { template_name: "view.html", foo: 'hello', names: ["Stas", "Boris"], numbers: [], name: function() { return "Bob"; } };
	for(var i = 0; i < 10; ++i)
	    context.numbers.push("bla bla " + i);
	var v = new kiss.views.TextViewer();
	v.render(req, res, context);
}

exports.on_not_found = function(params, args)
{
	var req = args[0], res = args[1];
	res.writeHead(404, {'Content-Type': 'text/html'});
	res.end("custom 404");
}
