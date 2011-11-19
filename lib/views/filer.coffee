fs = require "fs"

class Filer
	constructor: (options) ->
		@static_path = options.static_path
	
	middleware: ->
		return (req, res, next) =>
			res.file = (filepath, options) =>
				res.setHeader 'Content-disposition', 'attachment; filename=' + options.filename
				#res.setHeader 'Content-type', @mimetype
				filestream = fs.createReadStream filepath
				filestream.on 'data', (chunk) =>
					res.write chunk
				filestream.on 'end', ->
					res.end()
					if options.delete_after
						fs.unlink filepath
					return true
			next()
	
	render: (req, res, options) ->
		res.setHeader 'Content-disposition', 'attachment; filename=' + options.filename
		filestream = fs.createReadStream this.file
		filestream.on 'data', (chunk) =>
			res.write chunk
		filestream.on 'end', ->
			res.end()
			
exports.Filer = Filer
