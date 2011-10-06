mysql = require "mysql"

class MysqlAdapter
	constructor: (options) ->
		@db = mysql.createClient(options)
		for obj in options.objects
			for key, value of obj
				console.log key + ": " + value + "/" + typeof value
			tablename = obj.constructor.name
			query = "create table if not exists " + tablename + " (" +
				"id int not null auto_increment," +
				"primary key(id)" +
				")"
			@db.query query, (err) =>
				err? console.log "Error: " + err
				@db.end()
	
	save: (model, callback) ->
		#for key, value of model
		#	console.log key + ": " + value
		#@db.query 'INSERT INTO t1 values (2, "stas")'
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
