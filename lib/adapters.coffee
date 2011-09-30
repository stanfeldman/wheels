models = require "./models"
mongo = require 'mongodb'
mysql = require "mysql"

class MongodbAdapter extends models.Adapter
	constructor: (options) ->
		@db = new mongo.Db 'test', (new mongo.Server "127.0.0.1", mongo.Connection.DEFAULT_PORT, {}), {}
	
	save: (model) ->
		console.log "save"
	
	find: (conditions) ->
		@db.open (err, db) =>
			console.log "connected!"
			@db.collection 'coll1', (err, collection) ->
				collection.find {}, (err, cursor) ->
					cursor.toArray (err, items) ->
						console.log(items);
	
	remove: (model) ->
		console.log "remove"

class MysqlAdapter extends models.Adapter
	constructor: (options) ->
		options = 
			user: "root"
			password: "vyjujgbdf"
			database: "nodejs_db"
		@db = mysql.createClient(options)
	
	save: (model) ->
		@db.query 'INSERT INTO t1 values (2, "stas")'
	
	find: (conditions) ->
		@db.query 'SELECT * FROM t1',
			(err, results, fields) =>
				console.log results
				console.log fields
				@db.end()
				
	remove: (model) ->
		console.log "remove"

exports.MongodbAdapter = MongodbAdapter
exports.MysqlAdapter = MysqlAdapter
