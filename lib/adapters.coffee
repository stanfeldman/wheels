mysql = require "mysql"

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
