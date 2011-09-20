require("mootools.js").apply(GLOBAL);
var node_t = require('node-t');
var Pdf = require("pdfkit");
var path = require('path');
var mime = require('mime');
var fs = require("fs");

var TextView = new Class
({
	initialize: function(template_name)
	{
		this.template = node_t.fromFile(template_name);
	},
	
	render: function(res, context)
	{
		var result = this.template.render(context);
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.end(result);
	}
});

var FileView = new Class
({
	initialize: function(file_path)
	{
		this.file = file_path;
		this.basename = path.basename(this.file);
		this.mimetype = mime.lookup(this.file);
	},
	
	render: function(res)
	{
		res.setHeader('Content-disposition', 'attachment; filename=' + this.basename);
		res.setHeader('Content-type', this.mimetype);
		var filestream = fs.createReadStream(this.file);
		filestream.on('data', function(chunk)
		{
			res.write(chunk);
		});
		filestream.on('end', function() 
		{
			res.end();
		});
	}
});

exports.TextView = TextView;
exports.FileView = FileView;
