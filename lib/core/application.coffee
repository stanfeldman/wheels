http = require 'http'
controllers = require "../controllers"
views = require "../views"
connect = require "connect"
path = require "path"
stylus = require 'stylus'
eventemitter2 = require("eventemitter2")
cookieParser = require 'cookie-parser'
session = require "cookie-session"
serveStatic = require "serve-static"


class Application
	@instance: undefined

	constructor: (@options) ->
		if Application.instance isnt undefined
			return Application.instance
		Application.instance = this
	
	start: ->
		if @started
			return
		@eventer = new eventemitter2.EventEmitter2({wildcard: true})
		for ev, listn of @options.events
			@eventer.on ev, listn
		@router = new controllers.Router(@options.urls)
		@responser = new views.Responser()
		@templater = new views.Templater(@options.views)
		@filer = new views.Filer(@options.views)
		@compiler = new views.Compiler(@options.views)
		@translator = new views.Translator(@options.views)
		@server = connect()
		@server.use cookieParser()
		@server.use session({ secret: @options.views.cookie_secret })
		@server.use serveStatic(@options.views.static_path)
		#@server.use connect.staticCache()
		@server.use @responser.middleware()
		@server.use @templater.middleware()
		@server.use @filer.middleware()
		@server.use @router.middleware()
		@server.listen @options.application.port, @options.application.address
		@started = true
		@eventer.emit "application.started", this
		
	stop: ->
		unless @started
			return
		@server.close()

module.exports = Application
