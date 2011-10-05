mysql = require "mysql"

class MysqlAdapter
	constructor: (options) ->
		@db = mysql.createClient(options)
		for cl in options.classes
			tablename = new cl().constructor.name
			query = "create table if not exists " + tablename + " (" +
				"id int not null auto_increment," +
				"primary key(id)" +
				")"
			@db.query query
	
	save: (model, callback) ->
		#@db.query 'INSERT INTO t1 values (2, "stas")'
		model.id = 555
		callback null, model
	
	find: (conditions, callback) ->
		@db.query 'SELECT * FROM t1',
			(err, results, fields) =>
				console.log results
				console.log fields
				callback null, { id: 5 }
				@db.end()
				
	remove: (model) ->
		console.log "remove"

exports.MysqlAdapter = MysqlAdapter
