var models = require("./models");

var MongodbAdapter = new Class
({
	Extends: models.Adapter,
	
	save: function(model)
	{},
	
	find: function(conditions)
	{},
	
	remove: function(model)
	{}
});

exports.MongodbAdapter = MongodbAdapter;
