require("mootools.js").apply(GLOBAL);

var Model = new Class
({
	initialize: function(options)
	{
		this.manager = new Manager();
	},
	
	save: function(model)
	{
		this.manager.save(this);
	},
	
	remove: function(model)
	{
		this.manager.remove(this);
	}
});
Model.find: function(conditions)
{
	conditions.model = this;
	new Manager().find(conditions);
};

var Manager = new Class
({
	initialize: function(options)
	{
		if(typeof Manager.instance == "object")
			return Manager.instance;
		this.options = options;
		Manager.instance = this;
	},
	
	save: function(model)
	{},
	
	find: function(conditions)
	{},
	
	remove: function(model)
	{}
});

var Adapter = new Class
({
	save: function(model)
	{},
	
	find: function(conditions)
	{},
	
	remove: function(model)
	{}
});

exports.Manager = Model;
