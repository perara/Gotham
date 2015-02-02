(function() {
  module.exports = {
    width: $(window).width(),
    height: $(window).height(),
    stage: {
      backgroundColor: 0x222222
    },
    images: {
      game_circle: 'assets/img/circle.png',
      game_block: 'assets/img/block.png',
      menu_background: 'assets/img/menu_background.jpg'
    },
    audio: {
      menu_theme: 'assets/audio/menu.mp3'
    },
    networking: {
      host: 'localhost',
      port: 9999
    }
  };

}).call(this);

//# sourceMappingURL=config.js.map
