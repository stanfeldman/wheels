require("mootools.js").apply(GLOBAL);
var core = require("./core");
var TemplateEngine = require('dust');
var path = require('path');
var mime = require('mime');
var fs = require("fs");

var View = new Class
({
	render: function(req, res, options)
	{
		throw new TypeError("You must override this method");
	},
	
	options: {
	}
});

var files = fs.readdirSync(path.normalize('./templates/'));
for(var i = 0; i < files.length; ++i)
{
	var item = files[i];
	var data = fs.readFileSync("./templates/"+item, 'utf-8');
	var compiled = TemplateEngine.compile(data, item.substring(0, item.length-5));
	TemplateEngine.loadSource(compiled);
}

var TextView = new Class
({
	Extends: View,
	
	initialize: function(template_name)
	{
		this.template_name = template_name;
	},
	
	render: function(req, res, context)
	{
		console.time("dust rendering time");
		TemplateEngine.render(this.template_name, context, function(err, out) 
		{
			res.writeHead(200, {'Content-Type': 'text/html'});
			res.end(out);
			console.timeEnd("dust rendering time");
			new core.Eventer().emit("after_action", req, res);
		});
	}
});

var FileView = new Class
({
	Extends: View,
	
	initialize: function(file_path)
	{
		this.file = file_path;
		this.mimetype = mime.lookup(this.file);
		this.options.filename = path.basename(this.file);
	},
	
	render: function(req, res, options)
	{
		this.options = Object.merge(this.options, options);
		res.setHeader('Content-disposition', 'attachment; filename=' + this.options.filename);
		res.setHeader('Content-type', this.mimetype);
		var filestream = fs.createReadStream(this.file);
		filestream.on('data', function(chunk)
		{
			res.write(chunk);
		});
		filestream.on('end', function() 
		{
			res.end();
			new core.Eventer().emit("after_action", req, res);
		});
	}
});

var Translator = new Class
({
	initialize: function()
	{
		if(typeof Translator.instance == "object")
			return Translator.instance;
		this.translations = {};
		this.translation_path = path.normalize('./locales/');
		var files = fs.readdirSync(this.translation_path);
		for(var i = 0; i < files.length; ++i)
		{
			var item = files[i];
			var data = fs.readFileSync("./locales/"+item, 'utf-8');
			this.translations[item.substring(0, item.length-5)] = JSON.parse(data);
		}
		Translator.instance = this;
	},
	
	translate: function(req, str)
	{
		var msg = "";
		var lang = this.translations[this.get_lang(req)];
		if(lang)
		{
			msg = lang[str];
			if (msg && arguments.length > 2)
			{
				var args = Array.prototype.slice.call(arguments, 2);
				msg = this.substitute(msg, args);
			}
		}
		return msg || "";
	},
	
	substitute: function(str, arr) 
	{ 
		var i, pattern, re, n = arr.length; 
		for (i = 0; i < n; i++)
		{ 
			pattern = "\\{" + i + "\\}"; 
			re = new RegExp(pattern, "g"); 
			str = str.replace(re, arr[i]); 
		} 
		return str || ""; 
	},
	
	get_lang: function(request)
	{
		if(typeof request === 'object'){
		    var language_header = request.headers['accept-language'],
		    languages = [];
		    regions = [];

		    if (language_header) {
		        language_header.split(',').forEach(function(l) {
		            header = l.split(';', 1)[0];
		            lr = header.split('-', 2);
		            if (lr[0]) {
		                languages.push(lr[0].toLowerCase());
		            }
		            if (lr[1]) {
		                regions.push(lr[1].toLowerCase());
		            }
		        });

		        if (languages.length > 0) {
		            request.languages = languages;
		            request.language = languages[0];
		        }

		        if (regions.length > 0) {
		            request.regions = regions;
		            request.region = regions[0];
		        }
		    }
		    return request.language;
		}
	}
});

exports.TextView = TextView;
exports.FileView = FileView;
exports.Translator = Translator;
