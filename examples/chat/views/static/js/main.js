$(document).ready(function()
{
	now.name = "user";
	now.room = "room 1";
	function send()
	{
		now.name = $("#username").val();
		now.new_room = $("#room").val();
		var html = $("#text-input").val();
		html = $('<div/>').text(html).html();		
		now.distributeMessage(html);
		$("#text-input").val("");
	}
	$("#send-button").click(send);
	$("#text-input").keypress(function(e) 
	{
		if(e.keyCode == 13) send();
	});
	now.receiveMessage = function(name, message)
	{
		$("<li><h3>" + name + "</h3><p><strong>" + message + "</strong></p></li>").prependTo("#messages");
		$('#messages').listview('refresh');
	}
});
