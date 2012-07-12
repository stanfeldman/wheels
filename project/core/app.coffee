kiss = require "../../../kiss.js"
settings = require "./settings"

app = new kiss.core.application.Application(settings.options)
app.start()
