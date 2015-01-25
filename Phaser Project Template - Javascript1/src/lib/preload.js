(function() {
  var Preload, config;

  config = require('./config.coffee');

  Preload = (function() {
    function Preload(game) {}

    Preload.prototype.preload = function() {
      var audioName, imageName, path, preloadBar, preloadLabel, _ref, _ref1, _results;
      preloadBar = this.game.add.sprite(config.width / 2, config.height / 2, 'preload');
      preloadLabel = this.game.add.text(config.width / 2, (config.height / 2) + 50, "0%", {
        font: "30px Arial",
        fill: "#ffffff"
      });
      this.game.load.setPreloadSprite(preloadBar, 0);
      this.game.load.onFileComplete.add(function(progress) {
        return preloadLabel.text = progress + "%";
      });
      _ref = config.images;
      for (imageName in _ref) {
        path = _ref[imageName];
        this.game.load.image(imageName, path);
      }
      _ref1 = config.audio;
      _results = [];
      for (audioName in _ref1) {
        path = _ref1[audioName];
        _results.push(this.game.load.audio(audioName, path));
      }
      return _results;
    };

    Preload.prototype.create = function() {
      return this.game.state.start('menu');
    };

    Preload.prototype.update = function() {};

    module.exports = Preload;

    return Preload;

  })();

}).call(this);

//# sourceMappingURL=preload.js.map
