require.paths.push('/usr/lib/node_modules');
var kiss = require("kiss.js");
var controllers = require("./controllers");

var mapping = 
{
    "/$": controllers.Controller1,
    "/2/?$": controllers.Controller2,
    "/(\\d+).(\\d+)/?$": controllers.Controller2
};
var app = new kiss.core.Application(mapping);
app.start("127.0.0.1", 1337);
