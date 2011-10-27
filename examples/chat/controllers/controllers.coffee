kiss = require "kiss.js"

class MyController
	application_started: (app) ->
		app.socketio.sockets.on 'connection', (socket) ->
			socket.on "distribute", (data) ->
				socket.broadcast.emit "receive", data
		
	get: (req, res) ->
		context = { template_name: "chat.html"  }
		v = new kiss.views.TextViewer()
		v.render req, res, context

exports.MyController = MyController
