(function() {
  var Menu, config;

  config = require('./config.coffee');

  Menu = (function() {
    function Menu(game) {}

    Menu.prototype.preload = function() {};

    Menu.prototype.create = function() {
      var audio;
      this.game.add.tileSprite(0, 0, this.game.width, this.game.height, 'menu_background');
      audio = this.game.add.audio('menu_theme', 0.1).play();
      audio.volume = 10;
      return new this.game.getModule("volumeAdjuster")(this.game);
    };

    Menu.prototype.update = function() {};

    module.exports = Menu;

    return Menu;

  })();

}).call(this);

//# sourceMappingURL=menu.js.map
