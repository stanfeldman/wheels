program = require "commander"
sys = require "sys"
fs = require "fs"
wrench = require 'wrench'
findit = require 'findit',
mime = require "mime"
path = require "path"
sqwish = require 'sqwish'
uglify = require "uglify-js"
html_minifier = require "html-minifier"
child_process = require 'child_process'

package_info = JSON.parse fs.readFileSync __dirname + "/../package.json", 'utf-8'
program
	.version(package_info.version)
	.option("new, --new", "create new project")
	.option("build, --build", "build project")
	.option("test, --test", "test kiss")
	.parse(process.argv)
if program.new
	console.log "creating new project..."
	project_path = process.argv[3]
	wrench.copyDirRecursive "./project", project_path, (err, result) ->
		console.log "done."
else if program.test
	console.log "testing kiss..."
	test_path = __dirname  + "/../test/*"
	child_process.exec "vows " + test_path  + " --spec", (error, stdout, stderr) ->
		result = stdout
		if stderr
			result = stderr
		console.log result
		console.log "done."
else if program.build
	console.log "build project!"
	project_path = process.argv[3]
	wrench.copyDirRecursive project_path, project_path + "/../build", (err, result) ->
		wrench.copyDirSyncRecursive project_path + "/../build", project_path + "/build"
		wrench.rmdirSyncRecursive project_path + "/../build"
		out_css = ""
		out_js = ""
		out_html = ""
		finder = findit.find path.normalize project_path + "/build/views"
		finder.on 'file', (file) ->
			filepath = path.normalize file
			mimetype = mime.lookup filepath
			switch mimetype
				when "text/css"
					out_css += fs.readFileSync filepath, 'utf-8'
				when "application/javascript"
					out_js += fs.readFileSync filepath, 'utf-8'
				when "text/html"
					out_html += fs.readFileSync filepath, 'utf-8'
		finder.on 'end', -> 
			out_css = sqwish.minify out_css, true
			console.log out_css
			ast = uglify.parser.parse out_js
			ast = uglify.uglify.ast_mangle ast
			ast = uglify.uglify.ast_squeeze ast
			out_js = uglify.uglify.gen_code ast
			console.log out_js
else
	console.log program.helpInformation()
