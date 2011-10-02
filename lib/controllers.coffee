core = require "./core"
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
		Router.instance = this
		
	route_static: (res, filepath, type) ->
		fs.readFile filepath, 'utf-8', (err, data) ->
			if data
				res.writeHead 200, {'Content-Type': type}
				res.end data, 'utf-8'
	
	route: (req, res) ->
		page_url = url.parse req.url
		req.url = page_url
		if @app.options.application.mode is "debug"
			pathname = page_url.pathname
			mimetype = mime.lookup pathname
			filepath = path.join @app.options.views.static_path, pathname
			switch mimetype
				when "text/css" or "application/javascript" or "application/coffeescript"
					@route_static res, filepath, mimetype
				else
					@eventer.emit "before_action", req, res
					@eventer.emit page_url.pathname, req, res
		else
			@eventer.emit "before_action", req, res
			@eventer.emit page_url.pathname, req, res

class Controller			
	@on_not_found: (params, args) ->
		req = args[0]
		res = args[1]
		res.writeHead 200, {'Content-Type': 'text/html'}
		res.end "404"
		
exports.Router = Router
exports.Controller = Controller
