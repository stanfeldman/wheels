kiss = require "kiss.js"
rpc = kiss.controllers.rpc

class MyController
	@on_app_started = (app) ->
		app.rpc_channel.now.distributeMessage = (message) ->
			gr = rpc.getGroup @now.room
			gr.removeUser @user.clientId
			gr = rpc.getGroup @now.new_room
			gr.addUser @user.clientId
			@now.room = @now.new_room
			gr.now.receiveMessage @now.name, escape message
		rpc.on "connect", ->
			rpc_group = rpc.getGroup @now.room
			rpc_group.addUser @user.clientId
			@now.name = @now.name + @user.clientId
		
	@index = (req, res) ->
		context = { template_name: "chat.html"  }
		v = new kiss.views.TextViewer()
		v.render req, res, context

exports.MyController = MyController
