$(document).ready(function()
{
	now.name = "user";
	function send()
	{
		now.name = $("#username").val();
		now.distributeMessage($("#text-input").val());
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
