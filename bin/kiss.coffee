program = require "commander"
sys = require "sys"
fs = require "fs"
wrench = require 'wrench'
findit = require 'findit',
mime = require "mime"
mime.define { 
	'text/coffeescript': ['coffee']
	"text/less": ['less'] 
	}
path = require "path"
less = require 'less'
uglify = require "uglify-js"
coffeescript = require "coffee-script"
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
	console.log "building project..."
	project_path = process.argv[3]
	wrench.copyDirRecursive project_path, project_path + "/../build", (err, result) ->
		wrench.copyDirSyncRecursive project_path + "/../build", project_path + "/build"
		wrench.rmdirSyncRecursive project_path + "/../build"
		out_css = ""
		out_js = ""
		out_coffee = ""
		finder = findit.find path.normalize project_path + "/build/views"
		finder.on 'file', (file) ->
			filepath = path.normalize file
			mimetype = mime.lookup filepath
			console.log mimetype
			switch mimetype
				when "text/css" or "text/less"
					out_css += fs.readFileSync filepath, 'utf-8'
				when "application/javascript"
					out_js += fs.readFileSync filepath, 'utf-8'
				when "text/coffeescript"
					out_coffee += fs.readFileSync filepath, 'utf-8'
		finder.on 'end', ->
			less_parser = new(less.Parser)
			less_parser.parse out_css, (e, tree) ->
				out_css = tree.toCSS({ compress: true })
				console.log out_css
			out_js += coffeescript.compile out_coffee
			ast = uglify.parser.parse out_js
			ast = uglify.uglify.ast_mangle ast
			ast = uglify.uglify.ast_squeeze ast
			out_js = uglify.uglify.gen_code ast
			console.log out_js
			console.log "done."
else
	console.log program.helpInformation()
