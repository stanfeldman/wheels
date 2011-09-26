#!/usr/bin/env node
var program = require("commander"),
	fs = require("fs"),
	wrench = require('wrench'),
	findit = require('findit'),
	mime = require("mime"),
	path = require("path"),
	sqwish = require('sqwish'),
	uglify = require("uglify-js"),
	html_minifier = require("html-minifier");
var html_minifier_options =
{
	removeComments: true,
	removeCommentsFromCDATA: true,
	removeCDATASectionsFromCDATA: true,
	collapseWhitespace: true,
	collapseBooleanAttributes: true,
	removeAttributeQuotes: true,
	removeRedundantAttributes: true,
	useShortDoctype: true,
	removeEmptyAttributes: true,
	removeEmptyElements: true,
	removeOptionalTags: true
	//removeScriptTypeAttributes:     byId('remove-script-type-attributes').checked,
	//removeStyleLinkTypeAttributes:  byId('remove-style-link-type-attributes').checked,
};

var package_info = JSON.parse(fs.readFileSync("./package.json", 'utf-8'));
program
	.version(package_info.version)
	.option("new, --new", "create new project")
	.option("build, --build", "build project")
	.parse(process.argv);
if(program.new)
{
	console.log("new project!");
	var project_path = process.argv[3];
	wrench.copyDirRecursive("./project", project_path, function(err, result)
	{
		console.log("ok!");
	});
}
else if(program.build)
{
	console.log("build project!");
	var project_path = process.argv[3];
	wrench.copyDirRecursive(project_path, project_path + "/../build", function(err, result)
	{
		wrench.copyDirSyncRecursive(project_path + "/../build", project_path + "/build");
		wrench.rmdirSyncRecursive(project_path + "/../build");
		var out_css = "";
		var out_js = "";
		var out_html = "";
		var finder = findit.find(path.normalize(project_path + "/build/views"));
		finder.on('file', function (file) 
		{
			var filepath = path.normalize(file);
			var mimetype = mime.lookup(filepath);
			switch(mimetype)
			{
				case "text/css":
					out_css += fs.readFileSync(filepath, 'utf-8');
					break;
				case "application/javascript":
					out_js += fs.readFileSync(filepath, 'utf-8');
					break;
				case "text/html":
					out_html += fs.readFileSync(filepath, 'utf-8');
					break;
			}
		});
		finder.on('end', function () 
		{
			out_css = sqwish.minify(out_css, true);
			console.log(out_css);
			var ast = uglify.parser.parse(out_js); // parse code and get the initial AST
			ast = uglify.uglify.ast_mangle(ast); // get a new AST with mangled names
			ast = uglify.uglify.ast_squeeze(ast); // get an AST with compression optimizations
			out_js = uglify.uglify.gen_code(ast); // compressed code here
			console.log(out_js);
			html_minifier.minify(out_html, html_minifier_options);
			console.log(out_html);
			console.log("ok!");
		});
	});
}
else
	console.log(program.helpInformation());
