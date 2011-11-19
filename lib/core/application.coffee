http = require 'http'
controllers = require "../controllers"
views = require "../views"
connect = require "connect"
path = require "path"
stylus = require 'stylus'
eventemitter2 = require("eventemitter2")

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
		@templater = new views.templater.Templater(@options.views)
		@filer = new views.filer.Filer(@options.views)
		@compiler = new views.compiler.Compiler(@options.views)
		@translator = new views.translator.Translator(@options.views)
		@server = connect(
			connect.cookieParser(),
			connect.session({ secret: @options.views.cookie_secret }),
			connect.static(@options.views.static_path),
			connect.staticCache(),
			views.res(),
			@templater.middleware(),
			@filer.middleware(),
			@router.middleware()
		)
		@server.listen @options.application.port, @options.application.address
		@started = true
		@eventer.emit "application.started", this
		
	stop: ->
		unless @started
			return
		@server.close()

exports.Application = Application
