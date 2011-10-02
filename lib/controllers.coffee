core = require "./core"
views = require "./views"
url = require "url"
mime = require "mime"
mime.define { 'application/coffeescript': ['coffee'] }
path = require "path"
fs = require "fs"

class Router
	@instance: undefined
	
	constructor: ->
		if Router.instance isnt undefined
			return Router.instance
		@app = new core.Application()
		@eventer = new core.Eventer()
		@compiler = new views.Compiler()
		Router.instance = this
		
	route_static: (res, filepath, mimetype) ->
		write_res = (data, mimetype) ->
			res.writeHead 200, {'Content-Type': mimetype}
			res.end data, 'utf-8'
		fs.readFile filepath, 'utf-8', (err, data) =>
			if data
				switch mimetype
					when "text/css"
						@compiler.compile_css data, (css) ->
							write_res css, mimetype
					when "application/javascript"
						@compiler.compile_js data, (js) ->
							write_res js, mimetype
					when "application/coffeescript"
						@compiler.compile_coffee data, (cf) ->
							write_res cf, mimetype
				
	route_dynamic: (req, res, page_url) ->
		@eventer.emit "before_action", req, res
		@eventer.emit page_url.pathname, req, res
	
	route: (req, res) ->
		page_url = url.parse req.url
		req.url = page_url
		if @app.options.application.mode isnt "debug"
			@route_dynamic req, res, page_url
		else
			pathname = page_url.pathname
			mimetype = mime.lookup pathname
			filepath = path.join @app.options.views.static_path, pathname
			if mimetype not in ["text/css", "application/javascript", "application/coffeescript"]
				@route_dynamic req, res, page_url
			else
				@route_static res, filepath, mimetype

class Controller			
	@on_not_found: (params, args) ->
		req = args[0]
		res = args[1]
		res.writeHead 200, {'Content-Type': 'text/html'}
		res.end "404"
		
exports.Router = Router
exports.Controller = Controller
