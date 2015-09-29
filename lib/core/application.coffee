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
		@router = new controllers.router.Router(@options.urls)
		@responser = new views.responser.Responser()
		@templater = new views.templater.Templater(@options.views)
		@filer = new views.filer.Filer(@options.views)
		@compiler = new views.compiler.Compiler(@options.views)
		@translator = new views.translator.Translator(@options.views)
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

exports.Application = Application
