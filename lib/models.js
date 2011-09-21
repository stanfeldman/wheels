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

Model.find = function(conditions)
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
	{ throw new TypeError("You must override this method"); },
	
	find: function(conditions)
	{ throw new TypeError("You must override this method"); },
	
	remove: function(model)
	{ throw new TypeError("You must override this method"); }
});

exports.Model = Model;
exports.Manager = Manager;
exports.Adapter = Adapter;
