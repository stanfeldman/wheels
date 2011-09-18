require("mootools.js").apply(GLOBAL);
var node_t = require('node-t');

var View = new Class
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

exports.View = View;
