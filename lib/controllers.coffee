url = require "url"

class Router
	@instance: undefined
	
	constructor: (urls) ->
		if Router.instance isnt undefined
			return Router.instance
		@urls = @compile_keys @flatten_keys urls
		Router.instance = this
	
	middleware: () ->
		return (req, res, next) =>
			is_ok = @urls.some (x) ->
		        match = x[0].exec url.parse(req.url).pathname
		        if match
		            if !x[1] or x[1] is req.method
		                x[2][req.method.toLowerCase()] req, res, match.slice(1)...
		                return true
		        return false
		    if not is_ok
		    	next()

	flatten_keys: (obj, acc, prefix, prev_method) ->
		acc = acc || []
		prefix = prefix || ''
		Object.keys(obj).forEach((k) =>
		    split = @split_url k
		    if obj[k].constructor.name isnt "Object" and obj[k].constructor.name isnt "Function"
		        acc.push [prefix + split.url, split.method || prev_method, obj[k]]
		    else
		    	@flatten_keys obj[k], acc, prefix + split.url, split.method
		)
		return acc

	compile_keys: (urls) ->
		return urls.map((url) ->
		    pattern = url[0].replace "\/:\w+", '(?:/([^\/]+))'
		    url[0] = new RegExp '^' + pattern + '$'
		    return url
		)
		
	split_url: (url) ->
		method = path = match = /^([A-Z]+)(?:\s+|$)/.exec url
		if match
		    method = match[1]
		    path = "^[A-Z]+\s+(.*)$".exec url
		    url = ""
		    if path
		    	url = path[1]
		res =
			url: url
			method: method
		return res
		
exports.Router = Router

