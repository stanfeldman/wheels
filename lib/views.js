require("mootools.js").apply(GLOBAL);
var core = require("./core");
var node_t = require('node-t');
var path = require('path');
var mime = require('mime');
var fs = require("fs");

var View = new Class
({
	render: function(res, options)
	{
		throw new TypeError("You must override this method");
	},
	
	options: {
	}
});

var TextView = new Class
({
	Extends: View,
	
	initialize: function(template_name)
	{
		this.template = node_t.fromFile(template_name);
	},
	
	render: function(res, options)
	{
		this.options = Object.merge(this.options, options);
		var result = this.template.render(this.options);
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.end(result);
		new core.Eventer().emit("after_response", res);
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
	
	render: function(res, options)
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
			new core.Eventer().emit("after_response", res);
		});
	}
});

exports.TextView = TextView;
exports.FileView = FileView;
