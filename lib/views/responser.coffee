class Responser
	@instance: undefined
	
	constructor: ->
		if Responser.instance isnt undefined
			return Responser.instance
		Responser.instance = this
		
	middleware: ->
		return (req, res, next) =>
			@update(res)
			next()
			
	update: (res) ->
		res._headers = {'Content-Type': 'text/html'}
		res._status = 200

		withStatus = (code) ->
		    return (data) ->
		        if data then res.status(code).send(data) else res.status(code)

		redirection = (code, message) ->
		    return (loc) ->
		        res._headers.Location = loc
		        res.status(code).send """
		            <html>
		                <head>
		                    <title>#{code} #{message}</title>
		                </head>
		                <body>
		                    <p>
		                        #{message}:
		                        <a href="#{loc}">#{loc}</a>
		                    </p>
		                </body>
		            </html>
		        """

		withType = (type) ->
		    return (data) ->
		        res.headers {'Content-Type': type}
		        if data then res.send(data) else res

		res.status = (code) ->
		    res._status = code
		    return res

		res.headers = (headers) ->
			for k,v of headers
				res._headers[k] = v
			return res

		res.ok = withStatus 200
		res.created = withStatus 201
		res.accepted = withStatus 202

		res.moved = redirection 301, 'Moved Permanently'
		res.redirect = redirection 302, 'Found'
		res.found = res.redirect
		res.notModified = ->
			res.status(304).send()

		res.badRequest = withStatus 400
		res.unauthorized = withStatus 401
		res.forbidden = withStatus 403
		res.notFound = withStatus 404
		res.notAllowed = withStatus 405
		res.conflict = withStatus 409
		res.gone = withStatus 410

		res.error = withStatus 500, 'error'

		res.text = withType 'text/plain'
		res.plain = res.text
		res.html = withType 'text/html'
		res.xhtml = withType 'application/xhtml+xml'
		res.css = withType 'text/css'
		res.xml = withType 'text/xml'
		res.atom = withType 'application/atom+xml'
		res.rss = withType 'application/rss+xml'
		res.javascript = withType 'text/javascript'
		res.json = withType 'application/json'

		res.send = (data) ->
		    if(res._headers['Content-Type'] is 'application/json' and typeof data is 'object')
		        data = JSON.stringify data
		    res.writeHead res._status, res._headers
		    if(data) 
		    	res.end data
		    else
		    	res.end()
		    return null

module.exports = Responser

