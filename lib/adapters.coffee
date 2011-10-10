mongo = require 'mongodb'
mysql = require "mysql"

class MongodbAdapter
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

class MysqlAdapter
	constructor: (options) ->
		@db = mysql.createClient(options)
		for obj in options.objects
			fields = ""
			for key, value of obj
				fields += key + " "
				switch value.constructor.name
					when "String"
						fields += "varchar(250),"
					when "Number"
						if /\./.test value
							fields += "float,"
						else fields += "int,"
			table = obj.constructor.name
			query = "create table if not exists " + table + " (" +
				"id int not null auto_increment," +
				fields +
				"primary key(id)" +
				")"
			@db.query query, (err) =>
				err? console.log "Error: " + err
				@db.end()
	
	save: (model, callback) ->
		table = model.constructor.name
		fields = ""
		for key, value of model 
			if value.constructor.name in ["String", "Number"]
				fields += key + " = '" + value + "',"
		fields = fields.substring 0, fields.length-1
		query = "insert into " + table + " set " + fields
		console.log query
		@db.query query, (err) =>
			err? console.log "Error: " + err
			@db.end()
			model.id = 555
			callback null, model
	
	find: (conditions, callback) ->
	###
		@db.query 'SELECT * FROM t1',
			(err, results, fields) =>
				console.log results
				console.log fields
				callback null, { id: 5 }
				@db.end()
				###
				
	remove: (model) ->
		console.log "remove"

exports.MysqlAdapter = MysqlAdapter
