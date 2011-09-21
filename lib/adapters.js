var models = require("./models");
var mongo = require('mongodb')
var mysql = require("mysql");

var MongodbAdapter = new Class
({
	Extends: models.Adapter,
	
	initialize: function()
	{
		this.db = new mongo.Db('test', new mongo.Server("127.0.0.1", mongo.Connection.DEFAULT_PORT, {}), {});
	}
	
	save: function(model)
	{},
	
	find: function(conditions)
	{
		this.db.open(function(err, db) 
		{
			console.log("connected!");
			this.db.collection('coll1', function(err, collection) 
			{
				collection.find({}, function(err, cursor) 
				{
					cursor.toArray(function(err, items) 
					{
						console.log(items);
					});
				});
			});
		});
	},
	
	remove: function(model)
	{}
});

var MysqlAdapter = new Class
({
	Extends: models.Adapter,
	
	initialize: function()
	{
		this.db = mysql.createClient(
		{
			user: "root",
			password: "vyjujgbdf",
			database: "nodejs_db"
		});
	}
	
	save: function(model)
	{
		this.db.query(
		  'INSERT INTO t1 values (2, "stas")'
		);
	},
	
	find: function(conditions)
	{
		this.db.query
		(
		  'SELECT * FROM t1',
		  function selectCb(err, results, fields) {
			if (err) {
			  throw err;
			}
			console.log(results);
			console.log(fields);
			this.db.end();
		  }
		);
	},
	
	remove: function(model)
	{}
});

exports.MongodbAdapter = MongodbAdapter;
exports.MysqlAdapter = MysqlAdapter;
