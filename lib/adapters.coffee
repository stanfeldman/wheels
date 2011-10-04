mysql = require "mysql"

class MysqlAdapter
	constructor: (options) ->
		@db = mysql.createClient(options)
	
	save: (model, callback) ->
		#@db.query 'INSERT INTO t1 values (2, "stas")'
		model.id = 555
		callback null, model
	
	find: (conditions) ->
		@db.query 'SELECT * FROM t1',
			(err, results, fields) =>
				console.log results
				console.log fields
				@db.end()
				
	remove: (model) ->
		console.log "remove"

exports.MysqlAdapter = MysqlAdapter
