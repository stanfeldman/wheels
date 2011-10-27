$(document).ready(function()
{
	var socket = io.connect(window.location.hostname);
	function receive(data)
	{
		$("<li><h3>" + data.name + "</h3><p><strong>" + data.message + "</strong></p></li>").prependTo("#messages");
		$('#messages').listview('refresh');
	}
	socket.on('receive', receive);
	function send()
	{
		var name = $('<div/>').text($("#username").val()).html();
		var message = $('<div/>').text($("#text-input").val()).html();
		var data = { name: name, message: message };
		socket.emit('distribute', data);
		receive(data);
		$("#text-input").val("");
	}
	$("#send-button").click(send);
	$("#text-input").keypress(function(e) 
	{
		if(e.keyCode == 13) send();
	});
});
