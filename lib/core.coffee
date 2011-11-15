http = require 'http'
#socketio = require "socket.io"
controllers = require "./controllers"
views = require "./views"
events = require "events"
connect = require "connect"
path = require "path"
stylus = require 'stylus'
quip = require 'quip'
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
		@router = new controllers.Router(@options.urls)
		@text_viewer = new views.TextViewer(@options.views)
		@file_viewer = new views.FileViewer(@options.views)
		@compiler = new views.Compiler(@options.views)
		@translator = new views.Translator(@options.views)
		@server = connect(
			connect.cookieParser(),
			connect.session({ secret: @options.views.cookie_secret }),
			connect.static(@options.views.static_path),
			connect.staticCache(),
			quip(),
			@text_viewer.middleware(),
			@file_viewer.middleware(),
			@router.middleware()
		)
		#@server = @middleware
		#@socketio = socketio.listen @server, {"log level" : 0}
		@server.listen @options.application.port, @options.application.address
		@started = true
		@eventer.emit "application.started", this
		
	stop: ->
		unless @started
			return
		@server.close()

exports.Application = Application
