mysql = require "mysql"

class MysqlAdapter
	constructor: (options) ->
		@db = mysql.createClient(options)
		for obj in options.objects
			fields = ""
			for key, value of obj
				console.log key + ": " + value + "/" + value.constructor.name
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
