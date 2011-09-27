core = require "./core"
url = require "url"

class Router
	@instance: undefined
	
	constructor: ->
		if Router.instance isnt undefined
			return Router.instance
		@app = new core.Application()
		@eventer = new core.Eventer()
		Router.instance = this
	
	route: (req, res) ->
		page_url = url.parse req.url
		req.url = page_url
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
