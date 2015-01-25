(function() {
  var VolumeAdjuster, config;

  config = require('./config.coffee');

  VolumeAdjuster = (function() {
    function VolumeAdjuster(game) {
      this.game = game;
      this.create();
    }

    VolumeAdjuster.prototype.create = function() {
      return this.game.add.sprite(20, 20, 'circle');
    };

    VolumeAdjuster.prototype.update = function() {};

    return VolumeAdjuster;

  })();

  module.exports = VolumeAdjuster;

}).call(this);

//# sourceMappingURL=VolumeAdjuster.js.map
