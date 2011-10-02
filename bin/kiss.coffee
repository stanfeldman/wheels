program = require "commander"
sys = require "sys"
fs = require "fs"
wrench = require 'wrench'
findit = require 'findit',
mime = require "mime"
mime.define { 'application/coffeescript': ['coffee'] }
path = require "path"
less = require 'less'
uglify = require "uglify-js"
coffeescript = require "coffee-script"
child_process = require 'child_process'
views = require "../lib/views"

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
	compiler = new views.Compiler()
	wrench.copyDirRecursive project_path, project_path + "/../build", (err, result) ->
		wrench.copyDirSyncRecursive project_path + "/../build", project_path + "/build"
		wrench.rmdirSyncRecursive project_path + "/../build"
		#remove build/build dir if exists
		wrench.rmdirSyncRecursive project_path + "/build/build"
		out_css = ""
		out_js = ""
		out_coffee = ""
		finder = findit.find path.normalize project_path + "/build/views"
		finder.on 'file', (file) ->
			filepath = path.normalize file
			mimetype = mime.lookup filepath
			switch mimetype
				when "text/css" or "text/less"
					fs.readFile filepath, 'utf-8', (err, data) ->
						compiler.compile_css data, (css) ->
							#console.log "css: " + css
							fs.writeFile filepath, css, 'utf-8'
				when "application/javascript"
					fs.readFile filepath, 'utf-8', (err, data) ->
						compiler.compile_js data, (js) ->
							#console.log "js: " + js
							fs.writeFile filepath, js, 'utf-8'
				when "application/coffeescript"
					fs.readFile filepath, 'utf-8', (err, data) ->
						compiler.compile_coffee data, (cf) ->
							#console.log "coffee: " + cf
							fs.writeFile (filepath.substring 0, filepath.length-6) + "js", cf, 'utf-8'
							fs.unlink filepath
		finder.on 'end', ->
			console.log "done."
else
	console.log program.helpInformation()
