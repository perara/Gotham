(function() {
  var Menu, Preload, State, VolumeAdjuster, config;

  State = require('./lib/state.coffee');

  Preload = require('./lib/preload.coffee');

  Menu = require('./lib/menu.coffee');

  config = require('./lib/config.coffee');

  VolumeAdjuster = require('./lib/VolumeAdjuster.coffee');

  $(document).ready(function() {
    var game;
    game = new Phaser.Game(config.width, config.height, Phaser.AUTO);
    game.state.add('preload', Preload, true);
    game.state.add('game', State, true);
    game.state.add('menu', Menu, true);
    game.state.start('preload');
    game.addModule = function(moduleName, moduleObject) {
      if (!game.modules) {
        game.modules = {};
      }
      return game.modules[moduleName] = moduleObject;
    };
    game.getModule = function(moduleName) {
      if (!game.modules[moduleName]) {
        console.log("Could not find module " + moduleName);
      }
      return game.modules[moduleName];
    };
    game.addModule("volumeAdjuster", VolumeAdjuster);
    return $(window).resize(function() {
      game.width = $(window).width();
      return game.height = $(window).height();
    });
  });

}).call(this);

//# sourceMappingURL=main.js.map
