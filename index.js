require("coffee-script");
exports.core = require('./lib/core');
exports.controllers = require('./lib/controllers');
exports.controllers.rpc = require('now');
exports.views = require('./lib/views');
exports.models = require('./lib/models');
exports.models.adapters = require("./lib/adapters");
