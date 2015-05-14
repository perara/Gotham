(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
Array.prototype.remove = function() {
  var L, a, ax, what;
  what = void 0;
  a = arguments;
  L = a.length;
  ax = void 0;
  while (L && this.length) {
    what = a[--L];
    while ((ax = this.indexOf(what)) !== -1) {
      this.splice(ax, 1);
    }
  }
  return this;
};

Array.prototype.last = function() {
  return this[this.length - 1];
};


},{}],2:[function(require,module,exports){
PIXI.Container.prototype.onWheelScroll = function() {};

PIXI.Container.prototype.bringToFront = function() {
  var parent;
  if (this.parent) {
    parent = this.parent;
    parent.removeChild(this);
    return parent.addChild(this);
  }
};

PIXI.Container.prototype.bringToBack = function() {
  var b, parent;
  if (this.parent) {
    parent = this.parent;
    b = parent.children[0];
    parent.addChildAt(this, 0);
    return parent.addChild(b);
  }
};

PIXI.Container.prototype.onInteractiveChange = null;

PIXI.Container.prototype.setInteractive = function(state) {
  var item, queue, _results;
  if (this.onInteractiveChange) {
    this.onInteractiveChange(state);
  }
  queue = [];
  queue.push(this);
  _results = [];
  while (queue.length > 0) {
    item = queue.pop();
    queue.push.apply(queue, item.children);
    item.interactive = state;
    if (!state) {
      item.__click = item.click;
      item.__mousedown = item.mousedown;
      item.__mouseup = item.mouseup;
      item.click = null;
      item.mousedown = null;
      _results.push(item.mouseup = null);
    } else {
      item.click = item.__click;
      item.mousedown = item.__mousedown;
      item.mouseup = item.__mouseup;
      item.__click = null;
      item.__mousedown = null;
      _results.push(item.__mouseup = null);
    }
  }
  return _results;
};

PIXI.Container.prototype.addChildArray = function(array) {
  var child, _i, _len, _results;
  _results = [];
  for (_i = 0, _len = array.length; _i < _len; _i++) {
    child = array[_i];
    _results.push(this.addChild(child));
  }
  return _results;
};

PIXI.Container.prototype.onMouseMove = function() {};

PIXI.Container.prototype.setPanning = function(callback) {
  var prevX, prevY, that;
  that = this;
  this.isDragging = false;
  prevX = void 0;
  prevY = void 0;
  that.offset = {
    x: 0,
    y: 0
  };
  that.diff = {
    x: 0,
    y: 0
  };
  this.mousedown = function(e) {
    var pos;
    that.previousPosition = {
      x: that.position.x,
      y: that.position.y
    };
    pos = e.data.getLocalPosition(this.parent);
    prevX = pos.x;
    prevY = pos.y;
    return this.isDragging = true;
  };
  this.mouseup = function(e) {
    return this.isDragging = false;
  };
  this.mouseout = function(e) {
    return this.isDragging = false;
  };
  return this.mousemove = function(e) {
    var newPosition, pos, results;
    this.onMouseMove(e);
    if (!this.isDragging) {
      return;
    }
    pos = e.data.getLocalPosition(this.parent);
    that.diff.x = pos.x - prevX;
    that.diff.y = pos.y - prevY;
    newPosition = {
      x: that.position.x + that.diff.x,
      y: that.position.y + that.diff.y
    };
    results = callback(newPosition);
    if (results.x) {
      that.position.x = newPosition.x;
      prevX = pos.x;
      that.offset.x += that.diff.x;
    }
    if (results.y) {
      that.position.y = newPosition.y;
      prevY = pos.y;
      return that.offset.y += that.diff.y;
    }
  };
};

PIXI.Container.prototype.onMouseDown = function() {};

PIXI.Container.prototype.onMouseUp = function() {};

PIXI.Container.prototype.onMove = function() {};

PIXI.Container.prototype.movable = function() {
  if (!this.interactive) {
    this.interactive = true;
  }
  this.mousedown = this.touchstart = function(e) {
    this.dragging = true;
    this._sx = e.data.getLocalPosition(this).x * this.scale.x;
    this._sy = e.data.getLocalPosition(this).y * this.scale.y;
    return this.onMouseDown(e);
  };
  this.mouseup = this.mouseupoutside = this.touchend = this.touchendoutside = function(data) {
    this.alpha = 1;
    this.dragging = false;
    this.data = null;
    return this.onMouseUp(data);
  };
  return this.mousemove = this.touchmove = function(e) {
    var newPosition;
    if (this.dragging) {
      newPosition = e.data.getLocalPosition(this.parent);
      this.position.x = newPosition.x - this._sx;
      this.position.y = newPosition.y - this._sy;
      return this.onMove(e);
    }
  };
};


},{}],3:[function(require,module,exports){
$.fn.selectRange = function(start, end) {
  if (!end) {
    end = start;
  }
  return this.each(function() {
    var range;
    if (this.setSelectionRange) {
      this.focus();
      this.setSelectionRange(start, end);
    } else if (this.createTextRange) {
      range = this.createTextRange();
      range.collapse(true);
      range.moveEnd('character', end);
      range.moveStart('character', start);
      range.select();
    }
  });
};

jQuery.fn.putCursorAtEnd = function() {
  return this.each(function() {
    var len;
    $(this).focus();
    if (this.setSelectionRange) {
      len = $(this).val().length * 2;
      this.setSelectionRange(len, len);
    } else {
      $(this).val($(this).val());
    }
    this.scrollTop = 999999;
  });
};


},{}],4:[function(require,module,exports){

/*
 * object.watch polyfill
 *
 * 2012-04-03
 *
 * By Eli Grey, http://eligrey.com
 * Public Domain.
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */
if (!Object.prototype.watch) {
  Object.defineProperty(Object.prototype, 'watch', {
    enumerable: false,
    configurable: true,
    writable: false,
    value: function(prop, handler) {
      var getter, newval, oldval, setter;
      oldval = this[prop];
      newval = oldval;
      getter = function() {
        return newval;
      };
      setter = function(val) {
        oldval = newval;
        return newval = handler.call(this, prop, oldval, val);
      };
      if (delete this[prop]) {
        Object.defineProperty(this, prop, {
          get: getter,
          set: setter,
          enumerable: true,
          configurable: true
        });
      }
    }
  });
}

if (!Object.prototype.unwatch) {
  Object.defineProperty(Object.prototype, 'unwatch', {
    enumerable: false,
    configurable: true,
    writable: false,
    value: function(prop) {
      var val;
      val = this[prop];
      delete this[prop];
      this[prop] = val;
    }
  });
}


},{}],5:[function(require,module,exports){
PIXI.WebGLRenderer.prototype.wheelScrollObjects = [];

PIXI.WebGLRenderer.prototype.addWheelScrollObject = function(object) {
  return this.wheelScrollObjects.push(object);
};

PIXI.WebGLRenderer.prototype.setWheelScroll = function(state) {
  return $(window).bind('mousewheel DOMMouseScroll', function(event) {
    var object, _i, _len, _ref, _results;
    if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0) {
      event.originalEvent.wheelDelta = 1;
      event.wheelDeltaY = 1;
    } else {
      event.originalEvent.wheelDelta = -1;
      event.wheelDeltaY = -1;
    }
    if (state) {
      _ref = PIXI.WebGLRenderer.prototype.wheelScrollObjects;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        object = _ref[_i];
        _results.push(object.onWheelScroll(event));
      }
      return _results;
    }
  });
};

PIXI.CanvasRenderer.prototype.wheelScrollObjects = [];

PIXI.CanvasRenderer.prototype.addWheelScrollObject = function(object) {
  return this.wheelScrollObjects.push(object);
};

PIXI.CanvasRenderer.prototype.setWheelScroll = function(state) {
  return $(window).bind('mousewheel DOMMouseScroll', function(event) {
    var object, _i, _len, _ref, _results;
    if (event.originalEvent.wheelDelta > 0 || event.originalEvent.detail < 0) {
      event.originalEvent.wheelDelta = 1;
      event.wheelDeltaY = 1;
    } else {
      event.originalEvent.wheelDelta = -1;
      event.wheelDeltaY = -1;
    }
    if (state) {
      _ref = PIXI.WebGLRenderer.prototype.wheelScrollObjects;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        object = _ref[_i];
        _results.push(object.onWheelScroll(event));
      }
      return _results;
    }
  });
};


},{}],6:[function(require,module,exports){
String.prototype.contains = function(it) {
  return this.indexOf(it) !== -1;
};

String.prototype.startsWith = function(str) {
  return this.slice(0, str.length) === str;
};

String.prototype.endsWith = function(str) {
  return this.slice(-str.length) === str;
};

String.prototype.camelCase = function() {
  return this.replace(/(?:^\w|[A-Z]|\b\w)/g, function(letter, index) {
    if (index === 0) {
      return letter.toLowerCase();
    } else {
      return letter.toUpperCase();
    }
  }).replace(/\s+/g, '');
};

String.prototype.toTitleCase = function() {
  return this.replace(/\w\S*/g, function(txt) {
    return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
  });
};


},{}],7:[function(require,module,exports){
var Gotham, args;

require('./Extensions/Container.coffee');

require('./Extensions/PixiRenderer.coffee');

require('./Extensions/Array.coffee');

require('./Extensions/Object.coffee');

require('./Extensions/String.coffee');

require('./Extensions/JQuery.coffee');


/**
 * Acs as a namespace class,
 * @class Gotham
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 */

Gotham = (function() {
  function Gotham() {}

  window.Gotham = Gotham;

  Gotham.VERSION = "1.0";

  Gotham.Running = true;

  Gotham.Graphics = {
    Renderer: require('./Modules/Renderer.coffee'),
    Scene: require('./Modules/Scene.coffee'),
    Container: require('./Modules/Graphics/Container.coffee'),
    Graphics: require('./Modules/Graphics/Graphics.coffee'),
    Polygon: require('./Modules/Graphics/Polygon.coffee'),
    Rectangle: require('./Modules/Graphics/Rectangle.coffee'),
    Sprite: require('./Modules/Graphics/Sprite.coffee'),
    Text: require('./Modules/Graphics/Text.coffee'),
    Texture: require('./Modules/Graphics/Texture.coffee'),
    Tools: require('./Modules/Graphics/Tools.coffee')
  };

  Gotham.Controls = {
    Button: require('./Modules/Controls/Button.coffee'),
    Slider: require('./Modules/Controls/Slider.coffee')
  };

  Gotham.Pattern = {
    MVC: {
      Controller: require('./Modules/Pattern/MVC/Controller.coffee'),
      View: require('./Modules/Pattern/MVC/View.coffee')
    }
  };

  Gotham.Sound = require('./Modules/Sound.coffee');

  Gotham.Tween = require('./Modules/Tween/Tween.coffee');

  Gotham.Util = require('./Util/Util.coffee');

  Gotham.Network = require('./Modules/Network.coffee');

  Gotham.Database = new (require('./Modules/Database.coffee'))();

  Gotham.GameLoop = new (require('./Modules/GameLoop.coffee'))();

  Gotham.Preload = new (require('./Modules/Preload.coffee'))();

  return Gotham;

})();

if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
  args = ['%c %c %c Gotham Game Framework %c %c %c', 'background: #323232; padding:5px 0;', 'background: #323232; padding:5px 0;', 'color: #4169e1; background: #030307; padding:5px 0;', 'background: #323232; padding:5px 0;', 'background: #323232; padding:5px 0;', 'color: #4169e1; background: #030307; padding:5px 0;'];
  window.console.log.apply(console, args);
} else if (window.console) {
  window.console.log("Gotham Game Framework " + this.VERSION + " - http://gotham.no");
}

module.exports = window.Gotham = Gotham;


},{"./Extensions/Array.coffee":1,"./Extensions/Container.coffee":2,"./Extensions/JQuery.coffee":3,"./Extensions/Object.coffee":4,"./Extensions/PixiRenderer.coffee":5,"./Extensions/String.coffee":6,"./Modules/Controls/Button.coffee":8,"./Modules/Controls/Slider.coffee":9,"./Modules/Database.coffee":10,"./Modules/GameLoop.coffee":11,"./Modules/Graphics/Container.coffee":12,"./Modules/Graphics/Graphics.coffee":13,"./Modules/Graphics/Polygon.coffee":14,"./Modules/Graphics/Rectangle.coffee":15,"./Modules/Graphics/Sprite.coffee":16,"./Modules/Graphics/Text.coffee":17,"./Modules/Graphics/Texture.coffee":18,"./Modules/Graphics/Tools.coffee":19,"./Modules/Network.coffee":20,"./Modules/Pattern/MVC/Controller.coffee":21,"./Modules/Pattern/MVC/View.coffee":22,"./Modules/Preload.coffee":23,"./Modules/Renderer.coffee":24,"./Modules/Scene.coffee":25,"./Modules/Sound.coffee":26,"./Modules/Tween/Tween.coffee":27,"./Util/Util.coffee":28}],8:[function(require,module,exports){

/**
 * Button Control. Predefined button which can be easily manipulated for custom stuff.
 * @class Button
 * @module Framework
 * @submodule Framework.Controls
 * @namespace Gotham.Controls
 * @extends Gotham.Graphics.Sprite
 * @constructor
 * @param text {String} Text label of the button
 * @param width {Number} Width of the button
 * @param height {Number} Height of the button
 * @param [options] {Object} Options of the button
 * @param [options.toggle=true] {Boolean} Weither the button is a toggle button or click button
 * @param [options.textSize=40] {Number} Size of the text label
 * @param [options.texture=null] {Gotham.Graphics.Texture} Which texture to apply to the button
 * @param [options.offset=0] {Number} Offset of the button in pixels
 * @param [options.margin=0] {Number} Margin of the button
 * @param [options.alpha=1] {Number} Alpha of the button (Between 0 an 1)
 */
var Button,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Button = (function(_super) {
  __extends(Button, _super);

  function Button(text, width, height, options) {
    var button_text, that, _alpha, _buttonColor, _margin, _offset, _textSize, _texture, _toggle;
    that = this;
    options = options == null ? {} : options;
    _toggle = options.toggle != null ? options.toggle : true;
    _textSize = options.textSize != null ? options.textSize : 40;
    _texture = options.texture != null ? options.texture : null;
    _buttonColor = options.buttonColor != null ? options.buttonColor : 0x000000;
    _offset = options.offset ? options.offset : 0;
    _margin = options.margin ? options.margin : 0;
    _alpha = options.alpha != null ? options.alpha : 1;
    this.margin = _margin;
    if (_texture == null) {
      _texture = new Gotham.Graphics.Graphics;
      _texture.beginFill(_buttonColor, _alpha);
      _texture.drawRect(0, 0, 100, 50);
      _texture.endFill();
      _texture = _texture.generateTexture();
    }
    Button.__super__.constructor.call(this, _texture);
    this.width = width;
    this.height = height;
    this.interactive = true;
    button_text = new Gotham.Graphics.Text(text, {
      font: "bold " + _textSize + "px Calibri",
      fill: "#ffffff",
      align: "left",
      dropShadow: true
    });
    button_text.position.x = ((this.width / this.scale.x) / 2) + _offset;
    button_text.position.y = (this.height / this.scale.y) / 2;
    button_text.width = this.width / this.scale.x;
    button_text.height = this.height / this.scale.y;
    button_text.anchor = {
      x: 0.5,
      y: 0.5
    };
    this.addChild(button_text);
    this.label = button_text;
    this.click = function(e) {
      if (!_toggle) {
        this.onClick();
        return;
      }
      this._toggleState = !this._toggleState;
      if (this._toggleState) {
        return this.toggleOn();
      } else {
        return this.toggleOff();
      }
    };
  }

  Button.prototype.setBackground = function(hex) {
    return this.tint = hex;
  };

  Button.prototype.onClick = function() {};

  Button.prototype.toggleOn = function() {};

  Button.prototype.toggleOff = function() {};

  return Button;

})(Gotham.Graphics.Sprite);

module.exports = Button;


},{}],9:[function(require,module,exports){

/**
 * Slider control is a control which can be dragged from 0 to 100. For example a volume control
 * @class Slider
 * @module Framework
 * @submodule Framework.Controls
 * @namespace Gotham.Controls
 * @extends Gotham.Graphics.Sprite
 * @constructor
 * @param knobTexture {Gotham.Graphics.Texture} Texture of the knob
 * @param background {Gotham.Graphics.Texture} Background texture
 */
var Slider,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Slider = (function(_super) {
  __extends(Slider, _super);

  function Slider(knobTexture, background) {
    var knob, progress_text, that;
    Slider.__super__.constructor.apply(this, arguments);
    that = this;
    this.onProgress = null;
    this.progress = 0;
    this.texture = background;
    this.tint = 0xFFFF00;
    knob = this.knob = new Gotham.Graphics.Sprite(knobTexture);
    knob.width = this.height;
    knob.height = this.height;
    knob.setInteractive(true);
    progress_text = new Gotham.Graphics.Text("0%", {
      font: "bold 20px Arial",
      fill: "#ffffff",
      align: "left"
    });
    progress_text.x = this.width / 2;
    progress_text.y = this.height / 2;
    progress_text.anchor = {
      x: 0.5,
      y: 0.5
    };
    this.addChild(progress_text);
    knob.mousedown = knob.touchstart = function(e) {
      this.sx = e.data.getLocalPosition(this).x * this.scale.x;
      return this.dragging = true;
    };
    knob.mouseup = knob.mouseupoutside = knob.touchend = knob.touchendoutside = function(e) {
      return this.dragging = false;
    };
    knob.mousemove = knob.touchmove = function(e) {
      var newData, newX;
      if (this.dragging) {
        newData = e.data.getLocalPosition(this.parent);
        newX = newData.x - this.sx;
        if (newX * this.parent.scale.x > this.parent.width - (this.width * this.parent.scale.x) || newX < 0) {
          return;
        }
        this.x = newX;
        that.progress = Math.round(that.calculateProgress(this.x));
        progress_text.text = that.progress + "%";
        if (that.onProgress) {
          return that.onProgress(that.progress);
        }
      }
    };
    this.addChild(knob);
  }

  Slider.prototype.calculateProgress = function(x) {
    return ((x * this.scale.x) / (this.width - (this.knob.width * this.scale.x))) * 100;
  };

  return Slider;

})(Gotham.Graphics.Sprite);

module.exports = Slider;


},{}],10:[function(require,module,exports){

/**
 * The database utilizes lokiJS. Contains storage for all tables and easy to retrieve them when needed.
 * @class Database
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 */
var Database;

Database = (function() {
  function Database() {
    this.db = new loki();
    this._tables = {};
    return this;
  }

  Database.prototype.table = function(tableName) {
    if (!this._tables[tableName]) {
      this._tables[tableName] = this.db.addCollection(tableName, {
        indices: ['id']
      });
    }
    return this._tables[tableName];
  };

  Database.prototype.getTables = function() {
    return this._tables;
  };

  return Database;

})();

module.exports = Database;


},{}],11:[function(require,module,exports){

/**
 * GameLoop of the engine
 *
 * This is responsible for updating and drawing each frame of
 * the game, It does so by calling requestAnimationFrame.
 *
 * In Addition, it also handles the Tween ticks in its update loop
 *
 * @class GameLoop
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 */
var GameLoop;

GameLoop = (function() {
  function GameLoop(fps) {
    var animate, that;
    that = this;
    this.renderer = function() {};
    this._tasks = [];
    this.FPSMeter = new FPSMeter({
      decimals: 0,
      graph: true,
      theme: 'dark',
      left: "47%",
      top: "96%"
    });
    animate = function(time) {
      requestAnimationFrame(animate);
      return that.update(time);
    };
    requestAnimationFrame(animate);
  }

  GameLoop.prototype.setRenderer = function(renderer) {
    return this.renderer = renderer;
  };

  GameLoop.prototype.update = function(time) {
    var s, _i, _len, _ref, _task;
    this.FPSMeter.tickStart();
    _ref = this._tasks;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _task = _ref[_i];
      s = _task();
      if (!s) {
        this._tasks.remove(_task);
      }
    }
    Gotham.Tween.update(time);
    this.renderer();
    return this.FPSMeter.tick();
  };

  GameLoop.prototype.addTask = function(task) {
    return this._tasks.push(task);
  };

  return GameLoop;

})();

module.exports = GameLoop;


},{}],12:[function(require,module,exports){

/**
 * Container is just a wrapper around Pixi Container
 * @class Container
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Container
 */
var Container,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Container = (function(_super) {
  var _created;

  __extends(Container, _super);

  function Container() {
    return Container.__super__.constructor.apply(this, arguments);
  }

  _created = false;

  Container.prototype.create = function() {
    throw new Exception("Override Create Method");
  };

  Container.prototype.update = function() {
    throw new Exception("Override Update Method");
  };

  return Container;

})(PIXI.Container);

module.exports = Container;


},{}],13:[function(require,module,exports){

/**
 * Graphics class which inherits PIXI.Graphics
 * @class Graphics
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Graphics
 */
var Graphics,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Graphics = (function(_super) {
  __extends(Graphics, _super);

  function Graphics() {
    Graphics.__super__.constructor.apply(this, arguments);
    this._dx = 0;
    this._dy = 0;
  }

  return Graphics;

})(PIXI.Graphics);

module.exports = Graphics;


},{}],14:[function(require,module,exports){

/**
 * Polygon class which inherits {http://www.goodboydigital.com/pixijs/docs/classes/Polygon.html PIXI.Polyon}
 * @class Polygon
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Polygon
 */
var Polygon,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Polygon = (function(_super) {
  __extends(Polygon, _super);

  function Polygon() {
    Polygon.__super__.constructor.apply(this, arguments);
  }

  return Polygon;

})(PIXI.Polygon);

module.exports = Polygon;


},{}],15:[function(require,module,exports){

/**
 * Rectangle class which inherits PIXI.Rectangle
 * @class Rectangle
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Rectangle
 */
var Rectangle,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Rectangle = (function(_super) {
  __extends(Rectangle, _super);

  function Rectangle() {
    return Rectangle.__super__.constructor.apply(this, arguments);
  }

  return Rectangle;

})(PIXI.Rectangle);

module.exports = Rectangle;


},{}],16:[function(require,module,exports){

/**
 * Sprite class which extends PIXI Sprite. Includes a hover texture
 * @class Sprite
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Sprite
 * @constructor
 * @param texture {Gotham.Graphics.Texture} The default texture
 */
var Sprite,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Sprite = (function(_super) {
  __extends(Sprite, _super);

  function Sprite(texture) {
    Sprite.__super__.constructor.apply(this, arguments);
    this.hoverTexture = null;
    this.normalTexture = texture;
  }

  return Sprite;

})(PIXI.Sprite);

module.exports = Sprite;


},{}],17:[function(require,module,exports){

/**
 * Text class which inherits PIXI.Text
 * @class Text
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Text
 * @constructor
 * @param text {String} the text string
 * @param [style] {Object} The style parameters
 * @param [style.font] {String} default 'bold 20px Arial' The style and size of the font
 * @param [style.fill='black'] {String|Number} A canvas fillstyle that will be used on the text e.g 'red', '#00FF00'
 * @param [style.align='left'] {String} Alignment for multiline text ('left', 'center' or 'right'), does not affect single line text
 * @param [style.stroke] {String|Number} A canvas fillstyle that will be used on the text stroke e.g 'blue', '#FCFF00'
 * @param [style.strokeThickness=0] {Number} A number that represents the thickness of the stroke. Default is 0 (no stroke)
 * @param [style.wordWrap=false] {Boolean} Indicates if word wrap should be used
 * @param [style.wordWrapWidth=100] {Number} The width at which text will wrap, it needs wordWrap to be set to true
 * @param [style.dropShadow=false] {Boolean} Set a drop shadow for the text
 * @param [style.dropShadowColor='#000000'] {String} A fill style to be used on the dropshadow e.g 'red', '#00FF00'
 * @param [style.dropShadowAngle=Math.PI/4] {Number} Set a angle of the drop shadow
 * @param [style.dropShadowDistance=5] {Number} Set a distance of the drop shadow
 * @param x {Number} X Coordinate
 * @param y {Number} Y Coordinate
 */
var Text,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Text = (function(_super) {
  __extends(Text, _super);

  function Text(text, style, x, y) {
    Text.__super__.constructor.apply(this, arguments);
    this.text = text;
    this.position.x = x;
    this.position.y = y;
    if (style != null) {
      this.style = style;
    }
  }

  return Text;

})(PIXI.Text);

module.exports = Text;


},{}],18:[function(require,module,exports){

/**
 * Textue class which does nothing but leech on PIXI.Texture
 * @class Texture
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 * @extends PIXI.Texture
 * @constructor
 */
var Texture,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Texture = (function(_super) {
  __extends(Texture, _super);

  function Texture() {
    return Texture.__super__.constructor.apply(this, arguments);
  }

  return Texture;

})(PIXI.Texture);

module.exports = Texture;


},{}],19:[function(require,module,exports){

/**
 * Graphicsl Tool class for customized data manipulation
 * @class Tools
 * @module Framework
 * @submodule Framework.Graphics
 * @namespace Gotham.Graphics
 */
var Tools;

Tools = (function() {
  function Tools() {}

  Tools.polygonFromJSON = function(json, skipRatio, scale) {
    var count, key, point, pointList, polygon, polygonList, _i, _j, _key, _len, _len1;
    if (skipRatio == null) {
      skipRatio = 5;
    }
    if (scale == null) {
      scale = {
        x: 1,
        y: 1
      };
    }
    polygonList = new Array;
    for (key = _i = 0, _len = json.length; _i < _len; key = ++_i) {
      polygon = json[key];
      pointList = new Array;
      count = 0;
      for (_key = _j = 0, _len1 = polygon.length; _j < _len1; _key = ++_j) {
        point = polygon[_key];
        if (count++ % skipRatio === 0) {
          pointList.push(new PIXI.Point(point[0] / (scale.x * 1.0), point[1] / (scale.y * 1.0)));
        }
      }
      polygonList.push(new Gotham.Graphics.Polygon(pointList));
    }
    return polygonList;
  };

  Tools.polygonToGraphics = function(polygon, interactive) {
    var graphicsList, grp, key, minX, minY, point, polygonList, xory, _i, _j, _len, _len1, _ref;
    polygonList = [];
    graphicsList = [];
    if (polygon.constructor !== Array) {
      polygonList.push(polygon);
    } else {
      polygonList = polygon;
    }
    for (key = _i = 0, _len = polygonList.length; _i < _len; key = ++_i) {
      polygon = polygonList[key];
      xory = 0;
      minX = 10000000;
      minY = 10000000;
      _ref = polygon.points;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        point = _ref[_j];
        if (xory++ % 2 === 0) {
          if (point < minX) {
            minX = point;
          }
        } else {
          if (point < minY) {
            minY = point;
          }
        }
      }
      grp = new Gotham.Graphics.Graphics();
      grp.minX = minX;
      grp.minY = minY;
      graphicsList.push(grp);
      grp.lineStyle(2, 0x000000, 1);
      grp.beginFill(0xffffff, 1.0);
      grp.polygon = polygon;
      grp.drawPolygon(polygon.points);
      if (interactive != null) {
        grp.interactive = true;
        grp.buttonMode = true;
        grp.hitArea = new Gotham.Graphics.Polygon(polygon.points);
      }
    }
    return graphicsList;
  };

  return Tools;

})();

module.exports = Tools;


},{}],20:[function(require,module,exports){

/**
 * The network class is built ontop of SocketIO. Provides extra handling on connection and emits from rooms
 * @class Network
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 */
var Network;

Network = (function() {
  function Network(host, port) {
    var _ref;
    this.host = host;
    this.port = port;
    this.Socket = this._socket = null;
    this.hasConnectedOnce = false;
    this.onConnect = function() {};
    this.onReconnect = function() {};
    this.onReconnecting = function() {};
    this.onDisconnect = function() {};
    if ((_ref = !port) != null ? _ref : this.port = 8080) {

    } else {
      this.port = port;
    }
  }

  Network.prototype.connect = function() {
    var that;
    that = this;
    this.Socket = this._socket = io.connect("" + this.host + ":" + this.port);
    this._socket.on('connect', function() {
      if (that.hasConnectedOnce) {
        that.onReconnect(this);
      } else {
        that.onConnect(this);
      }
      return that.hasConnectedOnce = true;
    });
    this._socket.on('reconnecting', function() {
      return that.onReconnecting(this);
    });
    return this._socket.on('disconnect', function() {
      return that.onDisconnect(this);
    });
  };

  return Network;

})();

module.exports = Network;


},{}],21:[function(require,module,exports){

/**
 * Baseclass for the controller
 * @class Controller
 * @module Framework
 * @submodule Framework.Pattern.MVC
 * @namespace Gotham.Pattern.MVC
 * @constructor
 * @param View {Gotham.Pattern.MVC.View} The view object
 * @param name {String} Name of the Controller
 */
var Controller;

Controller = (function() {
  function Controller(View, name) {
    var ViewObject;
    ViewObject = new View(this);
    if (!ViewObject._v) {
      throw Error("View is missing in super constructor (Have your view inherited GothamGame.View ?");
    }
    this._created = false;
    this._processes = [];
    this.name = name;
    this.View = ViewObject;
  }

  Controller.prototype.create = function() {
    throw new Error("create() must be overriden");
  };

  Controller.prototype.addProcess = function(func) {
    return this._processes.push(func);
  };

  return Controller;

})();

module.exports = Controller;


},{}],22:[function(require,module,exports){

/**
 * Baseclass for the View
 * @class View
 * @module Framework
 * @submodule Framework.Pattern.MVC
 * @namespace Gotham.Pattern.MVC
 * @constructor
 * @param controller {Gotham.Pattern.MVC.Controller} The Controller Object
 * @extends Gotham.Graphics.Container
 */
var View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = (function(_super) {
  __extends(View, _super);

  function View(controller) {
    View.__super__.constructor.apply(this, arguments);
    this._v = true;
    this._created = false;
    this._processes = [];
    this.Controller = controller;
  }

  View.prototype.create = function() {
    throw new Error("create() must be overriden");
  };

  View.prototype.addProcess = function(func) {
    return this._processes.push(func);
  };

  return View;

})(Gotham.Graphics.Container);

module.exports = View;


},{}],23:[function(require,module,exports){

/**
 * Preload Class
 * This class contains storage for audio, video, image and json
 * It keeps track of current loaded object, and the total number of objects
 * It can serve these preloaded files on the fly.
 *
 * @class Preload
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @example
 *     Gotham.Preload.image("/assets/img/settings_close.png", "settings_close", "image")
 *     Gotham.Preload.json("/assets/json/json.json", "map")
 *
 * @example
 *   Gotham.Preload.fetch("map", "json")
 *   Gotham.Preload.fetch("settings_close", "image")
 *
 */
var Preload;

Preload = (function() {
  var downloadImage, downloadJSON, downloadSound;

  function Preload() {
    this.db_image = Gotham.Database.table("preload_images");
    this.db_audio = Gotham.Database.table("preload_audio");
    this.db_data = Gotham.Database.table("preload_data");
    this.onLoad = function() {};
    this.onComplete = function() {};
    this._numNetworkLoaded = 0;
    this._totalCount = 0;
  }

  Preload.prototype.getTotalCount = function() {
    return this._totalCount;
  };

  Preload.prototype.incrementTotalCount = function() {
    return this._totalCount++;
  };

  Preload.prototype.getNumLoaded = function() {
    var db, dbs, total, _i, _len;
    dbs = [this.db_audio, this.db_image, this.db_data];
    total = this._numNetworkLoaded;
    for (_i = 0, _len = dbs.length; _i < _len; _i++) {
      db = dbs[_i];
      total += db.data.length;
    }
    return total;
  };

  downloadJSON = function(url, callback) {
    return Gotham.Util.Ajax.GET(url, function(data, response) {
      return callback(data);
    });
  };

  downloadImage = function(url, callback) {
    var texture;
    texture = Gotham.Graphics.Texture.fromImage(url);
    return texture.addListener("update", function() {
      this.addListener("update", function() {});
      return callback(texture);
    });
  };

  downloadSound = function(url, options, callback) {
    var howlParameters, howler, sound;
    howlParameters = {
      urls: [url]
    };
    if (options != null) {
      howlParameters.merge(options);
    }
    howler = new Howl(howlParameters);
    sound = new Gotham.Sound(howler);
    sound._name = name;
    return howler.on('load', function() {
      return callback(sound);
    });
  };

  Preload.prototype._onComplete = function() {
    return this.onComplete();
  };

  Preload.prototype._onLoad = function(source, type, name) {
    var percent;
    percent = (this.getNumLoaded() / this.getTotalCount()) * 100.0;
    this.onLoad(source, type, name, percent);
    if (Math.round(percent) === 100) {
      return this._onComplete();
    }
  };

  Preload.prototype.isPreloadComplete = function() {
    return ((this._loadedObjects / this._totalObjects) * 100.0) === 100;
  };

  Preload.prototype.image = function(url, name) {
    var that;
    that = this;
    this.incrementTotalCount();
    return downloadImage(url, function(image) {
      that.db_image.insert({
        name: name,
        object: image,
        type: 'image'
      });
      return that._onLoad(image, 'Image', name);
    });
  };

  Preload.prototype.mp3 = function(url, name, options) {
    var that;
    that = this;
    this.incrementTotalCount();
    return downloadSound(url, options, function(sound) {
      that.db_audio.insert({
        name: name,
        object: sound,
        type: 'audio'
      });
      return that._onLoad(sound, 'Audio', name);
    });
  };

  Preload.prototype.json = function(url, name) {
    var that;
    that = this;
    this.incrementTotalCount();
    return downloadJSON(url, function(json) {
      that.db_data.insert({
        name: name,
        object: json,
        type: 'json'
      });
      return that._onLoad(json, 'JSON', name);
    });
  };

  Preload.prototype.network = function(name, table, socket) {
    var that;
    that = this;
    this.incrementTotalCount();
    socket.Socket.emit(name);
    return socket.Socket.on(name, function(data) {
      that._numNetworkLoaded = that._numNetworkLoaded + 1;
      if (typeof data === 'array') {
        table.merge(data);
      } else {
        table.insert(data);
      }
      return that._onLoad(data, 'Data', name);
    });
  };

  Preload.prototype.fetch = function(name, type) {
    var db;
    db = this.getDatabase(type);
    return db.findOne({
      name: name
    }).object;
  };

  Preload.prototype.getDatabase = function(type) {
    switch (type) {
      case "image":
        return this.db_image;
      case "audio":
        return this.db_audio;
      case "json":
        return this.db_data;
      default:
        throw new Error("Format Not Supported, Preload");
    }
  };

  return Preload;

})();

module.exports = Preload;


},{}],24:[function(require,module,exports){

/**
 * Renderer of the Gotham Game framework
 * Uses pixi's renderer which is then wrapped around
 * This is mostly an internal class for Gotham
 * @class Renderer
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @constructor
 * @param width [Integer] Width of the rendered area
 * @param height [Integer] Height of the rendered area
 * @param options [Object] Additional Option Parameters
 * @param autoResize [Boolean] Weither the renderer should automaticly resize to window size
 */
var Renderer;

Renderer = (function() {
  function Renderer(width, height, options, autoResize) {
    var label, rootScene, that;
    that = this;
    this.pixi = PIXI.autoDetectRenderer(width, height, {
      autoResize: true,
      antialias: true
    });
    window.renderer = this;
    this.pixi.setWheelScroll(true);
    window.addEventListener('contextmenu', function(e) {
      return e.preventDefault();
    });
    if (autoResize != null) {
      this.pixi.view.style.width = window.innerWidth + 'px';
      this.pixi.view.style.height = window.innerHeight + 'px';
      window.addEventListener("resize", function() {
        that.pixi.view.style.width = window.innerWidth + 'px';
        return that.pixi.view.style.height = window.innerHeight + 'px';
      });
    }
    rootScene = new Gotham.Graphics.Scene(0x000000, true);
    label = new Gotham.Graphics.Text("Gotham Game Engine", {
      font: "35px Arial",
      fill: "white",
      align: "left"
    }, 1920 / 2, 1080 / 2);
    label.anchor = {
      x: 0.5,
      y: 0.5
    };
    rootScene.addChild(label);
    this.pixi.stage = rootScene;
    this.scenes = {
      "root": this.pixi.stage
    };
    document.body.appendChild(this.pixi.view);
    window.onfocus = function() {
      return Gotham.Running = true;
    };
    window.onblur = function() {
      return Gotham.Running = false;
    };
    Gotham.GameLoop.setRenderer(function() {
      return renderer.pixi.render(renderer.pixi.stage);
    });
  }

  Renderer.prototype.setScene = function(name) {
    var scene;
    scene = this.scenes[name];
    return this.pixi.stage = scene;
  };

  Renderer.prototype.addScene = function(name, scene) {
    scene._renderer = this;
    return this.scenes[name] = scene;
  };

  Renderer.prototype.getScene = function(name) {
    return this.scenes[name];
  };

  return Renderer;

})();

module.exports = Renderer;


},{}],25:[function(require,module,exports){

/**
 * Scene inherits {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage}
 *
 * Stages are now Scenes which is now in a {http://en.wikipedia.org/wiki/Scene_graph Scene Graph} Structure
 *
 * See {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage} for properties
 * @class Scene
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @constructor
 * @extends PIXI.Container
 */
var Scene,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Scene = (function(_super) {
  __extends(Scene, _super);

  function Scene() {
    Scene.__super__.constructor.apply(this, arguments);
    this.__children = {};
    this.create();
  }

  Scene.prototype.create = function() {};

  Scene.prototype.getObject = function(name) {
    return this.__children[name];
  };

  Scene.prototype.addObject = function(child) {
    this.addChild(child.View);
    child.scene = this;
    child.View.scene = this;
    if (!child.View._created) {
      child.View.create();
    }
    if (!child._created) {
      child.create();
    }
    child.View._created = true;
    child._created = true;
    if (!child.name) {
      throw Error("Missing @name property!");
    }
    this.__children[child.name] = child;
    return child;
  };

  Scene.prototype.removeObject = function(child) {
    delete this.__children[child.name];
    child.scene = null;
    child.View.scene = null;
    child._created = false;
    child.View._created = false;
    return this.removeChild(child.View);
  };

  return Scene;

})(PIXI.Container);

module.exports = Scene;


},{}],26:[function(require,module,exports){
var Howler, Sound;

Howler = require('../dependencies/howler.js');


/**
 * This class wraps the functionality of Howler.JS {http://goldfirestudios.com/blog/104/howler.js-Modern-Web-Audio-Javascript-Library HowlerJS}
 *
 * Is protects Howl Object so that its not accessible from this class.
 *
 * Sound class is generated when preloading the audio file {Preload}
 *
 * @class Sound
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @constructor
 * @param
 * @example Creating a sound object
 *   # Preload the audio file
 *   Gotham.Preload.mp3("./assets/audio/menu.mp3", "boud", volume: 0.2)
 *
 * @example Using the sound object
 *   # Fetch the sound file
 *   sound = Gotham.Preload.fetch("boud", "audio")
 *   # Set Volume
 *   sound.volume(0.3)
 *   # Play Audio
 *   sound.play()
 *   # Stop Audio
 *   sound.stop()
 */

Sound = (function() {
  function Sound(sound) {
    this._sound = sound;
  }

  Sound.prototype.play = function() {
    return this._sound.play();
  };

  Sound.prototype.stop = function() {
    return this._sound.stop();
  };

  Sound.prototype.pause = function() {
    return this._sound.pause();
  };

  Sound.prototype.volume = function(val) {
    return this._sound.volume(val);
  };

  Sound.prototype.forward = function(sec) {
    var currPos;
    currPos = this._sound.pos();
    return this._sound.pos(currPos + sec);
  };

  Sound.prototype.backward = function(sec) {
    var currPos;
    currPos = this._sound.pos();
    return this._sound.pos(currPos - sec);
  };

  Sound.prototype.mute = function() {
    return this._sound.mute();
  };

  Sound.prototype.unmute = function() {
    return this._sound.unmute();
  };

  Sound.prototype.loop = function(state) {
    return this._sound.loop(state);
  };

  return Sound;

})();

module.exports = Sound;


},{"../dependencies/howler.js":33}],27:[function(require,module,exports){

/**
﻿ * The tween class of Gotham
 * This class animates objects of any format
 * It features to reach deep proprerties in an object
 * @class Tween
 * @module TweenCS
 * @namespace TweenCS
 */
var Tween,
  __modulo = function(a, b) { return (a % b + +b) % b; };

Tween = (function() {

  /**
   * @class ChainItem
   * @module TweenCS
   * @namespace TweenCS.ChainItem
   */
  var ChainItem;

  ChainItem = (function() {
    function ChainItem() {
      this.property = null;
      this.duration = null;
      this.startTime = null;
      this.endTime = null;
      this.inited = false;
      this.type = null;
      this.next = null;
      this.previous = null;
      this.elapsed = 0;
    }

    return ChainItem;

  })();

  Tween._tweens = [];

  Tween.clear = function() {
    var tween, _i, _len, _ref, _results;
    _ref = Tween._tweens;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tween = _ref[_i];
      _results.push(tween._complete = true);
    }
    return _results;
  };

  Tween._currentTime = 0;

  function Tween(object) {
    this._object = object;
    this._chain = [];
    this._properties = [];
    this._easing = Tween.Easing.Linear.None;
    this._interpolation = Tween.Interpolation.Linear;
    this._onUpdate = function() {};
    this._onComplete = function() {};
    this._onStart = function() {};
    this._started = false;
    this._complete = false;
    this._startDelay = 0;
    this._lastTime = 0;
    this._runCounter = 0;
    this._remainingRuns = 1;
    Tween._tweens.push(this);
  }

  Tween.prototype.getTweenChain = function() {
    return this._chain;
  };

  Tween.prototype.addToChain = function(newPath) {
    var first, last;
    if (this._chain.length > 0) {
      last = this._chain[this._chain.length - 1];
      last.next = newPath;
      first = this._chain[0];
      first.previous = newPath;
      newPath.previous = last;
      newPath.next = first;
    } else {
      newPath.previous = newPath;
      newPath.next = newPath;
    }
    return this._chain.push(newPath);
  };

  Tween.prototype.startDelay = function(time) {
    return this._startDelay = time;
  };

  Tween.prototype.start = function() {
    this._started = true;
    return this._onStart(this._object);
  };

  Tween.prototype.stop = function() {
    this._started = false;
    return this._complete = true;
  };

  Tween.prototype.pause = function() {
    return this._started = false;
  };

  Tween.prototype.unpause = function() {
    var chainItem, elapsedTime, time, timeLeft;
    this._started = true;
    time = performance.now();
    chainItem = this._chain[__modulo(this._runCounter, this._chain.length)];
    elapsedTime = (chainItem.endTime - chainItem.startTime) * chainItem.elapsed;
    timeLeft = chainItem.duration - elapsedTime;
    chainItem.endTime = time + timeLeft;
    return chainItem.startTime = chainItem.endTime - chainItem.duration;
  };

  Tween.prototype.easing = function(easing) {
    this._easing = easing;
    return this;
  };


  /**
   * Adds a function to the tween chain. Neat for when you want logic to run between two tweens
   * @method func
   * @chainable
   */

  Tween.prototype.func = function(_c) {
    var newPath;
    newPath = new ChainItem();
    newPath.callback = _c;
    newPath.property = null;
    newPath.properties = [];
    newPath.shallow = true;
    newPath.duration = 0;
    newPath.startTime = null;
    newPath.endTime = null;
    newPath.inited = true;
    newPath.next = null;
    newPath.previous = null;
    newPath.type = "func";
    newPath.elapsed = 0;
    this.addToChain(newPath);
    return this;
  };


  /**
   * Add tween action to the tween chain
   * @param [Object] property The "goal" property of the tween (Where you want the target object to end up)
   * @param [Long] duration Duration of the tween from start --> end (In milliseconds)
   * @chainable
   */

  Tween.prototype.to = function(property, duration) {
    var newPath, prop, properties, shallow, _i, _len, _ref;
    properties = [];
    shallow = false;
    _ref = Tween.flattenKeys(property);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      prop = _ref[_i];
      if (prop.split(".").length <= 1) {
        shallow = true;
      }
      properties.push(prop);
      this._properties.push(prop);
    }
    newPath = new ChainItem();
    newPath.property = property;
    newPath.properties = properties;
    newPath.shallow = shallow;
    newPath.duration = duration;
    newPath.startTime = null;
    newPath.endTime = null;
    newPath.inited = false;
    newPath.type = "translate";
    newPath.next = null;
    newPath.previous = null;
    newPath.elapsed = 0;
    this.addToChain(newPath);
    return this;
  };

  Tween.prototype.delay = function(time) {
    var delayItem;
    if (typeof time !== 'number') {
      throw new Error("Time was not a number!");
    }
    delayItem = {
      "properties": [],
      "duration": time,
      "startTime": null,
      "endTime": null,
      "type": "delay",
      "previous": null,
      "next": null
    };
    return this.addToChain(delayItem);
  };

  Tween.prototype.repeat = function(num) {
    return this._remainingRuns = num;
  };

  Tween.prototype.addCutsomProperty = function(property) {
    return this._properties.push(property);
  };

  Tween.prototype.addCutsomProperties = function(properties) {
    var property, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = properties.length; _i < _len; _i++) {
      property = properties[_i];
      _results.push(this.addProperty(property));
    }
    return _results;
  };

  Tween.prototype.onUpdate = function(callback) {
    this._onUpdate = callback;
    return this.onUpdate = true;
  };

  Tween.prototype.onComplete = function(callback) {
    return this._onComplete = callback;
  };

  Tween.prototype.onStart = function(callback) {
    return this._onStart = callback;
  };

  Tween.update = function(time) {
    var chainItem, elapsed, end, key, nextPos, prop, property, start, startTime, tween, value, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;
    Tween._currentTime = time;
    if (Tween._tweens.length <= 0) {
      return;
    }
    _ref = Tween._tweens;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tween = _ref[_i];
      if (!tween) {
        continue;
      }
      if (tween._complete) {
        tween._onComplete(tween);
        Tween._tweens.splice(Tween._tweens.indexOf(tween), 1);
        continue;
      }
      if (!tween._started) {
        continue;
      }
      if (time < tween._startTime + tween._startDelay) {
        continue;
      }
      if (tween._chain.length <= 0 || tween._remainingRuns <= 0) {
        tween._complete = true;
        continue;
      }
      chainItem = tween._chain[__modulo(tween._runCounter, tween._chain.length)];
      if (!chainItem.inited) {
        chainItem.startTime = performance.now();
        chainItem.endTime = chainItem.startTime + chainItem.duration;
        chainItem.inited = true;
        if (chainItem.type === "delay" || chainItem.type === "func") {
          break;
        }
        chainItem.startPos = {};
        _ref1 = tween._properties;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          property = _ref1[_j];
          key = property.split('.')[0];
          value = tween._object[key];
          chainItem.startPos[key] = typeof value === 'object' ? Tween.clone(value) : value;
        }
      }
      if (time > chainItem.endTime && chainItem.elapsed >= 0.99) {
        tween._runCounter++;
        chainItem.startTime = null;
        chainItem.endTime = null;
        chainItem.inited = false;
        chainItem.elapsed = 0;
        if (__modulo(tween._runCounter, tween._chain.length) === 0) {
          tween._remainingRuns -= 1;
        }
        continue;
      }
      if (chainItem.type === "func") {
        chainItem.callback();
      }
      startTime = chainItem.startTime;
      start = chainItem.startPos;
      end = chainItem.property;
      elapsed = (performance.now() - startTime) / chainItem.duration;
      elapsed = elapsed > 1 ? 1 : elapsed;
      chainItem.elapsed = elapsed;
      value = tween._easing(elapsed);
      if (tween.onUpdate) {
        tween._onUpdate(chainItem);
      }
      _ref2 = chainItem.properties;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        prop = _ref2[_k];
        if (chainItem.shallow) {
          tween._object[prop] = start[prop] + (end[prop] - start[prop]) * value;
        } else {
          nextPos = Tween.resolve(start, prop) + (Tween.resolve(end, prop) - Tween.resolve(start, prop)) * value;
          Tween.resolve(tween._object, prop, null, nextPos);
        }
      }
      continue;
    }
    return _results;
  };

  Tween.clone = function(obj) {
    var i, target;
    target = {};
    for (i in obj) {
      if (obj.hasOwnProperty(i)) {
        target[i] = obj[i];
      }
    }
    return target;
  };

  Tween.resolve = function(obj, path, def, setValue) {
    var i, len, previous;
    i = void 0;
    len = void 0;
    previous = obj;
    i = 0;
    path = path.split('.');
    len = path.length;
    while (i < len) {
      if (!obj || typeof obj !== 'object') {
        return def;
      }
      previous = obj;
      obj = obj[path[i]];
      i++;
    }
    if (obj === void 0) {
      return def;
    }
    if (setValue) {
      previous[path[len - 1]] = setValue;
    }
    return obj;
  };

  Tween.flattenKeys = function(obj, delimiter, max_depth) {
    var recurse;
    delimiter = delimiter || '.';
    max_depth = max_depth || 2;
    recurse = function(obj, path, result, level) {
      if (level > max_depth) {
        return;
      }
      level++;
      if (typeof obj === 'object' && obj) {
        Object.keys(obj).forEach(function(key) {
          path.push(key);
          recurse(obj[key], path, result, level);
          return path.pop();
        });
      } else {
        result.push(path.join(delimiter));
      }
      return result;
    };
    return recurse(obj, [], [], 0);
  };

  Tween.Easing = {
    Linear: {
      None: function(k) {
        return k;
      }
    },
    Quadratic: {
      In: function(k) {
        return k * k;
      },
      Out: function(k) {
        return k * (2 - k);
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k;
        }
        return -0.5 * (--k * (k - 2) - 1);
      }
    },
    Cubic: {
      In: function(k) {
        return k * k * k;
      },
      Out: function(k) {
        return --k * k * k + 1;
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k * k;
        }
        return 0.5 * ((k -= 2) * k * k + 2);
      }
    },
    Quartic: {
      In: function(k) {
        return k * k * k * k;
      },
      Out: function(k) {
        return 1 - --k * k * k * k;
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k * k * k;
        }
        return -0.5 * ((k -= 2) * k * k * k - 2);
      }
    },
    Quintic: {
      In: function(k) {
        return k * k * k * k * k;
      },
      Out: function(k) {
        return --k * k * k * k * k + 1;
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return 0.5 * k * k * k * k * k;
        }
        return 0.5 * ((k -= 2) * k * k * k * k + 2);
      }
    },
    Sinusoidal: {
      In: function(k) {
        return 1 - Math.cos(k * Math.PI / 2);
      },
      Out: function(k) {
        return Math.sin(k * Math.PI / 2);
      },
      InOut: function(k) {
        return 0.5 * (1 - Math.cos(Math.PI * k));
      }
    },
    Exponential: {
      In: function(k) {
        if (k === 0) {
          return 0;
        } else {
          return Math.pow(1024, k - 1);
        }
      },
      Out: function(k) {
        if (k === 1) {
          return 1;
        } else {
          return 1 - Math.pow(2, -10 * k);
        }
      },
      InOut: function(k) {
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if ((k *= 2) < 1) {
          return 0.5 * Math.pow(1024, k - 1);
        }
        return 0.5 * (-(Math.pow(2, -10 * (k - 1))) + 2);
      }
    },
    Circular: {
      In: function(k) {
        return 1 - Math.sqrt(1 - k * k);
      },
      Out: function(k) {
        return Math.sqrt(1 - --k * k);
      },
      InOut: function(k) {
        if ((k *= 2) < 1) {
          return -0.5 * (Math.sqrt(1 - k * k) - 1);
        }
        return 0.5 * (Math.sqrt(1 - (k -= 2) * k) + 1);
      }
    },
    Elastic: {
      In: function(k) {
        var a, p, s;
        s = void 0;
        a = 0.1;
        p = 0.4;
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if (!a || a < 1) {
          a = 1;
          s = p / 4;
        } else {
          s = p * Math.asin(1 / a) / 2 * Math.PI;
        }
        return -(a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p));
      },
      Out: function(k) {
        var a, p, s;
        s = void 0;
        a = 0.1;
        p = 0.4;
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if (!a || a < 1) {
          a = 1;
          s = p / 4;
        } else {
          s = p * Math.asin(1 / a) / 2 * Math.PI;
        }
        return a * Math.pow(2, -10 * k) * Math.sin((k - s) * 2 * Math.PI / p) + 1;
      },
      InOut: function(k) {
        var a, p, s;
        s = void 0;
        a = 0.1;
        p = 0.4;
        if (k === 0) {
          return 0;
        }
        if (k === 1) {
          return 1;
        }
        if (!a || a < 1) {
          a = 1;
          s = p / 4;
        } else {
          s = p * Math.asin(1 / a) / 2 * Math.PI;
        }
        if ((k *= 2) < 1) {
          return -0.5 * a * Math.pow(2, 10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p);
        }
        return a * Math.pow(2, -10 * (k -= 1)) * Math.sin((k - s) * 2 * Math.PI / p) * 0.5 + 1;
      }
    },
    Back: {
      In: function(k) {
        var s;
        s = 1.70158;
        return k * k * ((s + 1) * k - s);
      },
      Out: function(k) {
        var s;
        s = 1.70158;
        return --k * k * ((s + 1) * k + s) + 1;
      },
      InOut: function(k) {
        var s;
        s = 1.70158 * 1.525;
        if ((k *= 2) < 1) {
          return 0.5 * k * k * ((s + 1) * k - s);
        }
        return 0.5 * ((k -= 2) * k * ((s + 1) * k + s) + 2);
      }
    },
    Bounce: {
      In: function(k) {
        return 1 - Tween.Easing.Bounce.Out(1 - k);
      },
      Out: function(k) {
        if (k < 1 / 2.75) {
          return 7.5625 * k * k;
        } else if (k < 2 / 2.75) {
          return 7.5625 * (k -= 1.5 / 2.75) * k + 0.75;
        } else if (k < 2.5 / 2.75) {
          return 7.5625 * (k -= 2.25 / 2.75) * k + 0.9375;
        } else {
          return 7.5625 * (k -= 2.625 / 2.75) * k + 0.984375;
        }
      },
      InOut: function(k) {
        if (k < 0.5) {
          return Tween.Easing.Bounce.In(k * 2) * 0.5;
        }
        return Tween.Easing.Bounce.Out(k * 2 - 1) * 0.5 + 0.5;
      }
    }
  };

  Tween.Interpolation = {
    Linear: function(v, k) {
      var f, fn, i, m;
      m = v.length - 1;
      f = m * k;
      i = Math.floor(f);
      fn = Tween.Interpolation.Utils.Linear;
      if (k < 0) {
        return fn(v[0], v[1], f);
      }
      if (k > 1) {
        return fn(v[m], v[m - 1], m - f);
      }
      return fn(v[i], v[i + 1 > m ? m : i + 1], f - i);
    },
    Bezier: function(v, k) {
      var b, bn, i, n, pw;
      b = 0;
      n = v.length - 1;
      pw = Math.pow;
      bn = Tween.Interpolation.Utils.Bernstein;
      i = void 0;
      i = 0;
      while (i <= n) {
        b += pw(1 - k, n - i) * pw(k, i) * v[i] * bn(n, i);
        i++;
      }
      return b;
    },
    CatmullRom: function(v, k) {
      var f, fn, i, m;
      m = v.length - 1;
      f = m * k;
      i = Math.floor(f);
      fn = Tween.Interpolation.Utils.CatmullRom;
      if (v[0] === v[m]) {
        if (k < 0) {
          i = Math.floor(f = m * (1 + k));
        }
        return fn(v[(i - 1 + m) % m], v[i], v[(i + 1) % m], v[(i + 2) % m], f - i);
      } else {
        if (k < 0) {
          return v[0] - (fn(v[0], v[0], v[1], v[1], -f) - v[0]);
        }
        if (k > 1) {
          return v[m] - (fn(v[m], v[m], v[m - 1], v[m - 1], f - m) - v[m]);
        }
        return fn(v[i ? i - 1 : 0], v[i], v[m < i + 1 ? m : i + 1], v[m < i + 2 ? m : i + 2], f - i);
      }
    },
    Utils: {
      Linear: function(p0, p1, t) {
        return (p1 - p0) * t + p0;
      },
      Bernstein: function(n, i) {
        var fc;
        fc = Tween.Interpolation.Utils.Factorial;
        return fc(n) / fc(i) / fc(n - i);
      },
      Factorial: (function() {
        var a;
        a = [1];
        return function(n) {
          var i, s;
          s = 1;
          i = void 0;
          if (a[n]) {
            return a[n];
          }
          i = n;
          while (i > 1) {
            s *= i;
            i--;
          }
          return a[n] = s;
        };
      })(),
      CatmullRom: function(p0, p1, p2, p3, t) {
        var t2, t3, v0, v1;
        v0 = (p2 - p0) * 0.5;
        v1 = (p3 - p1) * 0.5;
        t2 = t * t;
        t3 = t * t2;
        return (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
      }
    }
  };

  return Tween;

})();

module.exports = Tween;

window.Tween = Tween;


},{}],28:[function(require,module,exports){

/**
 * Utilities class for Gotham Game Engine
 * Contains classes which may come handy in data manipulation
 * @class Util
 * @module Framework
 * @submodule Framework.Util
 * @namespace Gotham.Util
 */
var Util;

Util = (function() {
  function Util() {}

  Util.Ajax = require('./modules/Ajax.coffee');

  Util.SearchTools = require('./modules/SearchTools.coffee');

  Util.Compression = require('./modules/Compression.coffee');

  Util.Geocoding = require('./modules/Geocoding.coffee');

  return Util;

})();

module.exports = Util;


},{"./modules/Ajax.coffee":29,"./modules/Compression.coffee":30,"./modules/Geocoding.coffee":31,"./modules/SearchTools.coffee":32}],29:[function(require,module,exports){

/**
 * AJAX Class to retrieve and post without the use of JQUERY
 * IT does only rely on the normal javascript library
 * @class Ajax
 * @module Framework
 * @submodule Framework.Util
 * @namespace Gotham.Util
 */
var Ajax;

Ajax = (function() {
  function Ajax() {}

  Ajax.getXmlDoc = function() {
    var xmlDoc;
    xmlDoc = null;
    if (window.XMLHttpRequest) {
      xmlDoc = new XMLHttpRequest();
    } else {
      xmlDoc = new ActiveXObject("Microsoft.XMLHTTP");
    }
    return xmlDoc;
  };

  Ajax.GET = function(url, callback) {
    var xmlDoc;
    xmlDoc = Ajax.getXmlDoc();
    xmlDoc.open('GET', url, true);
    xmlDoc.onreadystatechange = function() {
      if (xmlDoc.readyState === 4 && xmlDoc.status === 200) {
        return callback(JSON.parse(xmlDoc.response), xmlDoc);
      }
    };
    return xmlDoc.send();
  };

  return Ajax;

})();

module.exports = Ajax;


},{}],30:[function(require,module,exports){

/**
 * Utils for compressing
 * @class Compression
 * @module Framework
 * @submodule Framework.Util
 * @namespace Gotham.Util
 */
var Compression;

Compression = (function() {
  function Compression() {}

  Compression.prototype.GZIP = {
    decompress: function(bytes) {
      var gunzip, plain;
      gunzip = new Zlib.Zlib.Gunzip(atob(bytes));
      plain = gunzip.decompress();
      return plain;
    }
  };

  return Compression;

})();

module.exports = new Compression();


},{}],31:[function(require,module,exports){

/**
 * Geocoding util module
 * @class Geocoding
 * @module Framework
 * @submodule Framework.Util
 * @namespace Gotham.Util
 */
var Geocoding;

Geocoding = (function() {
  function Geocoding() {}

  Geocoding.getCountry = function(lat, lng) {
    return window.CRG.country_reverse_geocoding().get_country(lat, lng);
  };

  Geocoding.CalculateDistance = function(coordinate1, coordinate2) {
    var R, a, c, g1, g2, h1, h2;
    R = 6371000;
    g1 = coordinate1.lat * Math.PI / 180;
    g2 = coordinate2.lat * Math.PI / 180;
    h1 = (coordinate2.lat - coordinate1.lat) * Math.PI / 180;
    h2 = (coordinate2.lng - coordinate1.lng) * Math.PI / 180;
    a = Math.sin(h1 / 2) * Math.sin(h1 / 2) + Math.cos(g1) * Math.cos(g2) * Math.sin(h2 / 2) * Math.sin(h2 / 2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  };

  return Geocoding;

})();

module.exports = Geocoding;


},{}],32:[function(require,module,exports){

/**
 * Search tools is a collection of array and object manipulation tools
 * @class SearchTools
 * @module Framework
 * @submodule Framework.Util
 * @namespace Gotham.Util
 */
var SearchTools;

SearchTools = (function() {
  function SearchTools() {}

  SearchTools.FindKey = function(object, key, maxDepth) {
    var depth, found, item, queue, _key;
    if (maxDepth == null) {
      maxDepth = 7;
    }
    queue = [];
    queue.push(object);
    found = void 0;
    depth = 0;
    while (queue.length && !found) {
      if (depth++ > maxDepth) {
        return null;
      }
      item = queue.shift();
      if (key in item) {
        console.log("boud!");
        found = item[key];
      }
      if (typeof item === 'object') {
        for (_key in item) {
          queue.push(item[_key]);
        }
      }
    }
    return found;
  };

  return SearchTools;

})();

module.exports = SearchTools;


},{}],33:[function(require,module,exports){
/*!
 *  howler.js v1.1.26
 *  howlerjs.com
 *
 *  (c) 2013-2015, James Simpson of GoldFire Studios
 *  goldfirestudios.com
 *
 *  MIT License
 */
!function(){var e={},o=null,n=!0,t=!1;try{"undefined"!=typeof AudioContext?o=new AudioContext:"undefined"!=typeof webkitAudioContext?o=new webkitAudioContext:n=!1}catch(r){n=!1}if(!n)if("undefined"!=typeof Audio)try{new Audio}catch(r){t=!0}else t=!0;if(n){var a="undefined"==typeof o.createGain?o.createGainNode():o.createGain();a.gain.value=1,a.connect(o.destination)}var i=function(e){this._volume=1,this._muted=!1,this.usingWebAudio=n,this.ctx=o,this.noAudio=t,this._howls=[],this._codecs=e,this.iOSAutoEnable=!0};i.prototype={volume:function(e){var o=this;if(e=parseFloat(e),e>=0&&1>=e){o._volume=e,n&&(a.gain.value=e);for(var t in o._howls)if(o._howls.hasOwnProperty(t)&&o._howls[t]._webAudio===!1)for(var r=0;r<o._howls[t]._audioNode.length;r++)o._howls[t]._audioNode[r].volume=o._howls[t]._volume*o._volume;return o}return n?a.gain.value:o._volume},mute:function(){return this._setMuted(!0),this},unmute:function(){return this._setMuted(!1),this},_setMuted:function(e){var o=this;o._muted=e,n&&(a.gain.value=e?0:o._volume);for(var t in o._howls)if(o._howls.hasOwnProperty(t)&&o._howls[t]._webAudio===!1)for(var r=0;r<o._howls[t]._audioNode.length;r++)o._howls[t]._audioNode[r].muted=e},codecs:function(e){return this._codecs[e]},_enableiOSAudio:function(){var e=this;if(!o||!e._iOSEnabled&&/iPhone|iPad|iPod/i.test(navigator.userAgent)){e._iOSEnabled=!1;var n=function(){var t=o.createBuffer(1,1,22050),r=o.createBufferSource();r.buffer=t,r.connect(o.destination),"undefined"==typeof r.start?r.noteOn(0):r.start(0),setTimeout(function(){(r.playbackState===r.PLAYING_STATE||r.playbackState===r.FINISHED_STATE)&&(e._iOSEnabled=!0,e.iOSAutoEnable=!1,window.removeEventListener("touchstart",n,!1))},0)};return window.addEventListener("touchstart",n,!1),e}}};var u=null,d={};t||(u=new Audio,d={mp3:!!u.canPlayType("audio/mpeg;").replace(/^no$/,""),opus:!!u.canPlayType('audio/ogg; codecs="opus"').replace(/^no$/,""),ogg:!!u.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/,""),wav:!!u.canPlayType('audio/wav; codecs="1"').replace(/^no$/,""),aac:!!u.canPlayType("audio/aac;").replace(/^no$/,""),m4a:!!(u.canPlayType("audio/x-m4a;")||u.canPlayType("audio/m4a;")||u.canPlayType("audio/aac;")).replace(/^no$/,""),mp4:!!(u.canPlayType("audio/x-mp4;")||u.canPlayType("audio/mp4;")||u.canPlayType("audio/aac;")).replace(/^no$/,""),weba:!!u.canPlayType('audio/webm; codecs="vorbis"').replace(/^no$/,"")});var l=new i(d),f=function(e){var t=this;t._autoplay=e.autoplay||!1,t._buffer=e.buffer||!1,t._duration=e.duration||0,t._format=e.format||null,t._loop=e.loop||!1,t._loaded=!1,t._sprite=e.sprite||{},t._src=e.src||"",t._pos3d=e.pos3d||[0,0,-.5],t._volume=void 0!==e.volume?e.volume:1,t._urls=e.urls||[],t._rate=e.rate||1,t._model=e.model||null,t._onload=[e.onload||function(){}],t._onloaderror=[e.onloaderror||function(){}],t._onend=[e.onend||function(){}],t._onpause=[e.onpause||function(){}],t._onplay=[e.onplay||function(){}],t._onendTimer=[],t._webAudio=n&&!t._buffer,t._audioNode=[],t._webAudio&&t._setupAudioNode(),"undefined"!=typeof o&&o&&l.iOSAutoEnable&&l._enableiOSAudio(),l._howls.push(t),t.load()};if(f.prototype={load:function(){var e=this,o=null;if(t)return void e.on("loaderror");for(var n=0;n<e._urls.length;n++){var r,a;if(e._format)r=e._format;else{if(a=e._urls[n],r=/^data:audio\/([^;,]+);/i.exec(a),r||(r=/\.([^.]+)$/.exec(a.split("?",1)[0])),!r)return void e.on("loaderror");r=r[1].toLowerCase()}if(d[r]){o=e._urls[n];break}}if(!o)return void e.on("loaderror");if(e._src=o,e._webAudio)_(e,o);else{var u=new Audio;u.addEventListener("error",function(){u.error&&4===u.error.code&&(i.noAudio=!0),e.on("loaderror",{type:u.error?u.error.code:0})},!1),e._audioNode.push(u),u.src=o,u._pos=0,u.preload="auto",u.volume=l._muted?0:e._volume*l.volume();var f=function(){e._duration=Math.ceil(10*u.duration)/10,0===Object.getOwnPropertyNames(e._sprite).length&&(e._sprite={_default:[0,1e3*e._duration]}),e._loaded||(e._loaded=!0,e.on("load")),e._autoplay&&e.play(),u.removeEventListener("canplaythrough",f,!1)};u.addEventListener("canplaythrough",f,!1),u.load()}return e},urls:function(e){var o=this;return e?(o.stop(),o._urls="string"==typeof e?[e]:e,o._loaded=!1,o.load(),o):o._urls},play:function(e,n){var t=this;return"function"==typeof e&&(n=e),e&&"function"!=typeof e||(e="_default"),t._loaded?t._sprite[e]?(t._inactiveNode(function(r){r._sprite=e;var a=r._pos>0?r._pos:t._sprite[e][0]/1e3,i=0;t._webAudio?(i=t._sprite[e][1]/1e3-r._pos,r._pos>0&&(a=t._sprite[e][0]/1e3+a)):i=t._sprite[e][1]/1e3-(a-t._sprite[e][0]/1e3);var u,d=!(!t._loop&&!t._sprite[e][2]),f="string"==typeof n?n:Math.round(Date.now()*Math.random())+"";if(function(){var o={id:f,sprite:e,loop:d};u=setTimeout(function(){!t._webAudio&&d&&t.stop(o.id).play(e,o.id),t._webAudio&&!d&&(t._nodeById(o.id).paused=!0,t._nodeById(o.id)._pos=0,t._clearEndTimer(o.id)),t._webAudio||d||t.stop(o.id),t.on("end",f)},1e3*i),t._onendTimer.push({timer:u,id:o.id})}(),t._webAudio){var _=t._sprite[e][0]/1e3,s=t._sprite[e][1]/1e3;r.id=f,r.paused=!1,p(t,[d,_,s],f),t._playStart=o.currentTime,r.gain.value=t._volume,"undefined"==typeof r.bufferSource.start?d?r.bufferSource.noteGrainOn(0,a,86400):r.bufferSource.noteGrainOn(0,a,i):d?r.bufferSource.start(0,a,86400):r.bufferSource.start(0,a,i)}else{if(4!==r.readyState&&(r.readyState||!navigator.isCocoonJS))return t._clearEndTimer(f),function(){var o=t,a=e,i=n,u=r,d=function(){o.play(a,i),u.removeEventListener("canplaythrough",d,!1)};u.addEventListener("canplaythrough",d,!1)}(),t;r.readyState=4,r.id=f,r.currentTime=a,r.muted=l._muted||r.muted,r.volume=t._volume*l.volume(),setTimeout(function(){r.play()},0)}return t.on("play"),"function"==typeof n&&n(f),t}),t):("function"==typeof n&&n(),t):(t.on("load",function(){t.play(e,n)}),t)},pause:function(e){var o=this;if(!o._loaded)return o.on("play",function(){o.pause(e)}),o;o._clearEndTimer(e);var n=e?o._nodeById(e):o._activeNode();if(n)if(n._pos=o.pos(null,e),o._webAudio){if(!n.bufferSource||n.paused)return o;n.paused=!0,"undefined"==typeof n.bufferSource.stop?n.bufferSource.noteOff(0):n.bufferSource.stop(0)}else n.pause();return o.on("pause"),o},stop:function(e){var o=this;if(!o._loaded)return o.on("play",function(){o.stop(e)}),o;o._clearEndTimer(e);var n=e?o._nodeById(e):o._activeNode();if(n)if(n._pos=0,o._webAudio){if(!n.bufferSource||n.paused)return o;n.paused=!0,"undefined"==typeof n.bufferSource.stop?n.bufferSource.noteOff(0):n.bufferSource.stop(0)}else isNaN(n.duration)||(n.pause(),n.currentTime=0);return o},mute:function(e){var o=this;if(!o._loaded)return o.on("play",function(){o.mute(e)}),o;var n=e?o._nodeById(e):o._activeNode();return n&&(o._webAudio?n.gain.value=0:n.muted=!0),o},unmute:function(e){var o=this;if(!o._loaded)return o.on("play",function(){o.unmute(e)}),o;var n=e?o._nodeById(e):o._activeNode();return n&&(o._webAudio?n.gain.value=o._volume:n.muted=!1),o},volume:function(e,o){var n=this;if(e=parseFloat(e),e>=0&&1>=e){if(n._volume=e,!n._loaded)return n.on("play",function(){n.volume(e,o)}),n;var t=o?n._nodeById(o):n._activeNode();return t&&(n._webAudio?t.gain.value=e:t.volume=e*l.volume()),n}return n._volume},loop:function(e){var o=this;return"boolean"==typeof e?(o._loop=e,o):o._loop},sprite:function(e){var o=this;return"object"==typeof e?(o._sprite=e,o):o._sprite},pos:function(e,n){var t=this;if(!t._loaded)return t.on("load",function(){t.pos(e)}),"number"==typeof e?t:t._pos||0;e=parseFloat(e);var r=n?t._nodeById(n):t._activeNode();if(r)return e>=0?(t.pause(n),r._pos=e,t.play(r._sprite,n),t):t._webAudio?r._pos+(o.currentTime-t._playStart):r.currentTime;if(e>=0)return t;for(var a=0;a<t._audioNode.length;a++)if(t._audioNode[a].paused&&4===t._audioNode[a].readyState)return t._webAudio?t._audioNode[a]._pos:t._audioNode[a].currentTime},pos3d:function(e,o,n,t){var r=this;if(o="undefined"!=typeof o&&o?o:0,n="undefined"!=typeof n&&n?n:-.5,!r._loaded)return r.on("play",function(){r.pos3d(e,o,n,t)}),r;if(!(e>=0||0>e))return r._pos3d;if(r._webAudio){var a=t?r._nodeById(t):r._activeNode();a&&(r._pos3d=[e,o,n],a.panner.setPosition(e,o,n),a.panner.panningModel=r._model||"HRTF")}return r},fade:function(e,o,n,t,r){var a=this,i=Math.abs(e-o),u=e>o?"down":"up",d=i/.01,l=n/d;if(!a._loaded)return a.on("load",function(){a.fade(e,o,n,t,r)}),a;a.volume(e,r);for(var f=1;d>=f;f++)!function(){var e=a._volume+("up"===u?.01:-.01)*f,n=Math.round(1e3*e)/1e3,i=o;setTimeout(function(){a.volume(n,r),n===i&&t&&t()},l*f)}()},fadeIn:function(e,o,n){return this.volume(0).play().fade(0,e,o,n)},fadeOut:function(e,o,n,t){var r=this;return r.fade(r._volume,e,o,function(){n&&n(),r.pause(t),r.on("end")},t)},_nodeById:function(e){for(var o=this,n=o._audioNode[0],t=0;t<o._audioNode.length;t++)if(o._audioNode[t].id===e){n=o._audioNode[t];break}return n},_activeNode:function(){for(var e=this,o=null,n=0;n<e._audioNode.length;n++)if(!e._audioNode[n].paused){o=e._audioNode[n];break}return e._drainPool(),o},_inactiveNode:function(e){for(var o=this,n=null,t=0;t<o._audioNode.length;t++)if(o._audioNode[t].paused&&4===o._audioNode[t].readyState){e(o._audioNode[t]),n=!0;break}if(o._drainPool(),!n){var r;if(o._webAudio)r=o._setupAudioNode(),e(r);else{o.load(),r=o._audioNode[o._audioNode.length-1];var a=navigator.isCocoonJS?"canplaythrough":"loadedmetadata",i=function(){r.removeEventListener(a,i,!1),e(r)};r.addEventListener(a,i,!1)}}},_drainPool:function(){var e,o=this,n=0;for(e=0;e<o._audioNode.length;e++)o._audioNode[e].paused&&n++;for(e=o._audioNode.length-1;e>=0&&!(5>=n);e--)o._audioNode[e].paused&&(o._webAudio&&o._audioNode[e].disconnect(0),n--,o._audioNode.splice(e,1))},_clearEndTimer:function(e){for(var o=this,n=0,t=0;t<o._onendTimer.length;t++)if(o._onendTimer[t].id===e){n=t;break}var r=o._onendTimer[n];r&&(clearTimeout(r.timer),o._onendTimer.splice(n,1))},_setupAudioNode:function(){var e=this,n=e._audioNode,t=e._audioNode.length;return n[t]="undefined"==typeof o.createGain?o.createGainNode():o.createGain(),n[t].gain.value=e._volume,n[t].paused=!0,n[t]._pos=0,n[t].readyState=4,n[t].connect(a),n[t].panner=o.createPanner(),n[t].panner.panningModel=e._model||"equalpower",n[t].panner.setPosition(e._pos3d[0],e._pos3d[1],e._pos3d[2]),n[t].panner.connect(n[t]),n[t]},on:function(e,o){var n=this,t=n["_on"+e];if("function"==typeof o)t.push(o);else for(var r=0;r<t.length;r++)o?t[r].call(n,o):t[r].call(n);return n},off:function(e,o){var n=this,t=n["_on"+e],r=o?o.toString():null;if(r){for(var a=0;a<t.length;a++)if(r===t[a].toString()){t.splice(a,1);break}}else n["_on"+e]=[];return n},unload:function(){for(var o=this,n=o._audioNode,t=0;t<o._audioNode.length;t++)n[t].paused||(o.stop(n[t].id),o.on("end",n[t].id)),o._webAudio?n[t].disconnect(0):n[t].src="";for(t=0;t<o._onendTimer.length;t++)clearTimeout(o._onendTimer[t].timer);var r=l._howls.indexOf(o);null!==r&&r>=0&&l._howls.splice(r,1),delete e[o._src],o=null}},n)var _=function(o,n){if(n in e)return o._duration=e[n].duration,void c(o);if(/^data:[^;]+;base64,/.test(n)){for(var t=atob(n.split(",")[1]),r=new Uint8Array(t.length),a=0;a<t.length;++a)r[a]=t.charCodeAt(a);s(r.buffer,o,n)}else{var i=new XMLHttpRequest;i.open("GET",n,!0),i.responseType="arraybuffer",i.onload=function(){s(i.response,o,n)},i.onerror=function(){o._webAudio&&(o._buffer=!0,o._webAudio=!1,o._audioNode=[],delete o._gainNode,delete e[n],o.load())};try{i.send()}catch(u){i.onerror()}}},s=function(n,t,r){o.decodeAudioData(n,function(o){o&&(e[r]=o,c(t,o))},function(e){t.on("loaderror")})},c=function(e,o){e._duration=o?o.duration:e._duration,0===Object.getOwnPropertyNames(e._sprite).length&&(e._sprite={_default:[0,1e3*e._duration]}),e._loaded||(e._loaded=!0,e.on("load")),e._autoplay&&e.play()},p=function(n,t,r){var a=n._nodeById(r);a.bufferSource=o.createBufferSource(),a.bufferSource.buffer=e[n._src],a.bufferSource.connect(a.panner),a.bufferSource.loop=t[0],t[0]&&(a.bufferSource.loopStart=t[1],a.bufferSource.loopEnd=t[1]+t[2]),a.bufferSource.playbackRate.value=n._rate};"function"==typeof define&&define.amd&&define(function(){return{Howler:l,Howl:f}}),"undefined"!=typeof exports&&(exports.Howler=l,exports.Howl=f),"undefined"!=typeof window&&(window.Howler=l,window.Howl=f)}();
},{}],34:[function(require,module,exports){

/**
 *
 * @class GothamGame
 * @module Frontend
 * @namespace GothamGame
 */
var GothamGame;

GothamGame = (function() {
  function GothamGame() {}

  window.GothamGame = GothamGame;

  GothamGame.Globals = {
    canWheelScroll: true,
    showAttacks: true,
    showCables: false
  };

  GothamGame.Renderer = new Gotham.Graphics.Renderer(1920, 1080, {
    antialiasing: true,
    transparent: false,
    resolution: 1
  }, true);

  GothamGame.MissionEngine = new (require('./engine/MissionEngine.coffee'))();

  GothamGame.Terminal = require('./engine/Terminal/Terminal.coffee');

  GothamGame.Mission = require('./engine/Mission.coffee');

  GothamGame.Announce = new (require('./objects/Controller/AnnounceController.coffee'))("Announce");

  GothamGame.Tools = {
    HostUtils: require('./tools/HostUtils.coffee'),
    ColorUtil: require('./tools/ColorUtil.coffee')
  };

  GothamGame.Network = null;

  GothamGame.Controllers = {
    Bar: require('./objects/Controller/BarController.coffee'),
    Terminal: require('./objects/Controller/TerminalController.coffee'),
    NodeList: require('./objects/Controller/NodeListController.coffee'),
    WorldMap: require('./objects/Controller/WorldMapController.coffee'),
    Identity: require('./objects/Controller/IdentityController.coffee'),
    Mission: require('./objects/Controller/MissionController.coffee'),
    Settings: require('./objects/Controller/SettingsController.coffee'),
    Gothshark: require('./objects/Controller/GothsharkController.coffee'),
    User: require('./objects/Controller/UserController.coffee'),
    Shop: require('./objects/Controller/ShopController.coffee'),
    Help: require('./objects/Controller/HelpController.coffee')
  };

  GothamGame.Scenes = {
    "Loading": require("./scenes/Loading.coffee"),
    "World": require("./scenes/World.coffee"),
    "Menu": require("./scenes/Menu.coffee")
  };

  return GothamGame;

})();

module.exports = GothamGame;


},{"./engine/Mission.coffee":38,"./engine/MissionEngine.coffee":39,"./engine/Terminal/Terminal.coffee":52,"./objects/Controller/AnnounceController.coffee":54,"./objects/Controller/BarController.coffee":55,"./objects/Controller/GothsharkController.coffee":56,"./objects/Controller/HelpController.coffee":57,"./objects/Controller/IdentityController.coffee":58,"./objects/Controller/MissionController.coffee":59,"./objects/Controller/NodeListController.coffee":60,"./objects/Controller/SettingsController.coffee":61,"./objects/Controller/ShopController.coffee":62,"./objects/Controller/TerminalController.coffee":63,"./objects/Controller/UserController.coffee":64,"./objects/Controller/WorldMapController.coffee":65,"./scenes/Loading.coffee":78,"./scenes/Menu.coffee":79,"./scenes/World.coffee":80,"./tools/ColorUtil.coffee":81,"./tools/HostUtils.coffee":82}],35:[function(require,module,exports){
/*! jQuery UI - v1.11.4 - 2015-03-20
* http://jqueryui.com
* Includes: core.js, widget.js, mouse.js, position.js, draggable.js, resizable.js
* Copyright 2015 jQuery Foundation and other contributors; Licensed MIT */

(function(e){"function"==typeof define&&define.amd?define(["jquery"],e):e(jQuery)})(function(e){function t(t,s){var n,a,o,r=t.nodeName.toLowerCase();return"area"===r?(n=t.parentNode,a=n.name,t.href&&a&&"map"===n.nodeName.toLowerCase()?(o=e("img[usemap='#"+a+"']")[0],!!o&&i(o)):!1):(/^(input|select|textarea|button|object)$/.test(r)?!t.disabled:"a"===r?t.href||s:s)&&i(t)}function i(t){return e.expr.filters.visible(t)&&!e(t).parents().addBack().filter(function(){return"hidden"===e.css(this,"visibility")}).length}e.ui=e.ui||{},e.extend(e.ui,{version:"1.11.4",keyCode:{BACKSPACE:8,COMMA:188,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,LEFT:37,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SPACE:32,TAB:9,UP:38}}),e.fn.extend({scrollParent:function(t){var i=this.css("position"),s="absolute"===i,n=t?/(auto|scroll|hidden)/:/(auto|scroll)/,a=this.parents().filter(function(){var t=e(this);return s&&"static"===t.css("position")?!1:n.test(t.css("overflow")+t.css("overflow-y")+t.css("overflow-x"))}).eq(0);return"fixed"!==i&&a.length?a:e(this[0].ownerDocument||document)},uniqueId:function(){var e=0;return function(){return this.each(function(){this.id||(this.id="ui-id-"+ ++e)})}}(),removeUniqueId:function(){return this.each(function(){/^ui-id-\d+$/.test(this.id)&&e(this).removeAttr("id")})}}),e.extend(e.expr[":"],{data:e.expr.createPseudo?e.expr.createPseudo(function(t){return function(i){return!!e.data(i,t)}}):function(t,i,s){return!!e.data(t,s[3])},focusable:function(i){return t(i,!isNaN(e.attr(i,"tabindex")))},tabbable:function(i){var s=e.attr(i,"tabindex"),n=isNaN(s);return(n||s>=0)&&t(i,!n)}}),e("<a>").outerWidth(1).jquery||e.each(["Width","Height"],function(t,i){function s(t,i,s,a){return e.each(n,function(){i-=parseFloat(e.css(t,"padding"+this))||0,s&&(i-=parseFloat(e.css(t,"border"+this+"Width"))||0),a&&(i-=parseFloat(e.css(t,"margin"+this))||0)}),i}var n="Width"===i?["Left","Right"]:["Top","Bottom"],a=i.toLowerCase(),o={innerWidth:e.fn.innerWidth,innerHeight:e.fn.innerHeight,outerWidth:e.fn.outerWidth,outerHeight:e.fn.outerHeight};e.fn["inner"+i]=function(t){return void 0===t?o["inner"+i].call(this):this.each(function(){e(this).css(a,s(this,t)+"px")})},e.fn["outer"+i]=function(t,n){return"number"!=typeof t?o["outer"+i].call(this,t):this.each(function(){e(this).css(a,s(this,t,!0,n)+"px")})}}),e.fn.addBack||(e.fn.addBack=function(e){return this.add(null==e?this.prevObject:this.prevObject.filter(e))}),e("<a>").data("a-b","a").removeData("a-b").data("a-b")&&(e.fn.removeData=function(t){return function(i){return arguments.length?t.call(this,e.camelCase(i)):t.call(this)}}(e.fn.removeData)),e.ui.ie=!!/msie [\w.]+/.exec(navigator.userAgent.toLowerCase()),e.fn.extend({focus:function(t){return function(i,s){return"number"==typeof i?this.each(function(){var t=this;setTimeout(function(){e(t).focus(),s&&s.call(t)},i)}):t.apply(this,arguments)}}(e.fn.focus),disableSelection:function(){var e="onselectstart"in document.createElement("div")?"selectstart":"mousedown";return function(){return this.bind(e+".ui-disableSelection",function(e){e.preventDefault()})}}(),enableSelection:function(){return this.unbind(".ui-disableSelection")},zIndex:function(t){if(void 0!==t)return this.css("zIndex",t);if(this.length)for(var i,s,n=e(this[0]);n.length&&n[0]!==document;){if(i=n.css("position"),("absolute"===i||"relative"===i||"fixed"===i)&&(s=parseInt(n.css("zIndex"),10),!isNaN(s)&&0!==s))return s;n=n.parent()}return 0}}),e.ui.plugin={add:function(t,i,s){var n,a=e.ui[t].prototype;for(n in s)a.plugins[n]=a.plugins[n]||[],a.plugins[n].push([i,s[n]])},call:function(e,t,i,s){var n,a=e.plugins[t];if(a&&(s||e.element[0].parentNode&&11!==e.element[0].parentNode.nodeType))for(n=0;a.length>n;n++)e.options[a[n][0]]&&a[n][1].apply(e.element,i)}};var s=0,n=Array.prototype.slice;e.cleanData=function(t){return function(i){var s,n,a;for(a=0;null!=(n=i[a]);a++)try{s=e._data(n,"events"),s&&s.remove&&e(n).triggerHandler("remove")}catch(o){}t(i)}}(e.cleanData),e.widget=function(t,i,s){var n,a,o,r,h={},l=t.split(".")[0];return t=t.split(".")[1],n=l+"-"+t,s||(s=i,i=e.Widget),e.expr[":"][n.toLowerCase()]=function(t){return!!e.data(t,n)},e[l]=e[l]||{},a=e[l][t],o=e[l][t]=function(e,t){return this._createWidget?(arguments.length&&this._createWidget(e,t),void 0):new o(e,t)},e.extend(o,a,{version:s.version,_proto:e.extend({},s),_childConstructors:[]}),r=new i,r.options=e.widget.extend({},r.options),e.each(s,function(t,s){return e.isFunction(s)?(h[t]=function(){var e=function(){return i.prototype[t].apply(this,arguments)},n=function(e){return i.prototype[t].apply(this,e)};return function(){var t,i=this._super,a=this._superApply;return this._super=e,this._superApply=n,t=s.apply(this,arguments),this._super=i,this._superApply=a,t}}(),void 0):(h[t]=s,void 0)}),o.prototype=e.widget.extend(r,{widgetEventPrefix:a?r.widgetEventPrefix||t:t},h,{constructor:o,namespace:l,widgetName:t,widgetFullName:n}),a?(e.each(a._childConstructors,function(t,i){var s=i.prototype;e.widget(s.namespace+"."+s.widgetName,o,i._proto)}),delete a._childConstructors):i._childConstructors.push(o),e.widget.bridge(t,o),o},e.widget.extend=function(t){for(var i,s,a=n.call(arguments,1),o=0,r=a.length;r>o;o++)for(i in a[o])s=a[o][i],a[o].hasOwnProperty(i)&&void 0!==s&&(t[i]=e.isPlainObject(s)?e.isPlainObject(t[i])?e.widget.extend({},t[i],s):e.widget.extend({},s):s);return t},e.widget.bridge=function(t,i){var s=i.prototype.widgetFullName||t;e.fn[t]=function(a){var o="string"==typeof a,r=n.call(arguments,1),h=this;return o?this.each(function(){var i,n=e.data(this,s);return"instance"===a?(h=n,!1):n?e.isFunction(n[a])&&"_"!==a.charAt(0)?(i=n[a].apply(n,r),i!==n&&void 0!==i?(h=i&&i.jquery?h.pushStack(i.get()):i,!1):void 0):e.error("no such method '"+a+"' for "+t+" widget instance"):e.error("cannot call methods on "+t+" prior to initialization; "+"attempted to call method '"+a+"'")}):(r.length&&(a=e.widget.extend.apply(null,[a].concat(r))),this.each(function(){var t=e.data(this,s);t?(t.option(a||{}),t._init&&t._init()):e.data(this,s,new i(a,this))})),h}},e.Widget=function(){},e.Widget._childConstructors=[],e.Widget.prototype={widgetName:"widget",widgetEventPrefix:"",defaultElement:"<div>",options:{disabled:!1,create:null},_createWidget:function(t,i){i=e(i||this.defaultElement||this)[0],this.element=e(i),this.uuid=s++,this.eventNamespace="."+this.widgetName+this.uuid,this.bindings=e(),this.hoverable=e(),this.focusable=e(),i!==this&&(e.data(i,this.widgetFullName,this),this._on(!0,this.element,{remove:function(e){e.target===i&&this.destroy()}}),this.document=e(i.style?i.ownerDocument:i.document||i),this.window=e(this.document[0].defaultView||this.document[0].parentWindow)),this.options=e.widget.extend({},this.options,this._getCreateOptions(),t),this._create(),this._trigger("create",null,this._getCreateEventData()),this._init()},_getCreateOptions:e.noop,_getCreateEventData:e.noop,_create:e.noop,_init:e.noop,destroy:function(){this._destroy(),this.element.unbind(this.eventNamespace).removeData(this.widgetFullName).removeData(e.camelCase(this.widgetFullName)),this.widget().unbind(this.eventNamespace).removeAttr("aria-disabled").removeClass(this.widgetFullName+"-disabled "+"ui-state-disabled"),this.bindings.unbind(this.eventNamespace),this.hoverable.removeClass("ui-state-hover"),this.focusable.removeClass("ui-state-focus")},_destroy:e.noop,widget:function(){return this.element},option:function(t,i){var s,n,a,o=t;if(0===arguments.length)return e.widget.extend({},this.options);if("string"==typeof t)if(o={},s=t.split("."),t=s.shift(),s.length){for(n=o[t]=e.widget.extend({},this.options[t]),a=0;s.length-1>a;a++)n[s[a]]=n[s[a]]||{},n=n[s[a]];if(t=s.pop(),1===arguments.length)return void 0===n[t]?null:n[t];n[t]=i}else{if(1===arguments.length)return void 0===this.options[t]?null:this.options[t];o[t]=i}return this._setOptions(o),this},_setOptions:function(e){var t;for(t in e)this._setOption(t,e[t]);return this},_setOption:function(e,t){return this.options[e]=t,"disabled"===e&&(this.widget().toggleClass(this.widgetFullName+"-disabled",!!t),t&&(this.hoverable.removeClass("ui-state-hover"),this.focusable.removeClass("ui-state-focus"))),this},enable:function(){return this._setOptions({disabled:!1})},disable:function(){return this._setOptions({disabled:!0})},_on:function(t,i,s){var n,a=this;"boolean"!=typeof t&&(s=i,i=t,t=!1),s?(i=n=e(i),this.bindings=this.bindings.add(i)):(s=i,i=this.element,n=this.widget()),e.each(s,function(s,o){function r(){return t||a.options.disabled!==!0&&!e(this).hasClass("ui-state-disabled")?("string"==typeof o?a[o]:o).apply(a,arguments):void 0}"string"!=typeof o&&(r.guid=o.guid=o.guid||r.guid||e.guid++);var h=s.match(/^([\w:-]*)\s*(.*)$/),l=h[1]+a.eventNamespace,u=h[2];u?n.delegate(u,l,r):i.bind(l,r)})},_off:function(t,i){i=(i||"").split(" ").join(this.eventNamespace+" ")+this.eventNamespace,t.unbind(i).undelegate(i),this.bindings=e(this.bindings.not(t).get()),this.focusable=e(this.focusable.not(t).get()),this.hoverable=e(this.hoverable.not(t).get())},_delay:function(e,t){function i(){return("string"==typeof e?s[e]:e).apply(s,arguments)}var s=this;return setTimeout(i,t||0)},_hoverable:function(t){this.hoverable=this.hoverable.add(t),this._on(t,{mouseenter:function(t){e(t.currentTarget).addClass("ui-state-hover")},mouseleave:function(t){e(t.currentTarget).removeClass("ui-state-hover")}})},_focusable:function(t){this.focusable=this.focusable.add(t),this._on(t,{focusin:function(t){e(t.currentTarget).addClass("ui-state-focus")},focusout:function(t){e(t.currentTarget).removeClass("ui-state-focus")}})},_trigger:function(t,i,s){var n,a,o=this.options[t];if(s=s||{},i=e.Event(i),i.type=(t===this.widgetEventPrefix?t:this.widgetEventPrefix+t).toLowerCase(),i.target=this.element[0],a=i.originalEvent)for(n in a)n in i||(i[n]=a[n]);return this.element.trigger(i,s),!(e.isFunction(o)&&o.apply(this.element[0],[i].concat(s))===!1||i.isDefaultPrevented())}},e.each({show:"fadeIn",hide:"fadeOut"},function(t,i){e.Widget.prototype["_"+t]=function(s,n,a){"string"==typeof n&&(n={effect:n});var o,r=n?n===!0||"number"==typeof n?i:n.effect||i:t;n=n||{},"number"==typeof n&&(n={duration:n}),o=!e.isEmptyObject(n),n.complete=a,n.delay&&s.delay(n.delay),o&&e.effects&&e.effects.effect[r]?s[t](n):r!==t&&s[r]?s[r](n.duration,n.easing,a):s.queue(function(i){e(this)[t](),a&&a.call(s[0]),i()})}}),e.widget;var a=!1;e(document).mouseup(function(){a=!1}),e.widget("ui.mouse",{version:"1.11.4",options:{cancel:"input,textarea,button,select,option",distance:1,delay:0},_mouseInit:function(){var t=this;this.element.bind("mousedown."+this.widgetName,function(e){return t._mouseDown(e)}).bind("click."+this.widgetName,function(i){return!0===e.data(i.target,t.widgetName+".preventClickEvent")?(e.removeData(i.target,t.widgetName+".preventClickEvent"),i.stopImmediatePropagation(),!1):void 0}),this.started=!1},_mouseDestroy:function(){this.element.unbind("."+this.widgetName),this._mouseMoveDelegate&&this.document.unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate)},_mouseDown:function(t){if(!a){this._mouseMoved=!1,this._mouseStarted&&this._mouseUp(t),this._mouseDownEvent=t;var i=this,s=1===t.which,n="string"==typeof this.options.cancel&&t.target.nodeName?e(t.target).closest(this.options.cancel).length:!1;return s&&!n&&this._mouseCapture(t)?(this.mouseDelayMet=!this.options.delay,this.mouseDelayMet||(this._mouseDelayTimer=setTimeout(function(){i.mouseDelayMet=!0},this.options.delay)),this._mouseDistanceMet(t)&&this._mouseDelayMet(t)&&(this._mouseStarted=this._mouseStart(t)!==!1,!this._mouseStarted)?(t.preventDefault(),!0):(!0===e.data(t.target,this.widgetName+".preventClickEvent")&&e.removeData(t.target,this.widgetName+".preventClickEvent"),this._mouseMoveDelegate=function(e){return i._mouseMove(e)},this._mouseUpDelegate=function(e){return i._mouseUp(e)},this.document.bind("mousemove."+this.widgetName,this._mouseMoveDelegate).bind("mouseup."+this.widgetName,this._mouseUpDelegate),t.preventDefault(),a=!0,!0)):!0}},_mouseMove:function(t){if(this._mouseMoved){if(e.ui.ie&&(!document.documentMode||9>document.documentMode)&&!t.button)return this._mouseUp(t);if(!t.which)return this._mouseUp(t)}return(t.which||t.button)&&(this._mouseMoved=!0),this._mouseStarted?(this._mouseDrag(t),t.preventDefault()):(this._mouseDistanceMet(t)&&this._mouseDelayMet(t)&&(this._mouseStarted=this._mouseStart(this._mouseDownEvent,t)!==!1,this._mouseStarted?this._mouseDrag(t):this._mouseUp(t)),!this._mouseStarted)},_mouseUp:function(t){return this.document.unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate),this._mouseStarted&&(this._mouseStarted=!1,t.target===this._mouseDownEvent.target&&e.data(t.target,this.widgetName+".preventClickEvent",!0),this._mouseStop(t)),a=!1,!1},_mouseDistanceMet:function(e){return Math.max(Math.abs(this._mouseDownEvent.pageX-e.pageX),Math.abs(this._mouseDownEvent.pageY-e.pageY))>=this.options.distance},_mouseDelayMet:function(){return this.mouseDelayMet},_mouseStart:function(){},_mouseDrag:function(){},_mouseStop:function(){},_mouseCapture:function(){return!0}}),function(){function t(e,t,i){return[parseFloat(e[0])*(p.test(e[0])?t/100:1),parseFloat(e[1])*(p.test(e[1])?i/100:1)]}function i(t,i){return parseInt(e.css(t,i),10)||0}function s(t){var i=t[0];return 9===i.nodeType?{width:t.width(),height:t.height(),offset:{top:0,left:0}}:e.isWindow(i)?{width:t.width(),height:t.height(),offset:{top:t.scrollTop(),left:t.scrollLeft()}}:i.preventDefault?{width:0,height:0,offset:{top:i.pageY,left:i.pageX}}:{width:t.outerWidth(),height:t.outerHeight(),offset:t.offset()}}e.ui=e.ui||{};var n,a,o=Math.max,r=Math.abs,h=Math.round,l=/left|center|right/,u=/top|center|bottom/,d=/[\+\-]\d+(\.[\d]+)?%?/,c=/^\w+/,p=/%$/,f=e.fn.position;e.position={scrollbarWidth:function(){if(void 0!==n)return n;var t,i,s=e("<div style='display:block;position:absolute;width:50px;height:50px;overflow:hidden;'><div style='height:100px;width:auto;'></div></div>"),a=s.children()[0];return e("body").append(s),t=a.offsetWidth,s.css("overflow","scroll"),i=a.offsetWidth,t===i&&(i=s[0].clientWidth),s.remove(),n=t-i},getScrollInfo:function(t){var i=t.isWindow||t.isDocument?"":t.element.css("overflow-x"),s=t.isWindow||t.isDocument?"":t.element.css("overflow-y"),n="scroll"===i||"auto"===i&&t.width<t.element[0].scrollWidth,a="scroll"===s||"auto"===s&&t.height<t.element[0].scrollHeight;return{width:a?e.position.scrollbarWidth():0,height:n?e.position.scrollbarWidth():0}},getWithinInfo:function(t){var i=e(t||window),s=e.isWindow(i[0]),n=!!i[0]&&9===i[0].nodeType;return{element:i,isWindow:s,isDocument:n,offset:i.offset()||{left:0,top:0},scrollLeft:i.scrollLeft(),scrollTop:i.scrollTop(),width:s||n?i.width():i.outerWidth(),height:s||n?i.height():i.outerHeight()}}},e.fn.position=function(n){if(!n||!n.of)return f.apply(this,arguments);n=e.extend({},n);var p,m,g,v,y,b,_=e(n.of),x=e.position.getWithinInfo(n.within),w=e.position.getScrollInfo(x),k=(n.collision||"flip").split(" "),T={};return b=s(_),_[0].preventDefault&&(n.at="left top"),m=b.width,g=b.height,v=b.offset,y=e.extend({},v),e.each(["my","at"],function(){var e,t,i=(n[this]||"").split(" ");1===i.length&&(i=l.test(i[0])?i.concat(["center"]):u.test(i[0])?["center"].concat(i):["center","center"]),i[0]=l.test(i[0])?i[0]:"center",i[1]=u.test(i[1])?i[1]:"center",e=d.exec(i[0]),t=d.exec(i[1]),T[this]=[e?e[0]:0,t?t[0]:0],n[this]=[c.exec(i[0])[0],c.exec(i[1])[0]]}),1===k.length&&(k[1]=k[0]),"right"===n.at[0]?y.left+=m:"center"===n.at[0]&&(y.left+=m/2),"bottom"===n.at[1]?y.top+=g:"center"===n.at[1]&&(y.top+=g/2),p=t(T.at,m,g),y.left+=p[0],y.top+=p[1],this.each(function(){var s,l,u=e(this),d=u.outerWidth(),c=u.outerHeight(),f=i(this,"marginLeft"),b=i(this,"marginTop"),D=d+f+i(this,"marginRight")+w.width,S=c+b+i(this,"marginBottom")+w.height,N=e.extend({},y),M=t(T.my,u.outerWidth(),u.outerHeight());"right"===n.my[0]?N.left-=d:"center"===n.my[0]&&(N.left-=d/2),"bottom"===n.my[1]?N.top-=c:"center"===n.my[1]&&(N.top-=c/2),N.left+=M[0],N.top+=M[1],a||(N.left=h(N.left),N.top=h(N.top)),s={marginLeft:f,marginTop:b},e.each(["left","top"],function(t,i){e.ui.position[k[t]]&&e.ui.position[k[t]][i](N,{targetWidth:m,targetHeight:g,elemWidth:d,elemHeight:c,collisionPosition:s,collisionWidth:D,collisionHeight:S,offset:[p[0]+M[0],p[1]+M[1]],my:n.my,at:n.at,within:x,elem:u})}),n.using&&(l=function(e){var t=v.left-N.left,i=t+m-d,s=v.top-N.top,a=s+g-c,h={target:{element:_,left:v.left,top:v.top,width:m,height:g},element:{element:u,left:N.left,top:N.top,width:d,height:c},horizontal:0>i?"left":t>0?"right":"center",vertical:0>a?"top":s>0?"bottom":"middle"};d>m&&m>r(t+i)&&(h.horizontal="center"),c>g&&g>r(s+a)&&(h.vertical="middle"),h.important=o(r(t),r(i))>o(r(s),r(a))?"horizontal":"vertical",n.using.call(this,e,h)}),u.offset(e.extend(N,{using:l}))})},e.ui.position={fit:{left:function(e,t){var i,s=t.within,n=s.isWindow?s.scrollLeft:s.offset.left,a=s.width,r=e.left-t.collisionPosition.marginLeft,h=n-r,l=r+t.collisionWidth-a-n;t.collisionWidth>a?h>0&&0>=l?(i=e.left+h+t.collisionWidth-a-n,e.left+=h-i):e.left=l>0&&0>=h?n:h>l?n+a-t.collisionWidth:n:h>0?e.left+=h:l>0?e.left-=l:e.left=o(e.left-r,e.left)},top:function(e,t){var i,s=t.within,n=s.isWindow?s.scrollTop:s.offset.top,a=t.within.height,r=e.top-t.collisionPosition.marginTop,h=n-r,l=r+t.collisionHeight-a-n;t.collisionHeight>a?h>0&&0>=l?(i=e.top+h+t.collisionHeight-a-n,e.top+=h-i):e.top=l>0&&0>=h?n:h>l?n+a-t.collisionHeight:n:h>0?e.top+=h:l>0?e.top-=l:e.top=o(e.top-r,e.top)}},flip:{left:function(e,t){var i,s,n=t.within,a=n.offset.left+n.scrollLeft,o=n.width,h=n.isWindow?n.scrollLeft:n.offset.left,l=e.left-t.collisionPosition.marginLeft,u=l-h,d=l+t.collisionWidth-o-h,c="left"===t.my[0]?-t.elemWidth:"right"===t.my[0]?t.elemWidth:0,p="left"===t.at[0]?t.targetWidth:"right"===t.at[0]?-t.targetWidth:0,f=-2*t.offset[0];0>u?(i=e.left+c+p+f+t.collisionWidth-o-a,(0>i||r(u)>i)&&(e.left+=c+p+f)):d>0&&(s=e.left-t.collisionPosition.marginLeft+c+p+f-h,(s>0||d>r(s))&&(e.left+=c+p+f))},top:function(e,t){var i,s,n=t.within,a=n.offset.top+n.scrollTop,o=n.height,h=n.isWindow?n.scrollTop:n.offset.top,l=e.top-t.collisionPosition.marginTop,u=l-h,d=l+t.collisionHeight-o-h,c="top"===t.my[1],p=c?-t.elemHeight:"bottom"===t.my[1]?t.elemHeight:0,f="top"===t.at[1]?t.targetHeight:"bottom"===t.at[1]?-t.targetHeight:0,m=-2*t.offset[1];0>u?(s=e.top+p+f+m+t.collisionHeight-o-a,(0>s||r(u)>s)&&(e.top+=p+f+m)):d>0&&(i=e.top-t.collisionPosition.marginTop+p+f+m-h,(i>0||d>r(i))&&(e.top+=p+f+m))}},flipfit:{left:function(){e.ui.position.flip.left.apply(this,arguments),e.ui.position.fit.left.apply(this,arguments)},top:function(){e.ui.position.flip.top.apply(this,arguments),e.ui.position.fit.top.apply(this,arguments)}}},function(){var t,i,s,n,o,r=document.getElementsByTagName("body")[0],h=document.createElement("div");t=document.createElement(r?"div":"body"),s={visibility:"hidden",width:0,height:0,border:0,margin:0,background:"none"},r&&e.extend(s,{position:"absolute",left:"-1000px",top:"-1000px"});for(o in s)t.style[o]=s[o];t.appendChild(h),i=r||document.documentElement,i.insertBefore(t,i.firstChild),h.style.cssText="position: absolute; left: 10.7432222px;",n=e(h).offset().left,a=n>10&&11>n,t.innerHTML="",i.removeChild(t)}()}(),e.ui.position,e.widget("ui.draggable",e.ui.mouse,{version:"1.11.4",widgetEventPrefix:"drag",options:{addClasses:!0,appendTo:"parent",axis:!1,connectToSortable:!1,containment:!1,cursor:"auto",cursorAt:!1,grid:!1,handle:!1,helper:"original",iframeFix:!1,opacity:!1,refreshPositions:!1,revert:!1,revertDuration:500,scope:"default",scroll:!0,scrollSensitivity:20,scrollSpeed:20,snap:!1,snapMode:"both",snapTolerance:20,stack:!1,zIndex:!1,drag:null,start:null,stop:null},_create:function(){"original"===this.options.helper&&this._setPositionRelative(),this.options.addClasses&&this.element.addClass("ui-draggable"),this.options.disabled&&this.element.addClass("ui-draggable-disabled"),this._setHandleClassName(),this._mouseInit()},_setOption:function(e,t){this._super(e,t),"handle"===e&&(this._removeHandleClassName(),this._setHandleClassName())},_destroy:function(){return(this.helper||this.element).is(".ui-draggable-dragging")?(this.destroyOnClear=!0,void 0):(this.element.removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled"),this._removeHandleClassName(),this._mouseDestroy(),void 0)},_mouseCapture:function(t){var i=this.options;return this._blurActiveElement(t),this.helper||i.disabled||e(t.target).closest(".ui-resizable-handle").length>0?!1:(this.handle=this._getHandle(t),this.handle?(this._blockFrames(i.iframeFix===!0?"iframe":i.iframeFix),!0):!1)},_blockFrames:function(t){this.iframeBlocks=this.document.find(t).map(function(){var t=e(this);return e("<div>").css("position","absolute").appendTo(t.parent()).outerWidth(t.outerWidth()).outerHeight(t.outerHeight()).offset(t.offset())[0]})},_unblockFrames:function(){this.iframeBlocks&&(this.iframeBlocks.remove(),delete this.iframeBlocks)},_blurActiveElement:function(t){var i=this.document[0];if(this.handleElement.is(t.target))try{i.activeElement&&"body"!==i.activeElement.nodeName.toLowerCase()&&e(i.activeElement).blur()}catch(s){}},_mouseStart:function(t){var i=this.options;return this.helper=this._createHelper(t),this.helper.addClass("ui-draggable-dragging"),this._cacheHelperProportions(),e.ui.ddmanager&&(e.ui.ddmanager.current=this),this._cacheMargins(),this.cssPosition=this.helper.css("position"),this.scrollParent=this.helper.scrollParent(!0),this.offsetParent=this.helper.offsetParent(),this.hasFixedAncestor=this.helper.parents().filter(function(){return"fixed"===e(this).css("position")}).length>0,this.positionAbs=this.element.offset(),this._refreshOffsets(t),this.originalPosition=this.position=this._generatePosition(t,!1),this.originalPageX=t.pageX,this.originalPageY=t.pageY,i.cursorAt&&this._adjustOffsetFromHelper(i.cursorAt),this._setContainment(),this._trigger("start",t)===!1?(this._clear(),!1):(this._cacheHelperProportions(),e.ui.ddmanager&&!i.dropBehaviour&&e.ui.ddmanager.prepareOffsets(this,t),this._normalizeRightBottom(),this._mouseDrag(t,!0),e.ui.ddmanager&&e.ui.ddmanager.dragStart(this,t),!0)},_refreshOffsets:function(e){this.offset={top:this.positionAbs.top-this.margins.top,left:this.positionAbs.left-this.margins.left,scroll:!1,parent:this._getParentOffset(),relative:this._getRelativeOffset()},this.offset.click={left:e.pageX-this.offset.left,top:e.pageY-this.offset.top}},_mouseDrag:function(t,i){if(this.hasFixedAncestor&&(this.offset.parent=this._getParentOffset()),this.position=this._generatePosition(t,!0),this.positionAbs=this._convertPositionTo("absolute"),!i){var s=this._uiHash();if(this._trigger("drag",t,s)===!1)return this._mouseUp({}),!1;this.position=s.position}return this.helper[0].style.left=this.position.left+"px",this.helper[0].style.top=this.position.top+"px",e.ui.ddmanager&&e.ui.ddmanager.drag(this,t),!1},_mouseStop:function(t){var i=this,s=!1;return e.ui.ddmanager&&!this.options.dropBehaviour&&(s=e.ui.ddmanager.drop(this,t)),this.dropped&&(s=this.dropped,this.dropped=!1),"invalid"===this.options.revert&&!s||"valid"===this.options.revert&&s||this.options.revert===!0||e.isFunction(this.options.revert)&&this.options.revert.call(this.element,s)?e(this.helper).animate(this.originalPosition,parseInt(this.options.revertDuration,10),function(){i._trigger("stop",t)!==!1&&i._clear()}):this._trigger("stop",t)!==!1&&this._clear(),!1},_mouseUp:function(t){return this._unblockFrames(),e.ui.ddmanager&&e.ui.ddmanager.dragStop(this,t),this.handleElement.is(t.target)&&this.element.focus(),e.ui.mouse.prototype._mouseUp.call(this,t)},cancel:function(){return this.helper.is(".ui-draggable-dragging")?this._mouseUp({}):this._clear(),this},_getHandle:function(t){return this.options.handle?!!e(t.target).closest(this.element.find(this.options.handle)).length:!0},_setHandleClassName:function(){this.handleElement=this.options.handle?this.element.find(this.options.handle):this.element,this.handleElement.addClass("ui-draggable-handle")},_removeHandleClassName:function(){this.handleElement.removeClass("ui-draggable-handle")},_createHelper:function(t){var i=this.options,s=e.isFunction(i.helper),n=s?e(i.helper.apply(this.element[0],[t])):"clone"===i.helper?this.element.clone().removeAttr("id"):this.element;return n.parents("body").length||n.appendTo("parent"===i.appendTo?this.element[0].parentNode:i.appendTo),s&&n[0]===this.element[0]&&this._setPositionRelative(),n[0]===this.element[0]||/(fixed|absolute)/.test(n.css("position"))||n.css("position","absolute"),n},_setPositionRelative:function(){/^(?:r|a|f)/.test(this.element.css("position"))||(this.element[0].style.position="relative")},_adjustOffsetFromHelper:function(t){"string"==typeof t&&(t=t.split(" ")),e.isArray(t)&&(t={left:+t[0],top:+t[1]||0}),"left"in t&&(this.offset.click.left=t.left+this.margins.left),"right"in t&&(this.offset.click.left=this.helperProportions.width-t.right+this.margins.left),"top"in t&&(this.offset.click.top=t.top+this.margins.top),"bottom"in t&&(this.offset.click.top=this.helperProportions.height-t.bottom+this.margins.top)},_isRootNode:function(e){return/(html|body)/i.test(e.tagName)||e===this.document[0]},_getParentOffset:function(){var t=this.offsetParent.offset(),i=this.document[0];return"absolute"===this.cssPosition&&this.scrollParent[0]!==i&&e.contains(this.scrollParent[0],this.offsetParent[0])&&(t.left+=this.scrollParent.scrollLeft(),t.top+=this.scrollParent.scrollTop()),this._isRootNode(this.offsetParent[0])&&(t={top:0,left:0}),{top:t.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:t.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}},_getRelativeOffset:function(){if("relative"!==this.cssPosition)return{top:0,left:0};var e=this.element.position(),t=this._isRootNode(this.scrollParent[0]);return{top:e.top-(parseInt(this.helper.css("top"),10)||0)+(t?0:this.scrollParent.scrollTop()),left:e.left-(parseInt(this.helper.css("left"),10)||0)+(t?0:this.scrollParent.scrollLeft())}},_cacheMargins:function(){this.margins={left:parseInt(this.element.css("marginLeft"),10)||0,top:parseInt(this.element.css("marginTop"),10)||0,right:parseInt(this.element.css("marginRight"),10)||0,bottom:parseInt(this.element.css("marginBottom"),10)||0}},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var t,i,s,n=this.options,a=this.document[0];return this.relativeContainer=null,n.containment?"window"===n.containment?(this.containment=[e(window).scrollLeft()-this.offset.relative.left-this.offset.parent.left,e(window).scrollTop()-this.offset.relative.top-this.offset.parent.top,e(window).scrollLeft()+e(window).width()-this.helperProportions.width-this.margins.left,e(window).scrollTop()+(e(window).height()||a.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top],void 0):"document"===n.containment?(this.containment=[0,0,e(a).width()-this.helperProportions.width-this.margins.left,(e(a).height()||a.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top],void 0):n.containment.constructor===Array?(this.containment=n.containment,void 0):("parent"===n.containment&&(n.containment=this.helper[0].parentNode),i=e(n.containment),s=i[0],s&&(t=/(scroll|auto)/.test(i.css("overflow")),this.containment=[(parseInt(i.css("borderLeftWidth"),10)||0)+(parseInt(i.css("paddingLeft"),10)||0),(parseInt(i.css("borderTopWidth"),10)||0)+(parseInt(i.css("paddingTop"),10)||0),(t?Math.max(s.scrollWidth,s.offsetWidth):s.offsetWidth)-(parseInt(i.css("borderRightWidth"),10)||0)-(parseInt(i.css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left-this.margins.right,(t?Math.max(s.scrollHeight,s.offsetHeight):s.offsetHeight)-(parseInt(i.css("borderBottomWidth"),10)||0)-(parseInt(i.css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top-this.margins.bottom],this.relativeContainer=i),void 0):(this.containment=null,void 0)},_convertPositionTo:function(e,t){t||(t=this.position);var i="absolute"===e?1:-1,s=this._isRootNode(this.scrollParent[0]);return{top:t.top+this.offset.relative.top*i+this.offset.parent.top*i-("fixed"===this.cssPosition?-this.offset.scroll.top:s?0:this.offset.scroll.top)*i,left:t.left+this.offset.relative.left*i+this.offset.parent.left*i-("fixed"===this.cssPosition?-this.offset.scroll.left:s?0:this.offset.scroll.left)*i}},_generatePosition:function(e,t){var i,s,n,a,o=this.options,r=this._isRootNode(this.scrollParent[0]),h=e.pageX,l=e.pageY;return r&&this.offset.scroll||(this.offset.scroll={top:this.scrollParent.scrollTop(),left:this.scrollParent.scrollLeft()}),t&&(this.containment&&(this.relativeContainer?(s=this.relativeContainer.offset(),i=[this.containment[0]+s.left,this.containment[1]+s.top,this.containment[2]+s.left,this.containment[3]+s.top]):i=this.containment,e.pageX-this.offset.click.left<i[0]&&(h=i[0]+this.offset.click.left),e.pageY-this.offset.click.top<i[1]&&(l=i[1]+this.offset.click.top),e.pageX-this.offset.click.left>i[2]&&(h=i[2]+this.offset.click.left),e.pageY-this.offset.click.top>i[3]&&(l=i[3]+this.offset.click.top)),o.grid&&(n=o.grid[1]?this.originalPageY+Math.round((l-this.originalPageY)/o.grid[1])*o.grid[1]:this.originalPageY,l=i?n-this.offset.click.top>=i[1]||n-this.offset.click.top>i[3]?n:n-this.offset.click.top>=i[1]?n-o.grid[1]:n+o.grid[1]:n,a=o.grid[0]?this.originalPageX+Math.round((h-this.originalPageX)/o.grid[0])*o.grid[0]:this.originalPageX,h=i?a-this.offset.click.left>=i[0]||a-this.offset.click.left>i[2]?a:a-this.offset.click.left>=i[0]?a-o.grid[0]:a+o.grid[0]:a),"y"===o.axis&&(h=this.originalPageX),"x"===o.axis&&(l=this.originalPageY)),{top:l-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+("fixed"===this.cssPosition?-this.offset.scroll.top:r?0:this.offset.scroll.top),left:h-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+("fixed"===this.cssPosition?-this.offset.scroll.left:r?0:this.offset.scroll.left)}},_clear:function(){this.helper.removeClass("ui-draggable-dragging"),this.helper[0]===this.element[0]||this.cancelHelperRemoval||this.helper.remove(),this.helper=null,this.cancelHelperRemoval=!1,this.destroyOnClear&&this.destroy()},_normalizeRightBottom:function(){"y"!==this.options.axis&&"auto"!==this.helper.css("right")&&(this.helper.width(this.helper.width()),this.helper.css("right","auto")),"x"!==this.options.axis&&"auto"!==this.helper.css("bottom")&&(this.helper.height(this.helper.height()),this.helper.css("bottom","auto"))},_trigger:function(t,i,s){return s=s||this._uiHash(),e.ui.plugin.call(this,t,[i,s,this],!0),/^(drag|start|stop)/.test(t)&&(this.positionAbs=this._convertPositionTo("absolute"),s.offset=this.positionAbs),e.Widget.prototype._trigger.call(this,t,i,s)},plugins:{},_uiHash:function(){return{helper:this.helper,position:this.position,originalPosition:this.originalPosition,offset:this.positionAbs}}}),e.ui.plugin.add("draggable","connectToSortable",{start:function(t,i,s){var n=e.extend({},i,{item:s.element});s.sortables=[],e(s.options.connectToSortable).each(function(){var i=e(this).sortable("instance");i&&!i.options.disabled&&(s.sortables.push(i),i.refreshPositions(),i._trigger("activate",t,n))})},stop:function(t,i,s){var n=e.extend({},i,{item:s.element});s.cancelHelperRemoval=!1,e.each(s.sortables,function(){var e=this;e.isOver?(e.isOver=0,s.cancelHelperRemoval=!0,e.cancelHelperRemoval=!1,e._storedCSS={position:e.placeholder.css("position"),top:e.placeholder.css("top"),left:e.placeholder.css("left")},e._mouseStop(t),e.options.helper=e.options._helper):(e.cancelHelperRemoval=!0,e._trigger("deactivate",t,n))})},drag:function(t,i,s){e.each(s.sortables,function(){var n=!1,a=this;a.positionAbs=s.positionAbs,a.helperProportions=s.helperProportions,a.offset.click=s.offset.click,a._intersectsWith(a.containerCache)&&(n=!0,e.each(s.sortables,function(){return this.positionAbs=s.positionAbs,this.helperProportions=s.helperProportions,this.offset.click=s.offset.click,this!==a&&this._intersectsWith(this.containerCache)&&e.contains(a.element[0],this.element[0])&&(n=!1),n
})),n?(a.isOver||(a.isOver=1,s._parent=i.helper.parent(),a.currentItem=i.helper.appendTo(a.element).data("ui-sortable-item",!0),a.options._helper=a.options.helper,a.options.helper=function(){return i.helper[0]},t.target=a.currentItem[0],a._mouseCapture(t,!0),a._mouseStart(t,!0,!0),a.offset.click.top=s.offset.click.top,a.offset.click.left=s.offset.click.left,a.offset.parent.left-=s.offset.parent.left-a.offset.parent.left,a.offset.parent.top-=s.offset.parent.top-a.offset.parent.top,s._trigger("toSortable",t),s.dropped=a.element,e.each(s.sortables,function(){this.refreshPositions()}),s.currentItem=s.element,a.fromOutside=s),a.currentItem&&(a._mouseDrag(t),i.position=a.position)):a.isOver&&(a.isOver=0,a.cancelHelperRemoval=!0,a.options._revert=a.options.revert,a.options.revert=!1,a._trigger("out",t,a._uiHash(a)),a._mouseStop(t,!0),a.options.revert=a.options._revert,a.options.helper=a.options._helper,a.placeholder&&a.placeholder.remove(),i.helper.appendTo(s._parent),s._refreshOffsets(t),i.position=s._generatePosition(t,!0),s._trigger("fromSortable",t),s.dropped=!1,e.each(s.sortables,function(){this.refreshPositions()}))})}}),e.ui.plugin.add("draggable","cursor",{start:function(t,i,s){var n=e("body"),a=s.options;n.css("cursor")&&(a._cursor=n.css("cursor")),n.css("cursor",a.cursor)},stop:function(t,i,s){var n=s.options;n._cursor&&e("body").css("cursor",n._cursor)}}),e.ui.plugin.add("draggable","opacity",{start:function(t,i,s){var n=e(i.helper),a=s.options;n.css("opacity")&&(a._opacity=n.css("opacity")),n.css("opacity",a.opacity)},stop:function(t,i,s){var n=s.options;n._opacity&&e(i.helper).css("opacity",n._opacity)}}),e.ui.plugin.add("draggable","scroll",{start:function(e,t,i){i.scrollParentNotHidden||(i.scrollParentNotHidden=i.helper.scrollParent(!1)),i.scrollParentNotHidden[0]!==i.document[0]&&"HTML"!==i.scrollParentNotHidden[0].tagName&&(i.overflowOffset=i.scrollParentNotHidden.offset())},drag:function(t,i,s){var n=s.options,a=!1,o=s.scrollParentNotHidden[0],r=s.document[0];o!==r&&"HTML"!==o.tagName?(n.axis&&"x"===n.axis||(s.overflowOffset.top+o.offsetHeight-t.pageY<n.scrollSensitivity?o.scrollTop=a=o.scrollTop+n.scrollSpeed:t.pageY-s.overflowOffset.top<n.scrollSensitivity&&(o.scrollTop=a=o.scrollTop-n.scrollSpeed)),n.axis&&"y"===n.axis||(s.overflowOffset.left+o.offsetWidth-t.pageX<n.scrollSensitivity?o.scrollLeft=a=o.scrollLeft+n.scrollSpeed:t.pageX-s.overflowOffset.left<n.scrollSensitivity&&(o.scrollLeft=a=o.scrollLeft-n.scrollSpeed))):(n.axis&&"x"===n.axis||(t.pageY-e(r).scrollTop()<n.scrollSensitivity?a=e(r).scrollTop(e(r).scrollTop()-n.scrollSpeed):e(window).height()-(t.pageY-e(r).scrollTop())<n.scrollSensitivity&&(a=e(r).scrollTop(e(r).scrollTop()+n.scrollSpeed))),n.axis&&"y"===n.axis||(t.pageX-e(r).scrollLeft()<n.scrollSensitivity?a=e(r).scrollLeft(e(r).scrollLeft()-n.scrollSpeed):e(window).width()-(t.pageX-e(r).scrollLeft())<n.scrollSensitivity&&(a=e(r).scrollLeft(e(r).scrollLeft()+n.scrollSpeed)))),a!==!1&&e.ui.ddmanager&&!n.dropBehaviour&&e.ui.ddmanager.prepareOffsets(s,t)}}),e.ui.plugin.add("draggable","snap",{start:function(t,i,s){var n=s.options;s.snapElements=[],e(n.snap.constructor!==String?n.snap.items||":data(ui-draggable)":n.snap).each(function(){var t=e(this),i=t.offset();this!==s.element[0]&&s.snapElements.push({item:this,width:t.outerWidth(),height:t.outerHeight(),top:i.top,left:i.left})})},drag:function(t,i,s){var n,a,o,r,h,l,u,d,c,p,f=s.options,m=f.snapTolerance,g=i.offset.left,v=g+s.helperProportions.width,y=i.offset.top,b=y+s.helperProportions.height;for(c=s.snapElements.length-1;c>=0;c--)h=s.snapElements[c].left-s.margins.left,l=h+s.snapElements[c].width,u=s.snapElements[c].top-s.margins.top,d=u+s.snapElements[c].height,h-m>v||g>l+m||u-m>b||y>d+m||!e.contains(s.snapElements[c].item.ownerDocument,s.snapElements[c].item)?(s.snapElements[c].snapping&&s.options.snap.release&&s.options.snap.release.call(s.element,t,e.extend(s._uiHash(),{snapItem:s.snapElements[c].item})),s.snapElements[c].snapping=!1):("inner"!==f.snapMode&&(n=m>=Math.abs(u-b),a=m>=Math.abs(d-y),o=m>=Math.abs(h-v),r=m>=Math.abs(l-g),n&&(i.position.top=s._convertPositionTo("relative",{top:u-s.helperProportions.height,left:0}).top),a&&(i.position.top=s._convertPositionTo("relative",{top:d,left:0}).top),o&&(i.position.left=s._convertPositionTo("relative",{top:0,left:h-s.helperProportions.width}).left),r&&(i.position.left=s._convertPositionTo("relative",{top:0,left:l}).left)),p=n||a||o||r,"outer"!==f.snapMode&&(n=m>=Math.abs(u-y),a=m>=Math.abs(d-b),o=m>=Math.abs(h-g),r=m>=Math.abs(l-v),n&&(i.position.top=s._convertPositionTo("relative",{top:u,left:0}).top),a&&(i.position.top=s._convertPositionTo("relative",{top:d-s.helperProportions.height,left:0}).top),o&&(i.position.left=s._convertPositionTo("relative",{top:0,left:h}).left),r&&(i.position.left=s._convertPositionTo("relative",{top:0,left:l-s.helperProportions.width}).left)),!s.snapElements[c].snapping&&(n||a||o||r||p)&&s.options.snap.snap&&s.options.snap.snap.call(s.element,t,e.extend(s._uiHash(),{snapItem:s.snapElements[c].item})),s.snapElements[c].snapping=n||a||o||r||p)}}),e.ui.plugin.add("draggable","stack",{start:function(t,i,s){var n,a=s.options,o=e.makeArray(e(a.stack)).sort(function(t,i){return(parseInt(e(t).css("zIndex"),10)||0)-(parseInt(e(i).css("zIndex"),10)||0)});o.length&&(n=parseInt(e(o[0]).css("zIndex"),10)||0,e(o).each(function(t){e(this).css("zIndex",n+t)}),this.css("zIndex",n+o.length))}}),e.ui.plugin.add("draggable","zIndex",{start:function(t,i,s){var n=e(i.helper),a=s.options;n.css("zIndex")&&(a._zIndex=n.css("zIndex")),n.css("zIndex",a.zIndex)},stop:function(t,i,s){var n=s.options;n._zIndex&&e(i.helper).css("zIndex",n._zIndex)}}),e.ui.draggable,e.widget("ui.resizable",e.ui.mouse,{version:"1.11.4",widgetEventPrefix:"resize",options:{alsoResize:!1,animate:!1,animateDuration:"slow",animateEasing:"swing",aspectRatio:!1,autoHide:!1,containment:!1,ghost:!1,grid:!1,handles:"e,s,se",helper:!1,maxHeight:null,maxWidth:null,minHeight:10,minWidth:10,zIndex:90,resize:null,start:null,stop:null},_num:function(e){return parseInt(e,10)||0},_isNumber:function(e){return!isNaN(parseInt(e,10))},_hasScroll:function(t,i){if("hidden"===e(t).css("overflow"))return!1;var s=i&&"left"===i?"scrollLeft":"scrollTop",n=!1;return t[s]>0?!0:(t[s]=1,n=t[s]>0,t[s]=0,n)},_create:function(){var t,i,s,n,a,o=this,r=this.options;if(this.element.addClass("ui-resizable"),e.extend(this,{_aspectRatio:!!r.aspectRatio,aspectRatio:r.aspectRatio,originalElement:this.element,_proportionallyResizeElements:[],_helper:r.helper||r.ghost||r.animate?r.helper||"ui-resizable-helper":null}),this.element[0].nodeName.match(/^(canvas|textarea|input|select|button|img)$/i)&&(this.element.wrap(e("<div class='ui-wrapper' style='overflow: hidden;'></div>").css({position:this.element.css("position"),width:this.element.outerWidth(),height:this.element.outerHeight(),top:this.element.css("top"),left:this.element.css("left")})),this.element=this.element.parent().data("ui-resizable",this.element.resizable("instance")),this.elementIsWrapper=!0,this.element.css({marginLeft:this.originalElement.css("marginLeft"),marginTop:this.originalElement.css("marginTop"),marginRight:this.originalElement.css("marginRight"),marginBottom:this.originalElement.css("marginBottom")}),this.originalElement.css({marginLeft:0,marginTop:0,marginRight:0,marginBottom:0}),this.originalResizeStyle=this.originalElement.css("resize"),this.originalElement.css("resize","none"),this._proportionallyResizeElements.push(this.originalElement.css({position:"static",zoom:1,display:"block"})),this.originalElement.css({margin:this.originalElement.css("margin")}),this._proportionallyResize()),this.handles=r.handles||(e(".ui-resizable-handle",this.element).length?{n:".ui-resizable-n",e:".ui-resizable-e",s:".ui-resizable-s",w:".ui-resizable-w",se:".ui-resizable-se",sw:".ui-resizable-sw",ne:".ui-resizable-ne",nw:".ui-resizable-nw"}:"e,s,se"),this._handles=e(),this.handles.constructor===String)for("all"===this.handles&&(this.handles="n,e,s,w,se,sw,ne,nw"),t=this.handles.split(","),this.handles={},i=0;t.length>i;i++)s=e.trim(t[i]),a="ui-resizable-"+s,n=e("<div class='ui-resizable-handle "+a+"'></div>"),n.css({zIndex:r.zIndex}),"se"===s&&n.addClass("ui-icon ui-icon-gripsmall-diagonal-se"),this.handles[s]=".ui-resizable-"+s,this.element.append(n);this._renderAxis=function(t){var i,s,n,a;t=t||this.element;for(i in this.handles)this.handles[i].constructor===String?this.handles[i]=this.element.children(this.handles[i]).first().show():(this.handles[i].jquery||this.handles[i].nodeType)&&(this.handles[i]=e(this.handles[i]),this._on(this.handles[i],{mousedown:o._mouseDown})),this.elementIsWrapper&&this.originalElement[0].nodeName.match(/^(textarea|input|select|button)$/i)&&(s=e(this.handles[i],this.element),a=/sw|ne|nw|se|n|s/.test(i)?s.outerHeight():s.outerWidth(),n=["padding",/ne|nw|n/.test(i)?"Top":/se|sw|s/.test(i)?"Bottom":/^e$/.test(i)?"Right":"Left"].join(""),t.css(n,a),this._proportionallyResize()),this._handles=this._handles.add(this.handles[i])},this._renderAxis(this.element),this._handles=this._handles.add(this.element.find(".ui-resizable-handle")),this._handles.disableSelection(),this._handles.mouseover(function(){o.resizing||(this.className&&(n=this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i)),o.axis=n&&n[1]?n[1]:"se")}),r.autoHide&&(this._handles.hide(),e(this.element).addClass("ui-resizable-autohide").mouseenter(function(){r.disabled||(e(this).removeClass("ui-resizable-autohide"),o._handles.show())}).mouseleave(function(){r.disabled||o.resizing||(e(this).addClass("ui-resizable-autohide"),o._handles.hide())})),this._mouseInit()},_destroy:function(){this._mouseDestroy();var t,i=function(t){e(t).removeClass("ui-resizable ui-resizable-disabled ui-resizable-resizing").removeData("resizable").removeData("ui-resizable").unbind(".resizable").find(".ui-resizable-handle").remove()};return this.elementIsWrapper&&(i(this.element),t=this.element,this.originalElement.css({position:t.css("position"),width:t.outerWidth(),height:t.outerHeight(),top:t.css("top"),left:t.css("left")}).insertAfter(t),t.remove()),this.originalElement.css("resize",this.originalResizeStyle),i(this.originalElement),this},_mouseCapture:function(t){var i,s,n=!1;for(i in this.handles)s=e(this.handles[i])[0],(s===t.target||e.contains(s,t.target))&&(n=!0);return!this.options.disabled&&n},_mouseStart:function(t){var i,s,n,a=this.options,o=this.element;return this.resizing=!0,this._renderProxy(),i=this._num(this.helper.css("left")),s=this._num(this.helper.css("top")),a.containment&&(i+=e(a.containment).scrollLeft()||0,s+=e(a.containment).scrollTop()||0),this.offset=this.helper.offset(),this.position={left:i,top:s},this.size=this._helper?{width:this.helper.width(),height:this.helper.height()}:{width:o.width(),height:o.height()},this.originalSize=this._helper?{width:o.outerWidth(),height:o.outerHeight()}:{width:o.width(),height:o.height()},this.sizeDiff={width:o.outerWidth()-o.width(),height:o.outerHeight()-o.height()},this.originalPosition={left:i,top:s},this.originalMousePosition={left:t.pageX,top:t.pageY},this.aspectRatio="number"==typeof a.aspectRatio?a.aspectRatio:this.originalSize.width/this.originalSize.height||1,n=e(".ui-resizable-"+this.axis).css("cursor"),e("body").css("cursor","auto"===n?this.axis+"-resize":n),o.addClass("ui-resizable-resizing"),this._propagate("start",t),!0},_mouseDrag:function(t){var i,s,n=this.originalMousePosition,a=this.axis,o=t.pageX-n.left||0,r=t.pageY-n.top||0,h=this._change[a];return this._updatePrevProperties(),h?(i=h.apply(this,[t,o,r]),this._updateVirtualBoundaries(t.shiftKey),(this._aspectRatio||t.shiftKey)&&(i=this._updateRatio(i,t)),i=this._respectSize(i,t),this._updateCache(i),this._propagate("resize",t),s=this._applyChanges(),!this._helper&&this._proportionallyResizeElements.length&&this._proportionallyResize(),e.isEmptyObject(s)||(this._updatePrevProperties(),this._trigger("resize",t,this.ui()),this._applyChanges()),!1):!1},_mouseStop:function(t){this.resizing=!1;var i,s,n,a,o,r,h,l=this.options,u=this;return this._helper&&(i=this._proportionallyResizeElements,s=i.length&&/textarea/i.test(i[0].nodeName),n=s&&this._hasScroll(i[0],"left")?0:u.sizeDiff.height,a=s?0:u.sizeDiff.width,o={width:u.helper.width()-a,height:u.helper.height()-n},r=parseInt(u.element.css("left"),10)+(u.position.left-u.originalPosition.left)||null,h=parseInt(u.element.css("top"),10)+(u.position.top-u.originalPosition.top)||null,l.animate||this.element.css(e.extend(o,{top:h,left:r})),u.helper.height(u.size.height),u.helper.width(u.size.width),this._helper&&!l.animate&&this._proportionallyResize()),e("body").css("cursor","auto"),this.element.removeClass("ui-resizable-resizing"),this._propagate("stop",t),this._helper&&this.helper.remove(),!1},_updatePrevProperties:function(){this.prevPosition={top:this.position.top,left:this.position.left},this.prevSize={width:this.size.width,height:this.size.height}},_applyChanges:function(){var e={};return this.position.top!==this.prevPosition.top&&(e.top=this.position.top+"px"),this.position.left!==this.prevPosition.left&&(e.left=this.position.left+"px"),this.size.width!==this.prevSize.width&&(e.width=this.size.width+"px"),this.size.height!==this.prevSize.height&&(e.height=this.size.height+"px"),this.helper.css(e),e},_updateVirtualBoundaries:function(e){var t,i,s,n,a,o=this.options;a={minWidth:this._isNumber(o.minWidth)?o.minWidth:0,maxWidth:this._isNumber(o.maxWidth)?o.maxWidth:1/0,minHeight:this._isNumber(o.minHeight)?o.minHeight:0,maxHeight:this._isNumber(o.maxHeight)?o.maxHeight:1/0},(this._aspectRatio||e)&&(t=a.minHeight*this.aspectRatio,s=a.minWidth/this.aspectRatio,i=a.maxHeight*this.aspectRatio,n=a.maxWidth/this.aspectRatio,t>a.minWidth&&(a.minWidth=t),s>a.minHeight&&(a.minHeight=s),a.maxWidth>i&&(a.maxWidth=i),a.maxHeight>n&&(a.maxHeight=n)),this._vBoundaries=a},_updateCache:function(e){this.offset=this.helper.offset(),this._isNumber(e.left)&&(this.position.left=e.left),this._isNumber(e.top)&&(this.position.top=e.top),this._isNumber(e.height)&&(this.size.height=e.height),this._isNumber(e.width)&&(this.size.width=e.width)},_updateRatio:function(e){var t=this.position,i=this.size,s=this.axis;return this._isNumber(e.height)?e.width=e.height*this.aspectRatio:this._isNumber(e.width)&&(e.height=e.width/this.aspectRatio),"sw"===s&&(e.left=t.left+(i.width-e.width),e.top=null),"nw"===s&&(e.top=t.top+(i.height-e.height),e.left=t.left+(i.width-e.width)),e},_respectSize:function(e){var t=this._vBoundaries,i=this.axis,s=this._isNumber(e.width)&&t.maxWidth&&t.maxWidth<e.width,n=this._isNumber(e.height)&&t.maxHeight&&t.maxHeight<e.height,a=this._isNumber(e.width)&&t.minWidth&&t.minWidth>e.width,o=this._isNumber(e.height)&&t.minHeight&&t.minHeight>e.height,r=this.originalPosition.left+this.originalSize.width,h=this.position.top+this.size.height,l=/sw|nw|w/.test(i),u=/nw|ne|n/.test(i);return a&&(e.width=t.minWidth),o&&(e.height=t.minHeight),s&&(e.width=t.maxWidth),n&&(e.height=t.maxHeight),a&&l&&(e.left=r-t.minWidth),s&&l&&(e.left=r-t.maxWidth),o&&u&&(e.top=h-t.minHeight),n&&u&&(e.top=h-t.maxHeight),e.width||e.height||e.left||!e.top?e.width||e.height||e.top||!e.left||(e.left=null):e.top=null,e},_getPaddingPlusBorderDimensions:function(e){for(var t=0,i=[],s=[e.css("borderTopWidth"),e.css("borderRightWidth"),e.css("borderBottomWidth"),e.css("borderLeftWidth")],n=[e.css("paddingTop"),e.css("paddingRight"),e.css("paddingBottom"),e.css("paddingLeft")];4>t;t++)i[t]=parseInt(s[t],10)||0,i[t]+=parseInt(n[t],10)||0;return{height:i[0]+i[2],width:i[1]+i[3]}},_proportionallyResize:function(){if(this._proportionallyResizeElements.length)for(var e,t=0,i=this.helper||this.element;this._proportionallyResizeElements.length>t;t++)e=this._proportionallyResizeElements[t],this.outerDimensions||(this.outerDimensions=this._getPaddingPlusBorderDimensions(e)),e.css({height:i.height()-this.outerDimensions.height||0,width:i.width()-this.outerDimensions.width||0})},_renderProxy:function(){var t=this.element,i=this.options;this.elementOffset=t.offset(),this._helper?(this.helper=this.helper||e("<div style='overflow:hidden;'></div>"),this.helper.addClass(this._helper).css({width:this.element.outerWidth()-1,height:this.element.outerHeight()-1,position:"absolute",left:this.elementOffset.left+"px",top:this.elementOffset.top+"px",zIndex:++i.zIndex}),this.helper.appendTo("body").disableSelection()):this.helper=this.element},_change:{e:function(e,t){return{width:this.originalSize.width+t}},w:function(e,t){var i=this.originalSize,s=this.originalPosition;return{left:s.left+t,width:i.width-t}},n:function(e,t,i){var s=this.originalSize,n=this.originalPosition;return{top:n.top+i,height:s.height-i}},s:function(e,t,i){return{height:this.originalSize.height+i}},se:function(t,i,s){return e.extend(this._change.s.apply(this,arguments),this._change.e.apply(this,[t,i,s]))},sw:function(t,i,s){return e.extend(this._change.s.apply(this,arguments),this._change.w.apply(this,[t,i,s]))},ne:function(t,i,s){return e.extend(this._change.n.apply(this,arguments),this._change.e.apply(this,[t,i,s]))},nw:function(t,i,s){return e.extend(this._change.n.apply(this,arguments),this._change.w.apply(this,[t,i,s]))}},_propagate:function(t,i){e.ui.plugin.call(this,t,[i,this.ui()]),"resize"!==t&&this._trigger(t,i,this.ui())},plugins:{},ui:function(){return{originalElement:this.originalElement,element:this.element,helper:this.helper,position:this.position,size:this.size,originalSize:this.originalSize,originalPosition:this.originalPosition}}}),e.ui.plugin.add("resizable","animate",{stop:function(t){var i=e(this).resizable("instance"),s=i.options,n=i._proportionallyResizeElements,a=n.length&&/textarea/i.test(n[0].nodeName),o=a&&i._hasScroll(n[0],"left")?0:i.sizeDiff.height,r=a?0:i.sizeDiff.width,h={width:i.size.width-r,height:i.size.height-o},l=parseInt(i.element.css("left"),10)+(i.position.left-i.originalPosition.left)||null,u=parseInt(i.element.css("top"),10)+(i.position.top-i.originalPosition.top)||null;i.element.animate(e.extend(h,u&&l?{top:u,left:l}:{}),{duration:s.animateDuration,easing:s.animateEasing,step:function(){var s={width:parseInt(i.element.css("width"),10),height:parseInt(i.element.css("height"),10),top:parseInt(i.element.css("top"),10),left:parseInt(i.element.css("left"),10)};n&&n.length&&e(n[0]).css({width:s.width,height:s.height}),i._updateCache(s),i._propagate("resize",t)}})}}),e.ui.plugin.add("resizable","containment",{start:function(){var t,i,s,n,a,o,r,h=e(this).resizable("instance"),l=h.options,u=h.element,d=l.containment,c=d instanceof e?d.get(0):/parent/.test(d)?u.parent().get(0):d;c&&(h.containerElement=e(c),/document/.test(d)||d===document?(h.containerOffset={left:0,top:0},h.containerPosition={left:0,top:0},h.parentData={element:e(document),left:0,top:0,width:e(document).width(),height:e(document).height()||document.body.parentNode.scrollHeight}):(t=e(c),i=[],e(["Top","Right","Left","Bottom"]).each(function(e,s){i[e]=h._num(t.css("padding"+s))}),h.containerOffset=t.offset(),h.containerPosition=t.position(),h.containerSize={height:t.innerHeight()-i[3],width:t.innerWidth()-i[1]},s=h.containerOffset,n=h.containerSize.height,a=h.containerSize.width,o=h._hasScroll(c,"left")?c.scrollWidth:a,r=h._hasScroll(c)?c.scrollHeight:n,h.parentData={element:c,left:s.left,top:s.top,width:o,height:r}))},resize:function(t){var i,s,n,a,o=e(this).resizable("instance"),r=o.options,h=o.containerOffset,l=o.position,u=o._aspectRatio||t.shiftKey,d={top:0,left:0},c=o.containerElement,p=!0;c[0]!==document&&/static/.test(c.css("position"))&&(d=h),l.left<(o._helper?h.left:0)&&(o.size.width=o.size.width+(o._helper?o.position.left-h.left:o.position.left-d.left),u&&(o.size.height=o.size.width/o.aspectRatio,p=!1),o.position.left=r.helper?h.left:0),l.top<(o._helper?h.top:0)&&(o.size.height=o.size.height+(o._helper?o.position.top-h.top:o.position.top),u&&(o.size.width=o.size.height*o.aspectRatio,p=!1),o.position.top=o._helper?h.top:0),n=o.containerElement.get(0)===o.element.parent().get(0),a=/relative|absolute/.test(o.containerElement.css("position")),n&&a?(o.offset.left=o.parentData.left+o.position.left,o.offset.top=o.parentData.top+o.position.top):(o.offset.left=o.element.offset().left,o.offset.top=o.element.offset().top),i=Math.abs(o.sizeDiff.width+(o._helper?o.offset.left-d.left:o.offset.left-h.left)),s=Math.abs(o.sizeDiff.height+(o._helper?o.offset.top-d.top:o.offset.top-h.top)),i+o.size.width>=o.parentData.width&&(o.size.width=o.parentData.width-i,u&&(o.size.height=o.size.width/o.aspectRatio,p=!1)),s+o.size.height>=o.parentData.height&&(o.size.height=o.parentData.height-s,u&&(o.size.width=o.size.height*o.aspectRatio,p=!1)),p||(o.position.left=o.prevPosition.left,o.position.top=o.prevPosition.top,o.size.width=o.prevSize.width,o.size.height=o.prevSize.height)},stop:function(){var t=e(this).resizable("instance"),i=t.options,s=t.containerOffset,n=t.containerPosition,a=t.containerElement,o=e(t.helper),r=o.offset(),h=o.outerWidth()-t.sizeDiff.width,l=o.outerHeight()-t.sizeDiff.height;t._helper&&!i.animate&&/relative/.test(a.css("position"))&&e(this).css({left:r.left-n.left-s.left,width:h,height:l}),t._helper&&!i.animate&&/static/.test(a.css("position"))&&e(this).css({left:r.left-n.left-s.left,width:h,height:l})}}),e.ui.plugin.add("resizable","alsoResize",{start:function(){var t=e(this).resizable("instance"),i=t.options;e(i.alsoResize).each(function(){var t=e(this);t.data("ui-resizable-alsoresize",{width:parseInt(t.width(),10),height:parseInt(t.height(),10),left:parseInt(t.css("left"),10),top:parseInt(t.css("top"),10)})})},resize:function(t,i){var s=e(this).resizable("instance"),n=s.options,a=s.originalSize,o=s.originalPosition,r={height:s.size.height-a.height||0,width:s.size.width-a.width||0,top:s.position.top-o.top||0,left:s.position.left-o.left||0};e(n.alsoResize).each(function(){var t=e(this),s=e(this).data("ui-resizable-alsoresize"),n={},a=t.parents(i.originalElement[0]).length?["width","height"]:["width","height","top","left"];e.each(a,function(e,t){var i=(s[t]||0)+(r[t]||0);i&&i>=0&&(n[t]=i||null)}),t.css(n)})},stop:function(){e(this).removeData("resizable-alsoresize")}}),e.ui.plugin.add("resizable","ghost",{start:function(){var t=e(this).resizable("instance"),i=t.options,s=t.size;t.ghost=t.originalElement.clone(),t.ghost.css({opacity:.25,display:"block",position:"relative",height:s.height,width:s.width,margin:0,left:0,top:0}).addClass("ui-resizable-ghost").addClass("string"==typeof i.ghost?i.ghost:""),t.ghost.appendTo(t.helper)},resize:function(){var t=e(this).resizable("instance");t.ghost&&t.ghost.css({position:"relative",height:t.size.height,width:t.size.width})},stop:function(){var t=e(this).resizable("instance");t.ghost&&t.helper&&t.helper.get(0).removeChild(t.ghost.get(0))}}),e.ui.plugin.add("resizable","grid",{resize:function(){var t,i=e(this).resizable("instance"),s=i.options,n=i.size,a=i.originalSize,o=i.originalPosition,r=i.axis,h="number"==typeof s.grid?[s.grid,s.grid]:s.grid,l=h[0]||1,u=h[1]||1,d=Math.round((n.width-a.width)/l)*l,c=Math.round((n.height-a.height)/u)*u,p=a.width+d,f=a.height+c,m=s.maxWidth&&p>s.maxWidth,g=s.maxHeight&&f>s.maxHeight,v=s.minWidth&&s.minWidth>p,y=s.minHeight&&s.minHeight>f;s.grid=h,v&&(p+=l),y&&(f+=u),m&&(p-=l),g&&(f-=u),/^(se|s|e)$/.test(r)?(i.size.width=p,i.size.height=f):/^(ne)$/.test(r)?(i.size.width=p,i.size.height=f,i.position.top=o.top-c):/^(sw)$/.test(r)?(i.size.width=p,i.size.height=f,i.position.left=o.left-d):((0>=f-u||0>=p-l)&&(t=i._getPaddingPlusBorderDimensions(this)),f-u>0?(i.size.height=f,i.position.top=o.top-c):(f=u-t.height,i.size.height=f,i.position.top=o.top+a.height-f),p-l>0?(i.size.width=p,i.position.left=o.left-d):(p=l-t.width,i.size.width=p,i.position.left=o.left+a.width-p))}}),e.ui.resizable});
},{}],36:[function(require,module,exports){
/**
 * Created by PerArne on 08.05.2015.
 */
//! moment.js
//! version : 2.10.2
//! authors : Tim Wood, Iskren Chernev, Moment.js contributors
//! license : MIT
//! momentjs.com
!function(a,b){"object"==typeof exports&&"undefined"!=typeof module?module.exports=b():"function"==typeof define&&define.amd?define(b):a.moment=b()}(this,function(){"use strict";function a(){return Ac.apply(null,arguments)}function b(a){Ac=a}function c(){return{empty:!1,unusedTokens:[],unusedInput:[],overflow:-2,charsLeftOver:0,nullInput:!1,invalidMonth:null,invalidFormat:!1,userInvalidated:!1,iso:!1}}function d(a){return"[object Array]"===Object.prototype.toString.call(a)}function e(a){return"[object Date]"===Object.prototype.toString.call(a)||a instanceof Date}function f(a,b){var c,d=[];for(c=0;c<a.length;++c)d.push(b(a[c],c));return d}function g(a,b){return Object.prototype.hasOwnProperty.call(a,b)}function h(a,b){for(var c in b)g(b,c)&&(a[c]=b[c]);return g(b,"toString")&&(a.toString=b.toString),g(b,"valueOf")&&(a.valueOf=b.valueOf),a}function i(a,b,c,d){return ya(a,b,c,d,!0).utc()}function j(a){return null==a._isValid&&(a._isValid=!isNaN(a._d.getTime())&&a._pf.overflow<0&&!a._pf.empty&&!a._pf.invalidMonth&&!a._pf.nullInput&&!a._pf.invalidFormat&&!a._pf.userInvalidated,a._strict&&(a._isValid=a._isValid&&0===a._pf.charsLeftOver&&0===a._pf.unusedTokens.length&&void 0===a._pf.bigHour)),a._isValid}function k(a){var b=i(0/0);return null!=a?h(b._pf,a):b._pf.userInvalidated=!0,b}function l(a,b){var c,d,e;if("undefined"!=typeof b._isAMomentObject&&(a._isAMomentObject=b._isAMomentObject),"undefined"!=typeof b._i&&(a._i=b._i),"undefined"!=typeof b._f&&(a._f=b._f),"undefined"!=typeof b._l&&(a._l=b._l),"undefined"!=typeof b._strict&&(a._strict=b._strict),"undefined"!=typeof b._tzm&&(a._tzm=b._tzm),"undefined"!=typeof b._isUTC&&(a._isUTC=b._isUTC),"undefined"!=typeof b._offset&&(a._offset=b._offset),"undefined"!=typeof b._pf&&(a._pf=b._pf),"undefined"!=typeof b._locale&&(a._locale=b._locale),Cc.length>0)for(c in Cc)d=Cc[c],e=b[d],"undefined"!=typeof e&&(a[d]=e);return a}function m(b){l(this,b),this._d=new Date(+b._d),Dc===!1&&(Dc=!0,a.updateOffset(this),Dc=!1)}function n(a){return a instanceof m||null!=a&&g(a,"_isAMomentObject")}function o(a){var b=+a,c=0;return 0!==b&&isFinite(b)&&(c=b>=0?Math.floor(b):Math.ceil(b)),c}function p(a,b,c){var d,e=Math.min(a.length,b.length),f=Math.abs(a.length-b.length),g=0;for(d=0;e>d;d++)(c&&a[d]!==b[d]||!c&&o(a[d])!==o(b[d]))&&g++;return g+f}function q(){}function r(a){return a?a.toLowerCase().replace("_","-"):a}function s(a){for(var b,c,d,e,f=0;f<a.length;){for(e=r(a[f]).split("-"),b=e.length,c=r(a[f+1]),c=c?c.split("-"):null;b>0;){if(d=t(e.slice(0,b).join("-")))return d;if(c&&c.length>=b&&p(e,c,!0)>=b-1)break;b--}f++}return null}function t(a){var b=null;if(!Ec[a]&&"undefined"!=typeof module&&module&&module.exports)try{b=Bc._abbr,require("./locale/"+a),u(b)}catch(c){}return Ec[a]}function u(a,b){var c;return a&&(c="undefined"==typeof b?w(a):v(a,b),c&&(Bc=c)),Bc._abbr}function v(a,b){return null!==b?(b.abbr=a,Ec[a]||(Ec[a]=new q),Ec[a].set(b),u(a),Ec[a]):(delete Ec[a],null)}function w(a){var b;if(a&&a._locale&&a._locale._abbr&&(a=a._locale._abbr),!a)return Bc;if(!d(a)){if(b=t(a))return b;a=[a]}return s(a)}function x(a,b){var c=a.toLowerCase();Fc[c]=Fc[c+"s"]=Fc[b]=a}function y(a){return"string"==typeof a?Fc[a]||Fc[a.toLowerCase()]:void 0}function z(a){var b,c,d={};for(c in a)g(a,c)&&(b=y(c),b&&(d[b]=a[c]));return d}function A(b,c){return function(d){return null!=d?(C(this,b,d),a.updateOffset(this,c),this):B(this,b)}}function B(a,b){return a._d["get"+(a._isUTC?"UTC":"")+b]()}function C(a,b,c){return a._d["set"+(a._isUTC?"UTC":"")+b](c)}function D(a,b){var c;if("object"==typeof a)for(c in a)this.set(c,a[c]);else if(a=y(a),"function"==typeof this[a])return this[a](b);return this}function E(a,b,c){for(var d=""+Math.abs(a),e=a>=0;d.length<b;)d="0"+d;return(e?c?"+":"":"-")+d}function F(a,b,c,d){var e=d;"string"==typeof d&&(e=function(){return this[d]()}),a&&(Jc[a]=e),b&&(Jc[b[0]]=function(){return E(e.apply(this,arguments),b[1],b[2])}),c&&(Jc[c]=function(){return this.localeData().ordinal(e.apply(this,arguments),a)})}function G(a){return a.match(/\[[\s\S]/)?a.replace(/^\[|\]$/g,""):a.replace(/\\/g,"")}function H(a){var b,c,d=a.match(Gc);for(b=0,c=d.length;c>b;b++)d[b]=Jc[d[b]]?Jc[d[b]]:G(d[b]);return function(e){var f="";for(b=0;c>b;b++)f+=d[b]instanceof Function?d[b].call(e,a):d[b];return f}}function I(a,b){return a.isValid()?(b=J(b,a.localeData()),Ic[b]||(Ic[b]=H(b)),Ic[b](a)):a.localeData().invalidDate()}function J(a,b){function c(a){return b.longDateFormat(a)||a}var d=5;for(Hc.lastIndex=0;d>=0&&Hc.test(a);)a=a.replace(Hc,c),Hc.lastIndex=0,d-=1;return a}function K(a,b,c){Yc[a]="function"==typeof b?b:function(a){return a&&c?c:b}}function L(a,b){return g(Yc,a)?Yc[a](b._strict,b._locale):new RegExp(M(a))}function M(a){return a.replace("\\","").replace(/\\(\[)|\\(\])|\[([^\]\[]*)\]|\\(.)/g,function(a,b,c,d,e){return b||c||d||e}).replace(/[-\/\\^$*+?.()|[\]{}]/g,"\\$&")}function N(a,b){var c,d=b;for("string"==typeof a&&(a=[a]),"number"==typeof b&&(d=function(a,c){c[b]=o(a)}),c=0;c<a.length;c++)Zc[a[c]]=d}function O(a,b){N(a,function(a,c,d,e){d._w=d._w||{},b(a,d._w,d,e)})}function P(a,b,c){null!=b&&g(Zc,a)&&Zc[a](b,c._a,c,a)}function Q(a,b){return new Date(Date.UTC(a,b+1,0)).getUTCDate()}function R(a){return this._months[a.month()]}function S(a){return this._monthsShort[a.month()]}function T(a,b,c){var d,e,f;for(this._monthsParse||(this._monthsParse=[],this._longMonthsParse=[],this._shortMonthsParse=[]),d=0;12>d;d++){if(e=i([2e3,d]),c&&!this._longMonthsParse[d]&&(this._longMonthsParse[d]=new RegExp("^"+this.months(e,"").replace(".","")+"$","i"),this._shortMonthsParse[d]=new RegExp("^"+this.monthsShort(e,"").replace(".","")+"$","i")),c||this._monthsParse[d]||(f="^"+this.months(e,"")+"|^"+this.monthsShort(e,""),this._monthsParse[d]=new RegExp(f.replace(".",""),"i")),c&&"MMMM"===b&&this._longMonthsParse[d].test(a))return d;if(c&&"MMM"===b&&this._shortMonthsParse[d].test(a))return d;if(!c&&this._monthsParse[d].test(a))return d}}function U(a,b){var c;return"string"==typeof b&&(b=a.localeData().monthsParse(b),"number"!=typeof b)?a:(c=Math.min(a.date(),Q(a.year(),b)),a._d["set"+(a._isUTC?"UTC":"")+"Month"](b,c),a)}function V(b){return null!=b?(U(this,b),a.updateOffset(this,!0),this):B(this,"Month")}function W(){return Q(this.year(),this.month())}function X(a){var b,c=a._a;return c&&-2===a._pf.overflow&&(b=c[_c]<0||c[_c]>11?_c:c[ad]<1||c[ad]>Q(c[$c],c[_c])?ad:c[bd]<0||c[bd]>24||24===c[bd]&&(0!==c[cd]||0!==c[dd]||0!==c[ed])?bd:c[cd]<0||c[cd]>59?cd:c[dd]<0||c[dd]>59?dd:c[ed]<0||c[ed]>999?ed:-1,a._pf._overflowDayOfYear&&($c>b||b>ad)&&(b=ad),a._pf.overflow=b),a}function Y(b){a.suppressDeprecationWarnings===!1&&"undefined"!=typeof console&&console.warn&&console.warn("Deprecation warning: "+b)}function Z(a,b){var c=!0;return h(function(){return c&&(Y(a),c=!1),b.apply(this,arguments)},b)}function $(a,b){hd[a]||(Y(b),hd[a]=!0)}function _(a){var b,c,d=a._i,e=id.exec(d);if(e){for(a._pf.iso=!0,b=0,c=jd.length;c>b;b++)if(jd[b][1].exec(d)){a._f=jd[b][0]+(e[6]||" ");break}for(b=0,c=kd.length;c>b;b++)if(kd[b][1].exec(d)){a._f+=kd[b][0];break}d.match(Vc)&&(a._f+="Z"),sa(a)}else a._isValid=!1}function aa(b){var c=ld.exec(b._i);return null!==c?void(b._d=new Date(+c[1])):(_(b),void(b._isValid===!1&&(delete b._isValid,a.createFromInputFallback(b))))}function ba(a,b,c,d,e,f,g){var h=new Date(a,b,c,d,e,f,g);return 1970>a&&h.setFullYear(a),h}function ca(a){var b=new Date(Date.UTC.apply(null,arguments));return 1970>a&&b.setUTCFullYear(a),b}function da(a){return ea(a)?366:365}function ea(a){return a%4===0&&a%100!==0||a%400===0}function fa(){return ea(this.year())}function ga(a,b,c){var d,e=c-b,f=c-a.day();return f>e&&(f-=7),e-7>f&&(f+=7),d=za(a).add(f,"d"),{week:Math.ceil(d.dayOfYear()/7),year:d.year()}}function ha(a){return ga(a,this._week.dow,this._week.doy).week}function ia(){return this._week.dow}function ja(){return this._week.doy}function ka(a){var b=this.localeData().week(this);return null==a?b:this.add(7*(a-b),"d")}function la(a){var b=ga(this,1,4).week;return null==a?b:this.add(7*(a-b),"d")}function ma(a,b,c,d,e){var f,g,h=ca(a,0,1).getUTCDay();return h=0===h?7:h,c=null!=c?c:e,f=e-h+(h>d?7:0)-(e>h?7:0),g=7*(b-1)+(c-e)+f+1,{year:g>0?a:a-1,dayOfYear:g>0?g:da(a-1)+g}}function na(a){var b=Math.round((this.clone().startOf("day")-this.clone().startOf("year"))/864e5)+1;return null==a?b:this.add(a-b,"d")}function oa(a,b,c){return null!=a?a:null!=b?b:c}function pa(a){var b=new Date;return a._useUTC?[b.getUTCFullYear(),b.getUTCMonth(),b.getUTCDate()]:[b.getFullYear(),b.getMonth(),b.getDate()]}function qa(a){var b,c,d,e,f=[];if(!a._d){for(d=pa(a),a._w&&null==a._a[ad]&&null==a._a[_c]&&ra(a),a._dayOfYear&&(e=oa(a._a[$c],d[$c]),a._dayOfYear>da(e)&&(a._pf._overflowDayOfYear=!0),c=ca(e,0,a._dayOfYear),a._a[_c]=c.getUTCMonth(),a._a[ad]=c.getUTCDate()),b=0;3>b&&null==a._a[b];++b)a._a[b]=f[b]=d[b];for(;7>b;b++)a._a[b]=f[b]=null==a._a[b]?2===b?1:0:a._a[b];24===a._a[bd]&&0===a._a[cd]&&0===a._a[dd]&&0===a._a[ed]&&(a._nextDay=!0,a._a[bd]=0),a._d=(a._useUTC?ca:ba).apply(null,f),null!=a._tzm&&a._d.setUTCMinutes(a._d.getUTCMinutes()-a._tzm),a._nextDay&&(a._a[bd]=24)}}function ra(a){var b,c,d,e,f,g,h;b=a._w,null!=b.GG||null!=b.W||null!=b.E?(f=1,g=4,c=oa(b.GG,a._a[$c],ga(za(),1,4).year),d=oa(b.W,1),e=oa(b.E,1)):(f=a._locale._week.dow,g=a._locale._week.doy,c=oa(b.gg,a._a[$c],ga(za(),f,g).year),d=oa(b.w,1),null!=b.d?(e=b.d,f>e&&++d):e=null!=b.e?b.e+f:f),h=ma(c,d,e,g,f),a._a[$c]=h.year,a._dayOfYear=h.dayOfYear}function sa(b){if(b._f===a.ISO_8601)return void _(b);b._a=[],b._pf.empty=!0;var c,d,e,f,g,h=""+b._i,i=h.length,j=0;for(e=J(b._f,b._locale).match(Gc)||[],c=0;c<e.length;c++)f=e[c],d=(h.match(L(f,b))||[])[0],d&&(g=h.substr(0,h.indexOf(d)),g.length>0&&b._pf.unusedInput.push(g),h=h.slice(h.indexOf(d)+d.length),j+=d.length),Jc[f]?(d?b._pf.empty=!1:b._pf.unusedTokens.push(f),P(f,d,b)):b._strict&&!d&&b._pf.unusedTokens.push(f);b._pf.charsLeftOver=i-j,h.length>0&&b._pf.unusedInput.push(h),b._pf.bigHour===!0&&b._a[bd]<=12&&(b._pf.bigHour=void 0),b._a[bd]=ta(b._locale,b._a[bd],b._meridiem),qa(b),X(b)}function ta(a,b,c){var d;return null==c?b:null!=a.meridiemHour?a.meridiemHour(b,c):null!=a.isPM?(d=a.isPM(c),d&&12>b&&(b+=12),d||12!==b||(b=0),b):b}function ua(a){var b,d,e,f,g;if(0===a._f.length)return a._pf.invalidFormat=!0,void(a._d=new Date(0/0));for(f=0;f<a._f.length;f++)g=0,b=l({},a),null!=a._useUTC&&(b._useUTC=a._useUTC),b._pf=c(),b._f=a._f[f],sa(b),j(b)&&(g+=b._pf.charsLeftOver,g+=10*b._pf.unusedTokens.length,b._pf.score=g,(null==e||e>g)&&(e=g,d=b));h(a,d||b)}function va(a){if(!a._d){var b=z(a._i);a._a=[b.year,b.month,b.day||b.date,b.hour,b.minute,b.second,b.millisecond],qa(a)}}function wa(a){var b,c=a._i,e=a._f;return a._locale=a._locale||w(a._l),null===c||void 0===e&&""===c?k({nullInput:!0}):("string"==typeof c&&(a._i=c=a._locale.preparse(c)),n(c)?new m(X(c)):(d(e)?ua(a):e?sa(a):xa(a),b=new m(X(a)),b._nextDay&&(b.add(1,"d"),b._nextDay=void 0),b))}function xa(b){var c=b._i;void 0===c?b._d=new Date:e(c)?b._d=new Date(+c):"string"==typeof c?aa(b):d(c)?(b._a=f(c.slice(0),function(a){return parseInt(a,10)}),qa(b)):"object"==typeof c?va(b):"number"==typeof c?b._d=new Date(c):a.createFromInputFallback(b)}function ya(a,b,d,e,f){var g={};return"boolean"==typeof d&&(e=d,d=void 0),g._isAMomentObject=!0,g._useUTC=g._isUTC=f,g._l=d,g._i=a,g._f=b,g._strict=e,g._pf=c(),wa(g)}function za(a,b,c,d){return ya(a,b,c,d,!1)}function Aa(a,b){var c,e;if(1===b.length&&d(b[0])&&(b=b[0]),!b.length)return za();for(c=b[0],e=1;e<b.length;++e)b[e][a](c)&&(c=b[e]);return c}function Ba(){var a=[].slice.call(arguments,0);return Aa("isBefore",a)}function Ca(){var a=[].slice.call(arguments,0);return Aa("isAfter",a)}function Da(a){var b=z(a),c=b.year||0,d=b.quarter||0,e=b.month||0,f=b.week||0,g=b.day||0,h=b.hour||0,i=b.minute||0,j=b.second||0,k=b.millisecond||0;this._milliseconds=+k+1e3*j+6e4*i+36e5*h,this._days=+g+7*f,this._months=+e+3*d+12*c,this._data={},this._locale=w(),this._bubble()}function Ea(a){return a instanceof Da}function Fa(a,b){F(a,0,0,function(){var a=this.utcOffset(),c="+";return 0>a&&(a=-a,c="-"),c+E(~~(a/60),2)+b+E(~~a%60,2)})}function Ga(a){var b=(a||"").match(Vc)||[],c=b[b.length-1]||[],d=(c+"").match(qd)||["-",0,0],e=+(60*d[1])+o(d[2]);return"+"===d[0]?e:-e}function Ha(b,c){var d,f;return c._isUTC?(d=c.clone(),f=(n(b)||e(b)?+b:+za(b))-+d,d._d.setTime(+d._d+f),a.updateOffset(d,!1),d):za(b).local();return c._isUTC?za(b).zone(c._offset||0):za(b).local()}function Ia(a){return 15*-Math.round(a._d.getTimezoneOffset()/15)}function Ja(b,c){var d,e=this._offset||0;return null!=b?("string"==typeof b&&(b=Ga(b)),Math.abs(b)<16&&(b=60*b),!this._isUTC&&c&&(d=Ia(this)),this._offset=b,this._isUTC=!0,null!=d&&this.add(d,"m"),e!==b&&(!c||this._changeInProgress?Za(this,Ua(b-e,"m"),1,!1):this._changeInProgress||(this._changeInProgress=!0,a.updateOffset(this,!0),this._changeInProgress=null)),this):this._isUTC?e:Ia(this)}function Ka(a,b){return null!=a?("string"!=typeof a&&(a=-a),this.utcOffset(a,b),this):-this.utcOffset()}function La(a){return this.utcOffset(0,a)}function Ma(a){return this._isUTC&&(this.utcOffset(0,a),this._isUTC=!1,a&&this.subtract(Ia(this),"m")),this}function Na(){return this._tzm?this.utcOffset(this._tzm):"string"==typeof this._i&&this.utcOffset(Ga(this._i)),this}function Oa(a){return a=a?za(a).utcOffset():0,(this.utcOffset()-a)%60===0}function Pa(){return this.utcOffset()>this.clone().month(0).utcOffset()||this.utcOffset()>this.clone().month(5).utcOffset()}function Qa(){if(this._a){var a=this._isUTC?i(this._a):za(this._a);return this.isValid()&&p(this._a,a.toArray())>0}return!1}function Ra(){return!this._isUTC}function Sa(){return this._isUTC}function Ta(){return this._isUTC&&0===this._offset}function Ua(a,b){var c,d,e,f=a,h=null;return Ea(a)?f={ms:a._milliseconds,d:a._days,M:a._months}:"number"==typeof a?(f={},b?f[b]=a:f.milliseconds=a):(h=rd.exec(a))?(c="-"===h[1]?-1:1,f={y:0,d:o(h[ad])*c,h:o(h[bd])*c,m:o(h[cd])*c,s:o(h[dd])*c,ms:o(h[ed])*c}):(h=sd.exec(a))?(c="-"===h[1]?-1:1,f={y:Va(h[2],c),M:Va(h[3],c),d:Va(h[4],c),h:Va(h[5],c),m:Va(h[6],c),s:Va(h[7],c),w:Va(h[8],c)}):null==f?f={}:"object"==typeof f&&("from"in f||"to"in f)&&(e=Xa(za(f.from),za(f.to)),f={},f.ms=e.milliseconds,f.M=e.months),d=new Da(f),Ea(a)&&g(a,"_locale")&&(d._locale=a._locale),d}function Va(a,b){var c=a&&parseFloat(a.replace(",","."));return(isNaN(c)?0:c)*b}function Wa(a,b){var c={milliseconds:0,months:0};return c.months=b.month()-a.month()+12*(b.year()-a.year()),a.clone().add(c.months,"M").isAfter(b)&&--c.months,c.milliseconds=+b-+a.clone().add(c.months,"M"),c}function Xa(a,b){var c;return b=Ha(b,a),a.isBefore(b)?c=Wa(a,b):(c=Wa(b,a),c.milliseconds=-c.milliseconds,c.months=-c.months),c}function Ya(a,b){return function(c,d){var e,f;return null===d||isNaN(+d)||($(b,"moment()."+b+"(period, number) is deprecated. Please use moment()."+b+"(number, period)."),f=c,c=d,d=f),c="string"==typeof c?+c:c,e=Ua(c,d),Za(this,e,a),this}}function Za(b,c,d,e){var f=c._milliseconds,g=c._days,h=c._months;e=null==e?!0:e,f&&b._d.setTime(+b._d+f*d),g&&C(b,"Date",B(b,"Date")+g*d),h&&U(b,B(b,"Month")+h*d),e&&a.updateOffset(b,g||h)}function $a(a){var b=a||za(),c=Ha(b,this).startOf("day"),d=this.diff(c,"days",!0),e=-6>d?"sameElse":-1>d?"lastWeek":0>d?"lastDay":1>d?"sameDay":2>d?"nextDay":7>d?"nextWeek":"sameElse";return this.format(this.localeData().calendar(e,this,za(b)))}function _a(){return new m(this)}function ab(a,b){var c;return b=y("undefined"!=typeof b?b:"millisecond"),"millisecond"===b?(a=n(a)?a:za(a),+this>+a):(c=n(a)?+a:+za(a),c<+this.clone().startOf(b))}function bb(a,b){var c;return b=y("undefined"!=typeof b?b:"millisecond"),"millisecond"===b?(a=n(a)?a:za(a),+a>+this):(c=n(a)?+a:+za(a),+this.clone().endOf(b)<c)}function cb(a,b,c){return this.isAfter(a,c)&&this.isBefore(b,c)}function db(a,b){var c;return b=y(b||"millisecond"),"millisecond"===b?(a=n(a)?a:za(a),+this===+a):(c=+za(a),+this.clone().startOf(b)<=c&&c<=+this.clone().endOf(b))}function eb(a){return 0>a?Math.ceil(a):Math.floor(a)}function fb(a,b,c){var d,e,f=Ha(a,this),g=6e4*(f.utcOffset()-this.utcOffset());return b=y(b),"year"===b||"month"===b||"quarter"===b?(e=gb(this,f),"quarter"===b?e/=3:"year"===b&&(e/=12)):(d=this-f,e="second"===b?d/1e3:"minute"===b?d/6e4:"hour"===b?d/36e5:"day"===b?(d-g)/864e5:"week"===b?(d-g)/6048e5:d),c?e:eb(e)}function gb(a,b){var c,d,e=12*(b.year()-a.year())+(b.month()-a.month()),f=a.clone().add(e,"months");return 0>b-f?(c=a.clone().add(e-1,"months"),d=(b-f)/(f-c)):(c=a.clone().add(e+1,"months"),d=(b-f)/(c-f)),-(e+d)}function hb(){return this.clone().locale("en").format("ddd MMM DD YYYY HH:mm:ss [GMT]ZZ")}function ib(){var a=this.clone().utc();return 0<a.year()&&a.year()<=9999?"function"==typeof Date.prototype.toISOString?this.toDate().toISOString():I(a,"YYYY-MM-DD[T]HH:mm:ss.SSS[Z]"):I(a,"YYYYYY-MM-DD[T]HH:mm:ss.SSS[Z]")}function jb(b){var c=I(this,b||a.defaultFormat);return this.localeData().postformat(c)}function kb(a,b){return Ua({to:this,from:a}).locale(this.locale()).humanize(!b)}function lb(a){return this.from(za(),a)}function mb(a){var b;return void 0===a?this._locale._abbr:(b=w(a),null!=b&&(this._locale=b),this)}function nb(){return this._locale}function ob(a){switch(a=y(a)){case"year":this.month(0);case"quarter":case"month":this.date(1);case"week":case"isoWeek":case"day":this.hours(0);case"hour":this.minutes(0);case"minute":this.seconds(0);case"second":this.milliseconds(0)}return"week"===a&&this.weekday(0),"isoWeek"===a&&this.isoWeekday(1),"quarter"===a&&this.month(3*Math.floor(this.month()/3)),this}function pb(a){return a=y(a),void 0===a||"millisecond"===a?this:this.startOf(a).add(1,"isoWeek"===a?"week":a).subtract(1,"ms")}function qb(){return+this._d-6e4*(this._offset||0)}function rb(){return Math.floor(+this/1e3)}function sb(){return this._offset?new Date(+this):this._d}function tb(){var a=this;return[a.year(),a.month(),a.date(),a.hour(),a.minute(),a.second(),a.millisecond()]}function ub(){return j(this)}function vb(){return h({},this._pf)}function wb(){return this._pf.overflow}function xb(a,b){F(0,[a,a.length],0,b)}function yb(a,b,c){return ga(za([a,11,31+b-c]),b,c).week}function zb(a){var b=ga(this,this.localeData()._week.dow,this.localeData()._week.doy).year;return null==a?b:this.add(a-b,"y")}function Ab(a){var b=ga(this,1,4).year;return null==a?b:this.add(a-b,"y")}function Bb(){return yb(this.year(),1,4)}function Cb(){var a=this.localeData()._week;return yb(this.year(),a.dow,a.doy)}function Db(a){return null==a?Math.ceil((this.month()+1)/3):this.month(3*(a-1)+this.month()%3)}function Eb(a,b){if("string"==typeof a)if(isNaN(a)){if(a=b.weekdaysParse(a),"number"!=typeof a)return null}else a=parseInt(a,10);return a}function Fb(a){return this._weekdays[a.day()]}function Gb(a){return this._weekdaysShort[a.day()]}function Hb(a){return this._weekdaysMin[a.day()]}function Ib(a){var b,c,d;for(this._weekdaysParse||(this._weekdaysParse=[]),b=0;7>b;b++)if(this._weekdaysParse[b]||(c=za([2e3,1]).day(b),d="^"+this.weekdays(c,"")+"|^"+this.weekdaysShort(c,"")+"|^"+this.weekdaysMin(c,""),this._weekdaysParse[b]=new RegExp(d.replace(".",""),"i")),this._weekdaysParse[b].test(a))return b}function Jb(a){var b=this._isUTC?this._d.getUTCDay():this._d.getDay();return null!=a?(a=Eb(a,this.localeData()),this.add(a-b,"d")):b}function Kb(a){var b=(this.day()+7-this.localeData()._week.dow)%7;return null==a?b:this.add(a-b,"d")}function Lb(a){return null==a?this.day()||7:this.day(this.day()%7?a:a-7)}function Mb(a,b){F(a,0,0,function(){return this.localeData().meridiem(this.hours(),this.minutes(),b)})}function Nb(a,b){return b._meridiemParse}function Ob(a){return"p"===(a+"").toLowerCase().charAt(0)}function Pb(a,b,c){return a>11?c?"pm":"PM":c?"am":"AM"}function Qb(a){F(0,[a,3],0,"millisecond")}function Rb(){return this._isUTC?"UTC":""}function Sb(){return this._isUTC?"Coordinated Universal Time":""}function Tb(a){return za(1e3*a)}function Ub(){return za.apply(null,arguments).parseZone()}function Vb(a,b,c){var d=this._calendar[a];return"function"==typeof d?d.call(b,c):d}function Wb(a){var b=this._longDateFormat[a];return!b&&this._longDateFormat[a.toUpperCase()]&&(b=this._longDateFormat[a.toUpperCase()].replace(/MMMM|MM|DD|dddd/g,function(a){return a.slice(1)}),this._longDateFormat[a]=b),b}function Xb(){return this._invalidDate}function Yb(a){return this._ordinal.replace("%d",a)}function Zb(a){return a}function $b(a,b,c,d){var e=this._relativeTime[c];return"function"==typeof e?e(a,b,c,d):e.replace(/%d/i,a)}function _b(a,b){var c=this._relativeTime[a>0?"future":"past"];return"function"==typeof c?c(b):c.replace(/%s/i,b)}function ac(a){var b,c;for(c in a)b=a[c],"function"==typeof b?this[c]=b:this["_"+c]=b;this._ordinalParseLenient=new RegExp(this._ordinalParse.source+"|"+/\d{1,2}/.source)}function bc(a,b,c,d){var e=w(),f=i().set(d,b);return e[c](f,a)}function cc(a,b,c,d,e){if("number"==typeof a&&(b=a,a=void 0),a=a||"",null!=b)return bc(a,b,c,e);var f,g=[];for(f=0;d>f;f++)g[f]=bc(a,f,c,e);return g}function dc(a,b){return cc(a,b,"months",12,"month")}function ec(a,b){return cc(a,b,"monthsShort",12,"month")}function fc(a,b){return cc(a,b,"weekdays",7,"day")}function gc(a,b){return cc(a,b,"weekdaysShort",7,"day")}function hc(a,b){return cc(a,b,"weekdaysMin",7,"day")}function ic(){var a=this._data;return this._milliseconds=Od(this._milliseconds),this._days=Od(this._days),this._months=Od(this._months),a.milliseconds=Od(a.milliseconds),a.seconds=Od(a.seconds),a.minutes=Od(a.minutes),a.hours=Od(a.hours),a.months=Od(a.months),a.years=Od(a.years),this}function jc(a,b,c,d){var e=Ua(b,c);return a._milliseconds+=d*e._milliseconds,a._days+=d*e._days,a._months+=d*e._months,a._bubble()}function kc(a,b){return jc(this,a,b,1)}function lc(a,b){return jc(this,a,b,-1)}function mc(){var a,b,c,d=this._milliseconds,e=this._days,f=this._months,g=this._data,h=0;return g.milliseconds=d%1e3,a=eb(d/1e3),g.seconds=a%60,b=eb(a/60),g.minutes=b%60,c=eb(b/60),g.hours=c%24,e+=eb(c/24),h=eb(nc(e)),e-=eb(oc(h)),f+=eb(e/30),e%=30,h+=eb(f/12),f%=12,g.days=e,g.months=f,g.years=h,this}function nc(a){return 400*a/146097}function oc(a){return 146097*a/400}function pc(a){var b,c,d=this._milliseconds;if(a=y(a),"month"===a||"year"===a)return b=this._days+d/864e5,c=this._months+12*nc(b),"month"===a?c:c/12;switch(b=this._days+Math.round(oc(this._months/12)),a){case"week":return b/7+d/6048e5;case"day":return b+d/864e5;case"hour":return 24*b+d/36e5;case"minute":return 24*b*60+d/6e4;case"second":return 24*b*60*60+d/1e3;case"millisecond":return Math.floor(24*b*60*60*1e3)+d;default:throw new Error("Unknown unit "+a)}}function qc(){return this._milliseconds+864e5*this._days+this._months%12*2592e6+31536e6*o(this._months/12)}function rc(a){return function(){return this.as(a)}}function sc(a){return a=y(a),this[a+"s"]()}function tc(a){return function(){return this._data[a]}}function uc(){return eb(this.days()/7)}function vc(a,b,c,d,e){return e.relativeTime(b||1,!!c,a,d)}function wc(a,b,c){var d=Ua(a).abs(),e=ce(d.as("s")),f=ce(d.as("m")),g=ce(d.as("h")),h=ce(d.as("d")),i=ce(d.as("M")),j=ce(d.as("y")),k=e<de.s&&["s",e]||1===f&&["m"]||f<de.m&&["mm",f]||1===g&&["h"]||g<de.h&&["hh",g]||1===h&&["d"]||h<de.d&&["dd",h]||1===i&&["M"]||i<de.M&&["MM",i]||1===j&&["y"]||["yy",j];return k[2]=b,k[3]=+a>0,k[4]=c,vc.apply(null,k)}function xc(a,b){return void 0===de[a]?!1:void 0===b?de[a]:(de[a]=b,!0)}function yc(a){var b=this.localeData(),c=wc(this,!a,b);return a&&(c=b.pastFuture(+this,c)),b.postformat(c)}function zc(){var a=ee(this.years()),b=ee(this.months()),c=ee(this.days()),d=ee(this.hours()),e=ee(this.minutes()),f=ee(this.seconds()+this.milliseconds()/1e3),g=this.asSeconds();return g?(0>g?"-":"")+"P"+(a?a+"Y":"")+(b?b+"M":"")+(c?c+"D":"")+(d||e||f?"T":"")+(d?d+"H":"")+(e?e+"M":"")+(f?f+"S":""):"P0D"}var Ac,Bc,Cc=a.momentProperties=[],Dc=!1,Ec={},Fc={},Gc=/(\[[^\[]*\])|(\\)?(Mo|MM?M?M?|Do|DDDo|DD?D?D?|ddd?d?|do?|w[o|w]?|W[o|W]?|Q|YYYYYY|YYYYY|YYYY|YY|gg(ggg?)?|GG(GGG?)?|e|E|a|A|hh?|HH?|mm?|ss?|S{1,4}|x|X|zz?|ZZ?|.)/g,Hc=/(\[[^\[]*\])|(\\)?(LTS|LT|LL?L?L?|l{1,4})/g,Ic={},Jc={},Kc=/\d/,Lc=/\d\d/,Mc=/\d{3}/,Nc=/\d{4}/,Oc=/[+-]?\d{6}/,Pc=/\d\d?/,Qc=/\d{1,3}/,Rc=/\d{1,4}/,Sc=/[+-]?\d{1,6}/,Tc=/\d+/,Uc=/[+-]?\d+/,Vc=/Z|[+-]\d\d:?\d\d/gi,Wc=/[+-]?\d+(\.\d{1,3})?/,Xc=/[0-9]*['a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF\/]+(\s*?[\u0600-\u06FF]+){1,2}/i,Yc={},Zc={},$c=0,_c=1,ad=2,bd=3,cd=4,dd=5,ed=6;F("M",["MM",2],"Mo",function(){return this.month()+1}),F("MMM",0,0,function(a){return this.localeData().monthsShort(this,a)}),F("MMMM",0,0,function(a){return this.localeData().months(this,a)}),x("month","M"),K("M",Pc),K("MM",Pc,Lc),K("MMM",Xc),K("MMMM",Xc),N(["M","MM"],function(a,b){b[_c]=o(a)-1}),N(["MMM","MMMM"],function(a,b,c,d){var e=c._locale.monthsParse(a,d,c._strict);null!=e?b[_c]=e:c._pf.invalidMonth=a});var fd="January_February_March_April_May_June_July_August_September_October_November_December".split("_"),gd="Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),hd={};a.suppressDeprecationWarnings=!1;var id=/^\s*(?:[+-]\d{6}|\d{4})-(?:(\d\d-\d\d)|(W\d\d$)|(W\d\d-\d)|(\d\d\d))((T| )(\d\d(:\d\d(:\d\d(\.\d+)?)?)?)?([\+\-]\d\d(?::?\d\d)?|\s*Z)?)?$/,jd=[["YYYYYY-MM-DD",/[+-]\d{6}-\d{2}-\d{2}/],["YYYY-MM-DD",/\d{4}-\d{2}-\d{2}/],["GGGG-[W]WW-E",/\d{4}-W\d{2}-\d/],["GGGG-[W]WW",/\d{4}-W\d{2}/],["YYYY-DDD",/\d{4}-\d{3}/]],kd=[["HH:mm:ss.SSSS",/(T| )\d\d:\d\d:\d\d\.\d+/],["HH:mm:ss",/(T| )\d\d:\d\d:\d\d/],["HH:mm",/(T| )\d\d:\d\d/],["HH",/(T| )\d\d/]],ld=/^\/?Date\((\-?\d+)/i;a.createFromInputFallback=Z("moment construction falls back to js Date. This is discouraged and will be removed in upcoming major release. Please refer to https://github.com/moment/moment/issues/1407 for more info.",function(a){a._d=new Date(a._i+(a._useUTC?" UTC":""))}),F(0,["YY",2],0,function(){return this.year()%100}),F(0,["YYYY",4],0,"year"),F(0,["YYYYY",5],0,"year"),F(0,["YYYYYY",6,!0],0,"year"),x("year","y"),K("Y",Uc),K("YY",Pc,Lc),K("YYYY",Rc,Nc),K("YYYYY",Sc,Oc),K("YYYYYY",Sc,Oc),N(["YYYY","YYYYY","YYYYYY"],$c),N("YY",function(b,c){c[$c]=a.parseTwoDigitYear(b)}),a.parseTwoDigitYear=function(a){return o(a)+(o(a)>68?1900:2e3)};var md=A("FullYear",!1);F("w",["ww",2],"wo","week"),F("W",["WW",2],"Wo","isoWeek"),x("week","w"),x("isoWeek","W"),K("w",Pc),K("ww",Pc,Lc),K("W",Pc),K("WW",Pc,Lc),O(["w","ww","W","WW"],function(a,b,c,d){b[d.substr(0,1)]=o(a)});var nd={dow:0,doy:6};F("DDD",["DDDD",3],"DDDo","dayOfYear"),x("dayOfYear","DDD"),K("DDD",Qc),K("DDDD",Mc),N(["DDD","DDDD"],function(a,b,c){c._dayOfYear=o(a)}),a.ISO_8601=function(){};var od=Z("moment().min is deprecated, use moment.min instead. https://github.com/moment/moment/issues/1548",function(){var a=za.apply(null,arguments);return this>a?this:a}),pd=Z("moment().max is deprecated, use moment.max instead. https://github.com/moment/moment/issues/1548",function(){var a=za.apply(null,arguments);return a>this?this:a});Fa("Z",":"),Fa("ZZ",""),K("Z",Vc),K("ZZ",Vc),N(["Z","ZZ"],function(a,b,c){c._useUTC=!0,c._tzm=Ga(a)});var qd=/([\+\-]|\d\d)/gi;a.updateOffset=function(){};var rd=/(\-)?(?:(\d*)\.)?(\d+)\:(\d+)(?:\:(\d+)\.?(\d{3})?)?/,sd=/^(-)?P(?:(?:([0-9,.]*)Y)?(?:([0-9,.]*)M)?(?:([0-9,.]*)D)?(?:T(?:([0-9,.]*)H)?(?:([0-9,.]*)M)?(?:([0-9,.]*)S)?)?|([0-9,.]*)W)$/;Ua.fn=Da.prototype;var td=Ya(1,"add"),ud=Ya(-1,"subtract");a.defaultFormat="YYYY-MM-DDTHH:mm:ssZ";var vd=Z("moment().lang() is deprecated. Instead, use moment().localeData() to get the language configuration. Use moment().locale() to change languages.",function(a){return void 0===a?this.localeData():this.locale(a)});F(0,["gg",2],0,function(){return this.weekYear()%100}),F(0,["GG",2],0,function(){return this.isoWeekYear()%100}),xb("gggg","weekYear"),xb("ggggg","weekYear"),xb("GGGG","isoWeekYear"),xb("GGGGG","isoWeekYear"),x("weekYear","gg"),x("isoWeekYear","GG"),K("G",Uc),K("g",Uc),K("GG",Pc,Lc),K("gg",Pc,Lc),K("GGGG",Rc,Nc),K("gggg",Rc,Nc),K("GGGGG",Sc,Oc),K("ggggg",Sc,Oc),O(["gggg","ggggg","GGGG","GGGGG"],function(a,b,c,d){b[d.substr(0,2)]=o(a)}),O(["gg","GG"],function(b,c,d,e){c[e]=a.parseTwoDigitYear(b)}),F("Q",0,0,"quarter"),x("quarter","Q"),K("Q",Kc),N("Q",function(a,b){b[_c]=3*(o(a)-1)}),F("D",["DD",2],"Do","date"),x("date","D"),K("D",Pc),K("DD",Pc,Lc),K("Do",function(a,b){return a?b._ordinalParse:b._ordinalParseLenient}),N(["D","DD"],ad),N("Do",function(a,b){b[ad]=o(a.match(Pc)[0],10)});var wd=A("Date",!0);F("d",0,"do","day"),F("dd",0,0,function(a){return this.localeData().weekdaysMin(this,a)}),F("ddd",0,0,function(a){return this.localeData().weekdaysShort(this,a)}),F("dddd",0,0,function(a){return this.localeData().weekdays(this,a)}),F("e",0,0,"weekday"),F("E",0,0,"isoWeekday"),x("day","d"),x("weekday","e"),x("isoWeekday","E"),K("d",Pc),K("e",Pc),K("E",Pc),K("dd",Xc),K("ddd",Xc),K("dddd",Xc),O(["dd","ddd","dddd"],function(a,b,c){var d=c._locale.weekdaysParse(a);null!=d?b.d=d:c._pf.invalidWeekday=a}),O(["d","e","E"],function(a,b,c,d){b[d]=o(a)});var xd="Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),yd="Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),zd="Su_Mo_Tu_We_Th_Fr_Sa".split("_");F("H",["HH",2],0,"hour"),F("h",["hh",2],0,function(){return this.hours()%12||12}),Mb("a",!0),Mb("A",!1),x("hour","h"),K("a",Nb),K("A",Nb),K("H",Pc),K("h",Pc),K("HH",Pc,Lc),K("hh",Pc,Lc),N(["H","HH"],bd),N(["a","A"],function(a,b,c){c._isPm=c._locale.isPM(a),c._meridiem=a}),N(["h","hh"],function(a,b,c){b[bd]=o(a),c._pf.bigHour=!0});var Ad=/[ap]\.?m?\.?/i,Bd=A("Hours",!0);F("m",["mm",2],0,"minute"),x("minute","m"),K("m",Pc),K("mm",Pc,Lc),N(["m","mm"],cd);var Cd=A("Minutes",!1);F("s",["ss",2],0,"second"),x("second","s"),K("s",Pc),K("ss",Pc,Lc),N(["s","ss"],dd);var Dd=A("Seconds",!1);F("S",0,0,function(){return~~(this.millisecond()/100)}),F(0,["SS",2],0,function(){return~~(this.millisecond()/10)}),Qb("SSS"),Qb("SSSS"),x("millisecond","ms"),K("S",Qc,Kc),K("SS",Qc,Lc),K("SSS",Qc,Mc),K("SSSS",Tc),N(["S","SS","SSS","SSSS"],function(a,b){b[ed]=o(1e3*("0."+a))});var Ed=A("Milliseconds",!1);F("z",0,0,"zoneAbbr"),F("zz",0,0,"zoneName");var Fd=m.prototype;Fd.add=td,Fd.calendar=$a,Fd.clone=_a,Fd.diff=fb,Fd.endOf=pb,Fd.format=jb,Fd.from=kb,Fd.fromNow=lb,Fd.get=D,Fd.invalidAt=wb,Fd.isAfter=ab,Fd.isBefore=bb,Fd.isBetween=cb,Fd.isSame=db,Fd.isValid=ub,Fd.lang=vd,Fd.locale=mb,Fd.localeData=nb,Fd.max=pd,Fd.min=od,Fd.parsingFlags=vb,Fd.set=D,Fd.startOf=ob,Fd.subtract=ud,Fd.toArray=tb,Fd.toDate=sb,Fd.toISOString=ib,Fd.toJSON=ib,Fd.toString=hb,Fd.unix=rb,Fd.valueOf=qb,Fd.year=md,Fd.isLeapYear=fa,Fd.weekYear=zb,Fd.isoWeekYear=Ab,Fd.quarter=Fd.quarters=Db,Fd.month=V,Fd.daysInMonth=W,Fd.week=Fd.weeks=ka,Fd.isoWeek=Fd.isoWeeks=la,Fd.weeksInYear=Cb,Fd.isoWeeksInYear=Bb,Fd.date=wd,Fd.day=Fd.days=Jb,Fd.weekday=Kb,Fd.isoWeekday=Lb,Fd.dayOfYear=na,Fd.hour=Fd.hours=Bd,Fd.minute=Fd.minutes=Cd,Fd.second=Fd.seconds=Dd,Fd.millisecond=Fd.milliseconds=Ed,Fd.utcOffset=Ja,Fd.utc=La,Fd.local=Ma,Fd.parseZone=Na,Fd.hasAlignedHourOffset=Oa,Fd.isDST=Pa,Fd.isDSTShifted=Qa,Fd.isLocal=Ra,Fd.isUtcOffset=Sa,Fd.isUtc=Ta,Fd.isUTC=Ta,Fd.zoneAbbr=Rb,Fd.zoneName=Sb,Fd.dates=Z("dates accessor is deprecated. Use date instead.",wd),Fd.months=Z("months accessor is deprecated. Use month instead",V),Fd.years=Z("years accessor is deprecated. Use year instead",md),Fd.zone=Z("moment().zone is deprecated, use moment().utcOffset instead. https://github.com/moment/moment/issues/1779",Ka);var Gd=Fd,Hd={sameDay:"[Today at] LT",nextDay:"[Tomorrow at] LT",nextWeek:"dddd [at] LT",lastDay:"[Yesterday at] LT",lastWeek:"[Last] dddd [at] LT",sameElse:"L"},Id={LTS:"h:mm:ss A",LT:"h:mm A",L:"MM/DD/YYYY",LL:"MMMM D, YYYY",LLL:"MMMM D, YYYY LT",LLLL:"dddd, MMMM D, YYYY LT"},Jd="Invalid date",Kd="%d",Ld=/\d{1,2}/,Md={future:"in %s",past:"%s ago",s:"a few seconds",m:"a minute",mm:"%d minutes",h:"an hour",hh:"%d hours",d:"a day",dd:"%d days",M:"a month",MM:"%d months",y:"a year",yy:"%d years"},Nd=q.prototype;Nd._calendar=Hd,Nd.calendar=Vb,Nd._longDateFormat=Id,Nd.longDateFormat=Wb,Nd._invalidDate=Jd,Nd.invalidDate=Xb,Nd._ordinal=Kd,Nd.ordinal=Yb,Nd._ordinalParse=Ld,
    Nd.preparse=Zb,Nd.postformat=Zb,Nd._relativeTime=Md,Nd.relativeTime=$b,Nd.pastFuture=_b,Nd.set=ac,Nd.months=R,Nd._months=fd,Nd.monthsShort=S,Nd._monthsShort=gd,Nd.monthsParse=T,Nd.week=ha,Nd._week=nd,Nd.firstDayOfYear=ja,Nd.firstDayOfWeek=ia,Nd.weekdays=Fb,Nd._weekdays=xd,Nd.weekdaysMin=Hb,Nd._weekdaysMin=zd,Nd.weekdaysShort=Gb,Nd._weekdaysShort=yd,Nd.weekdaysParse=Ib,Nd.isPM=Ob,Nd._meridiemParse=Ad,Nd.meridiem=Pb,u("en",{ordinalParse:/\d{1,2}(th|st|nd|rd)/,ordinal:function(a){var b=a%10,c=1===o(a%100/10)?"th":1===b?"st":2===b?"nd":3===b?"rd":"th";return a+c}}),a.lang=Z("moment.lang is deprecated. Use moment.locale instead.",u),a.langData=Z("moment.langData is deprecated. Use moment.localeData instead.",w);var Od=Math.abs,Pd=rc("ms"),Qd=rc("s"),Rd=rc("m"),Sd=rc("h"),Td=rc("d"),Ud=rc("w"),Vd=rc("M"),Wd=rc("y"),Xd=tc("milliseconds"),Yd=tc("seconds"),Zd=tc("minutes"),$d=tc("hours"),_d=tc("days"),ae=tc("months"),be=tc("years"),ce=Math.round,de={s:45,m:45,h:22,d:26,M:11},ee=Math.abs,fe=Da.prototype;fe.abs=ic,fe.add=kc,fe.subtract=lc,fe.as=pc,fe.asMilliseconds=Pd,fe.asSeconds=Qd,fe.asMinutes=Rd,fe.asHours=Sd,fe.asDays=Td,fe.asWeeks=Ud,fe.asMonths=Vd,fe.asYears=Wd,fe.valueOf=qc,fe._bubble=mc,fe.get=sc,fe.milliseconds=Xd,fe.seconds=Yd,fe.minutes=Zd,fe.hours=$d,fe.days=_d,fe.weeks=uc,fe.months=ae,fe.years=be,fe.humanize=yc,fe.toISOString=zc,fe.toString=zc,fe.toJSON=zc,fe.locale=mb,fe.localeData=nb,fe.toIsoString=Z("toIsoString() is deprecated. Please use toISOString() instead (notice the capitals)",zc),fe.lang=vd,F("X",0,0,"unix"),F("x",0,0,"valueOf"),K("x",Uc),K("X",Wc),N("X",function(a,b,c){c._d=new Date(1e3*parseFloat(a,10))}),N("x",function(a,b,c){c._d=new Date(o(a))}),a.version="2.10.2",b(za),a.fn=Gd,a.min=Ba,a.max=Ca,a.utc=i,a.unix=Tb,a.months=dc,a.isDate=e,a.locale=u,a.invalid=k,a.duration=Ua,a.isMoment=n,a.weekdays=fc,a.parseZone=Ub,a.localeData=w,a.isDuration=Ea,a.monthsShort=ec,a.weekdaysMin=hc,a.defineLocale=v,a.weekdaysShort=gc,a.normalizeUnits=y,a.relativeTimeThreshold=xc;var ge=a;return ge});
},{}],37:[function(require,module,exports){
//  Optparse.js 1.0.3 - Option Parser for Javascript
//
//  Copyright (c) 2009 Johan Dahlberg
//
//  See README.md for license.
//
var optparse = {};
try{ optparse = exports } catch(e) {}; // Try to export the lib for node.js
(function(self) {
    var VERSION = '1.0.3';
    var LONG_SWITCH_RE = /^--\w/;
    var SHORT_SWITCH_RE = /^-\w/;
    var NUMBER_RE = /^(0x[A-Fa-f0-9]+)|([0-9]+\.[0-9]+)|(\d+)$/;
    var DATE_RE = /^\d{4}-(0[0-9]|1[0,1,2])-([0,1,2][0-9]|3[0,1])$/;
    var EMAIL_RE = /^([0-9a-zA-Z]+([_.-]?[0-9a-zA-Z]+)*@[0-9a-zA-Z]+[0-9,a-z,A-Z,.,-]*(.){1}[a-zA-Z]{2,4})+$/;
    var EXT_RULE_RE = /(\-\-[\w_-]+)\s+([\w\[\]_-]+)|(\-\-[\w_-]+)/;
    var ARG_OPTIONAL_RE = /\[(.+)\]/;

// The default switch argument filter to use, when argument name doesnt match
// any other names.
    var DEFAULT_FILTER = '_DEFAULT';
    var PREDEFINED_FILTERS = {};

// The default switch argument filter. Parses the argument as text.
    function filter_text(value) {
        return value;
    }

// Switch argument filter that expects an integer, HEX or a decimal value. An
// exception is throwed if the criteria is not matched.
// Valid input formats are: 0xFFFFFFF, 12345 and 1234.1234
    function filter_number(value) {
        var m = NUMBER_RE.exec(value);
        if(m == null) throw OptError('Expected a number representative');
        if(m[1]) {
            // The number is in HEX format. Convert into a number, then return it
            return parseInt(m[1], 16);
        } else {
            // The number is in regular- or decimal form. Just run in through
            // the float caster.
            return parseFloat(m[2] || m[3]);
        }
    };

// Switch argument filter that expects a Date expression. The date string MUST be
// formated as: "yyyy-mm-dd" An exception is throwed if the criteria is not
// matched. An DATE object is returned on success.
    function filter_date(value) {
        var m = DATE_RE.exec(value);
        if(m == null) throw OptError('Expected a date representation in the "yyyy-mm-dd" format.');
        return new Date(parseInt(m[0]), parseInt(m[1]) - 1, parseInt(m[2]));
    };

// Switch argument filter that expects an email address. An exception is throwed
// if the criteria doesn`t match.
    function filter_email(value) {
        var m = EMAIL_RE.exec(value);
        if(m == null) throw OptError('Excpeted an email address.');
        return m[1];
    }

// Register all predefined filters. This dict is used by each OptionParser
// instance, when parsing arguments. Custom filters can be added to the parser
// instance by calling the "add_filter" -method.
    PREDEFINED_FILTERS[DEFAULT_FILTER] = filter_text;
    PREDEFINED_FILTERS['TEXT'] = filter_text;
    PREDEFINED_FILTERS['NUMBER'] = filter_number;
    PREDEFINED_FILTERS['DATE'] = filter_date;
    PREDEFINED_FILTERS['EMAIL'] = filter_email;

//  Buildes rules from a switches collection. The switches collection is defined
//  when constructing a new OptionParser object.
    function build_rules(filters, arr) {
        var rules = [];
        for(var i=0; i<arr.length; i++) {
            var r = arr[i], rule;
            if(!contains_expr(r)) throw OptError('Rule MUST contain an option.');
            switch(r.length) {
                case 1:
                    rule = build_rule(filters, undefined, r[0]);
                    break;
                case 2:
                    var expr = LONG_SWITCH_RE.test(r[0]) ? 0 : 1;
                    var alias = expr == 0 ? -1 : 0;
                    var desc = alias == -1 ? 1 : -1;
                    rule = build_rule(filters, r[alias], r[expr], r[desc]);
                    break;
                case 3:
                    rule = build_rule(filters, r[0], r[1], r[2]);
                    break;
                case 4:
                    rule = build_rule(filters, r[0], r[1], r[2], r[3]);
                    break;
                default:
                case 0:
                    continue;
            }
            rules.push(rule);
        }
        return rules;
    }

//  Builds a rule with specified expression, short style switch and help. This
//  function expects a dict with filters to work correctly.
//
//  Return format:
//      name               The name of the switch.
//      short              The short style switch
//      long               The long style switch
//      decl               The declaration expression (the input expression)
//      desc               The optional help section for the switch
//      optional_arg       Indicates that switch argument is optional
//      filter             The filter to use when parsing the arg. An
//		callback		   The callback for when flag is used
//                         <<undefined>> value means that the switch does
//                         not take anargument.
    function build_rule(filters, short, expr, desc, callback) {
        var optional, filter;
        var m = expr.match(EXT_RULE_RE);
        if(m == null) throw OptError('The switch is not well-formed.');
        var long = m[1] || m[3];
        if(m[2] != undefined) {
            // A switch argument is expected. Check if the argument is optional,
            // then find a filter that suites.
            var optional = ARG_OPTIONAL_RE.test(m[2]);
            var optional_match = m[2].match(ARG_OPTIONAL_RE);
            var filter_name = optional ? optional_match[1] : m[2];
            filter = filters[filter_name];
            if(filter === undefined) filter = filters[DEFAULT_FILTER];
        }
        return {
            name: long.substr(2),
            short: short,
            long: long,
            decl: expr,
            desc: desc,
            optional_arg: optional,
            filter: filter,
            callback: callback
        }
    }

// Loop's trough all elements of an array and check if there is valid
// options expression within. An valid option is a token that starts
// double dashes. E.G. --my_option
    function contains_expr(arr) {
        if(!arr || !arr.length) return false;
        var l = arr.length;
        while(l-- > 0) if(LONG_SWITCH_RE.test(arr[l])) return true;
        return false;
    }

// Extends destination object with members of source object
    function extend(dest, src) {
        var result = dest;
        for(var n in src) {
            result[n] = src[n];
        }
        return result;
    }

// Appends spaces to match specified number of chars
    function spaces(arg1, arg2) {
        var l, builder = [];
        if(arg1.constructor === Number) {
            l = arg1;
        } else {
            if(arg1.length == arg2) return arg1;
            l = arg2 - arg1.length;
            builder.push(arg1);
        }
        while(l-- > 0) builder.push(' ');
        return builder.join('');
    }

//  Create a new Parser object that can be used to parse command line arguments.
//
//
    function Parser(rules) {
        return new OptionParser(rules);
    }

// Creates an error object with specified error message.
    function OptError(msg) {
        return new function() {
            this.msg = msg;
            this.toString = function() {
                return this.msg;
            }
        }
    }

    function OptionParser(rules) {
        this.banner = 'Usage: [Options]';
        this.options_title = 'Available options:'
        this._rules = rules;
        this._halt = false;
        this.filters = extend({}, PREDEFINED_FILTERS);
        this.on_args = {};
        this.on_switches = {};
        this.on_halt = function() {};
        this.default_handler = function() {};
    }

    OptionParser.prototype = {

        // Adds args and switchs handler.
        on: function(value, fn) {
            if(value.constructor === Function ) {
                this.default_handler = value;
            } else if(value.constructor === Number) {
                this.on_args[value] = fn;
            } else {
                this.on_switches[value] = fn;
            }
        },

        // Adds a custom filter to the parser. It's possible to override the
        // default filter by passing the value "_DEFAULT" to the ��name��
        // argument. The name of the filter is automatically transformed into
        // upper case.
        filter: function(name, fn) {
            this.filters[name.toUpperCase()] = fn;
        },

        // Parses specified args. Returns remaining arguments.
        parse: function(args) {
            var result = [], callback;
            var rules = build_rules(this.filters, this._rules);
            var tokens = args.concat([]);
            var token;
            while(this._halt == false && (token = tokens.shift())) {
                if(LONG_SWITCH_RE.test(token) || SHORT_SWITCH_RE.test(token)) {
                    var arg = undefined;
                    // The token is a long or a short switch. Get the corresponding
                    // rule, filter and handle it. Pass the switch to the default
                    // handler if no rule matched.
                    for(var i = 0; i < rules.length; i++) {
                        var rule = rules[i];
                        if(rule.long == token || rule.short == token) {
                            if(rule.filter !== undefined) {
                                arg = tokens.shift();
                                if(arg && (!LONG_SWITCH_RE.test(arg) && !SHORT_SWITCH_RE.test(arg))) {
                                    try {
                                        arg = rule.filter(arg, tokens);
                                    } catch(e) {
                                        throw OptError(token + ': ' + e.toString());
                                    }
                                } else if(rule.optional_arg) {
                                    if(arg) {
                                        tokens.unshift(arg);
                                    }
                                } else {
                                    throw OptError('Expected switch argument.');
                                }
                            }
                            callback = this.on_switches[rule.name];
                            if(rule.callback) rule.callback.apply(this, [rule.name, arg])
                            if (!callback) callback = this.on_switches['*'];
                            if(callback) callback.apply(this, [rule.name, arg]);
                            break;
                        }
                    }
                    if(i == rules.length) this.default_handler.apply(this, [token]);
                } else {
                    // Did not match long or short switch. Parse the token as a
                    // normal argument.
                    callback = this.on_args[result.length];
                    result.push(token);
                    if(callback) callback.apply(this, [token]);
                }
            }
            return this._halt ? this.on_halt.apply(this, [tokens]) : result;
        },

        // Returns an Array with all defined option rules
        options: function() {
            return build_rules(this.filters, this._rules);
        },

        // Add an on_halt callback if argument ��fn�� is specified. on_switch handlers can
        // call instance.halt to abort the argument parsing. This can be useful when
        // displaying help or version information.
        halt: function(fn) {
            this._halt = fn === undefined
            if(fn) this.on_halt = fn;
        },

        // Returns a string representation of this OptionParser instance.
        toString: function() {
            var builder = [this.banner, '', this.options_title],
                shorts = false, longest = 0, rule;
            var rules = build_rules(this.filters, this._rules);
            for(var i = 0; i < rules.length; i++) {
                rule = rules[i];
                // Quick-analyze the options.
                if(rule.short) shorts = true;
                if(rule.decl.length > longest) longest = rule.decl.length;
            }
            for(var i = 0; i < rules.length; i++) {
                var text = spaces(6);
                rule = rules[i];
                if(shorts) {
                    if(rule.short) text = spaces(2) + rule.short + ', ';
                }
                text += spaces(rule.decl, longest) + spaces(3);
                text += rule.desc;
                builder.push(text);
            }
            return builder.join('\n');
        }
    }

    self.VERSION = VERSION;
    self.OptionParser = OptionParser;

})(optparse);

},{}],38:[function(require,module,exports){

/**
 * Mission contains all of the mission data retrieved from backend. It emits on Update, Complete etc.
 * @class Mission
 * @module Frontend
 * @submodule Frontend.Mission
 * @namespace GothamGame.Mission
 */
var Mission;

Mission = (function() {
  var Requirement;

  function Mission() {
    this.id = null;
    this._title = null;
    this._description = null;
    this._description_ext = null;
    this._requiredXP = null;
    this._engine = null;
    this._data = null;
    this.ongoing = false;
    this._requirements = {};
    this.onProgress = function() {};
    this.onRequirementComplete = function() {};
    this.onComplete = function() {};
  }

  Mission.prototype.updateState = function() {
    if (this.isCompleted()) {
      return this.onComplete(this);
    }
  };

  Mission.prototype.addRequirement = function(requirementData) {
    var requirement;
    requirement = new Requirement(this, requirementData);
    this._requirements[requirementData.id] = requirement;
    return requirement;
  };

  Mission.prototype.addUserMissionRequirement = function(userMissionRequirementData) {
    var requirement;
    requirement = this._requirements[userMissionRequirementData.mission_requirement];
    requirement.setCurrent(userMissionRequirementData.current);
    requirement.setExpected(userMissionRequirementData.expected);
    requirement.setEmitInput(userMissionRequirementData.emit_input);
    requirement.setEmitValue(userMissionRequirementData.emit_value);
    return requirement.userMissionRequirementData = userMissionRequirementData;
  };

  Mission.prototype.addRequirements = function(arr) {
    var i, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      i = arr[_i];
      _results.push(this.addRequirement(i));
    }
    return _results;
  };

  Mission.prototype.addUserMissionRequirements = function(arr) {
    var i, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      i = arr[_i];
      _results.push(this.addUserMissionRequirement(i));
    }
    return _results;
  };

  Mission.prototype.getRequirement = function(requirementName) {
    return this._requirements[requirementName];
  };

  Mission.prototype.getRequirements = function() {
    return this._requirements;
  };

  Mission.prototype.isCompleted = function() {
    var idx, isComplete, req, _ref;
    isComplete = true;
    _ref = this._requirements;
    for (idx in _ref) {
      req = _ref[idx];
      if (!req.isComplete()) {
        isComplete = false;
        break;
      }
    }
    return isComplete;
  };

  Mission.prototype.setTitle = function(title) {
    return this._title = title;
  };

  Mission.prototype.setDescription = function(description) {
    return this._description = description;
  };

  Mission.prototype.setExtendedDescription = function(description_ext) {
    return this._description_ext = description_ext;
  };

  Mission.prototype.setRequiredXP = function(xp) {
    return this._requiredXP = xp;
  };

  Mission.prototype.setID = function(id) {
    return this.id = id;
  };

  Mission.prototype.setUserMissionID = function(userMissionId) {
    return this.userMissionId = userMissionId;
  };

  Mission.prototype.getUserMissionID = function() {
    return this.userMissionId;
  };

  Mission.prototype.setMoneyGain = function(moneyGain) {
    return this.money_gain = moneyGain;
  };

  Mission.prototype.getMoneyGain = function() {
    return this.money_gain;
  };

  Mission.prototype.setExperienceGain = function(expGain) {
    return this.experience_gain = expGain;
  };

  Mission.prototype.getExperienceGain = function() {
    return this.experience_gain;
  };

  Mission.prototype.setOngoing = function(ongoing) {
    return this.ongoing = ongoing;
  };

  Mission.prototype.getOngoing = function() {
    return this.ongoing;
  };

  Mission.prototype.getID = function() {
    return this.id;
  };

  Mission.prototype.getTitle = function() {
    return this._title;
  };

  Mission.prototype.getDescription = function() {
    return this._description;
  };

  Mission.prototype.getExtendedDescription = function() {
    return this._description_ext;
  };

  Mission.prototype.getRequiredXP = function() {
    return this._requiredXP;
  };

  Mission.prototype.emit = function(emit_name, emit_value, _c) {
    var key, requirement, _ref, _results;
    _ref = this._requirements;
    _results = [];
    for (key in _ref) {
      requirement = _ref[key];
      if (requirement._emit === emit_name) {
        console.log("[MISSION] Matched Requirement " + requirement._requirement);
        _results.push(requirement.emit(emit_value, _c));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Mission.prototype.generateEvent = function(name, mission, trigger, requirement) {
    var event;
    event = {
      name: name,
      mission: mission,
      trigger: trigger,
      requirement: requirement
    };
    return event;
  };

  "triggerComplete: ->\n  for callback in  @_engine._triggerCallbacks.missionCompleted\n    callback(@generateEvent(@_name, @, \"complete\"))\n\ntriggerFailed: ->\n  for callback in  @_engine._triggerCallbacks.missionFailed\n    callback(@generateEvent(@_name, @, \"failed\"))\n\n# Trigger for progress, Takes option Requirement input\n#\n# @param requirement {Requirement} The requirement\n#\ntriggerProgress: (requirement) ->\n  for callback in  @_engine._triggerCallbacks.missionProgress\n    callback(@generateEvent(@_name, @, \"progress\", requirement))\n\n  # Check if all requirements is completed\n  if @isCompleted()\n    @triggerComplete()\n\ntriggerAccepted: ->\n  for callback in  @_engine._triggerCallbacks.missionAccepted\n    callback(@generateEvent(@_name, @, \"accepted\"))";

  Mission.prototype.printMission = function() {
    console.log("-----------------------------------");
    console.log("Mission Name: " + this._title);
    console.log("Mission Description: " + this._description);
    console.log("Requirements:");
    $.each(this._requirements, function(key, val) {
      return console.log("\t" + val._requirement + ": " + (val.getCurrentValue()) + "/" + (val.getExpectedValue()));
    });
    return console.log("-----------------------------------");
  };


  /**
   * Requirement class for adding part of a mission. A requirement is basically part of a mission. Example: Ping IP: null/192.168.21.1
   * @class Requirement
   * @module Frontend
   * @submodule Frontend.Mission
   * @namespace GothamGame.Mission
   */

  Requirement = (function() {
    function Requirement(mission, requirementData) {
      this._requirementData = requirementData;
      this._id = requirementData.id;
      this._mission = this.mission = mission;
      this._requirement = requirementData.requirement;
      this._current = requirementData["default"];
      this._expected = requirementData.expected;
      this._emit = requirementData.emit;
      this._emit_value = requirementData.emit_value;
      this._emit_input = requirementData.emit_input;
      this._emit_behaviour = requirementData.emit_behaviour;
      this._complete = false;
    }

    Requirement.prototype.getCurrent = function() {
      return this._current;
    };

    Requirement.prototype.getExpected = function() {
      return this._expected;
    };

    Requirement.prototype.getName = function() {
      return this._requirement;
    };

    Requirement.prototype.setCurrent = function(current) {
      this._current = current;
      return this.isComplete();
    };

    Requirement.prototype.setExpected = function(expected) {
      this._expected = expected;
      return this.isComplete();
    };

    Requirement.prototype.setEmitValue = function(emitValue) {
      return this._emit_value = emitValue;
    };

    Requirement.prototype.setEmitInput = function(emitInput) {
      return this._emit_input = emitInput;
    };

    Requirement.prototype.isComplete = function() {
      if ("" + this._current === "" + this._expected) {
        this._complete = true;
      }
      return this._complete;
    };

    Requirement.prototype.emit = function(input, _c) {
      if (this._complete) {
        return;
      }
      if (input !== this._emit_input) {
        console.warn("Requirement input is invalid! Got " + input + ", Expected: " + this._emit_input);
        return;
      }
      if (this._emit_behaviour === "increment") {
        this._current = parseInt(this._current);
        this._current += parseInt(this._emit_value);
      } else if (this._emit_behaviour === "decrement") {
        this._current = parseInt(this._current);
        this._current -= parseInt(this._emit_value);
      } else if (this._emit_behaviour === "set") {
        this._current = this._emit_value;
      }
      if ("" + this._current === "" + this._expected) {
        this._complete = true;
        _c(this);
        this._mission.onRequirementComplete(this);
        if (this._mission.isCompleted()) {
          return this._mission.onComplete(this._mission);
        }
      } else {
        return this._mission.onProgress(this);
      }
    };

    Requirement.prototype.isComplete = function() {
      if ("" + this.getCurrentValue() === "" + this.getExpectedValue()) {
        return true;
      } else {
        return false;
      }
    };

    Requirement.prototype.getExpectedValue = function() {
      if (typeof this._expected === "function") {
        return this.expectValue();
      } else {
        return this._expected;
      }
    };

    Requirement.prototype.getCurrentValue = function() {
      if (typeof this._current === "function") {
        return this.currentValue();
      } else {
        return this._current;
      }
    };

    return Requirement;

  })();

  return Mission;

})();

module.exports = Mission;


},{}],39:[function(require,module,exports){

/**
 * MissionEngine class which keeps track of all missions. Adding, Removal and emits for each of the missions.
 * @class MissionEngine
 * @module Frontend
 * @submodule Frontend.Mission
 * @namespace GothamGame.MissionEngine
 */
var MissionEngine;

MissionEngine = (function() {
  function MissionEngine() {
    this._missions = {};
  }

  MissionEngine.prototype.createMission = function(missionData) {
    var mission;
    mission = new GothamGame.Mission();
    mission.setID(missionData.id);
    mission.setTitle(missionData.title);
    mission.setExtendedDescription(missionData.description_ext);
    mission.setDescription(missionData.description);
    mission.setRequiredXP(missionData.required_xp);
    mission.addRequirements(missionData.MissionRequirements);
    mission.setMoneyGain(missionData.money_gain);
    mission.setExperienceGain(missionData.experience_gain);
    if (missionData.UserMissionRequirements) {
      mission.setUserMissionID(missionData.userMissionId);
      mission.addUserMissionRequirements(missionData.UserMissionRequirements);
    }
    return mission;
  };

  MissionEngine.prototype.addMission = function(mission) {
    this._missions[mission.id] = mission;
    return mission;
  };

  MissionEngine.prototype.removeMission = function(mission) {
    delete this._missions[mission.id];
    return mission;
  };

  MissionEngine.prototype.emit = function(emit, emit_value, _c) {
    var key, mission, _ref;
    _ref = this._missions;
    for (key in _ref) {
      mission = _ref[key];
      mission.emit(emit, emit_value, _c);
    }
    return GothamGame.Renderer.getScene("World").getObject("Mission").updateView();
  };

  return MissionEngine;

})();

module.exports = MissionEngine;


},{}],40:[function(require,module,exports){
var Application, optparse;

optparse = require('../../../dependencies/optparse.js');


/**
 * Application Base class, Takes care of command parsing and opt parsing
 * @class Application
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @namespace GothamGame.Terminal.Application
 */

Application = (function() {
  Application.Command = void 0;

  function Application(command) {
    this._commandObject = command;
    this.Command = command.command;
    this.Arguments = command["arguments"];
    this.Console = command.controller.console;
    this.Controller = command.controller;
  }

  Application.prototype.ArgumentParser = function() {
    this.ArgumentParser = new optparse.OptionParser(this.switches());
    return this.ArgumentParser;
  };

  Application.prototype.switches = function() {
    throw new Error("" + this.prototype.constructor.name + ".switches() is not overriden. It should Return a array with switches, see https://github.com/jfd/optparse-js/blob/master/examples/browser-test.html");
  };

  Application.prototype.execute = function() {
    throw new Error("" + this.prototype.constructor.name + ".execute() is not overriden");
  };

  Application.GetCommand = function() {
    if (!this.Command) {
      throw new ReferenceError("Application " + this.prototype.constructor.name + " is missing a command!");
    }
    return this.Command;
  };

  return Application;

})();

module.exports = Application;


},{"../../../dependencies/optparse.js":37}],41:[function(require,module,exports){
var Application, ChangeDirectory,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application for the "cd" command.
 * @class ChangeDirectory
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

ChangeDirectory = (function(_super) {
  __extends(ChangeDirectory, _super);

  function ChangeDirectory() {
    return ChangeDirectory.__super__.constructor.apply(this, arguments);
  }

  ChangeDirectory.Command = "cd";

  ChangeDirectory.prototype.execute = function() {
    return this.Controller.filesystem.cd(this.Arguments);
  };

  return ChangeDirectory;

})(Application);

module.exports = ChangeDirectory;


},{"./Application.coffee":40}],42:[function(require,module,exports){
var Application, Clear,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application for the clear command in Unix
 * @class Clear
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

Clear = (function(_super) {
  __extends(Clear, _super);

  function Clear() {
    return Clear.__super__.constructor.apply(this, arguments);
  }

  Clear.Command = "clear";

  return Clear;

})(Application);

module.exports = Clear;


},{"./Application.coffee":40}],43:[function(require,module,exports){
var Application, Copy,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application for the "cp" command in Unix
 * @class Copy
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

Copy = (function(_super) {
  __extends(Copy, _super);

  function Copy() {
    return Copy.__super__.constructor.apply(this, arguments);
  }

  Copy.Command = "cp";

  return Copy;

})(Application);

module.exports = Copy;


},{"./Application.coffee":40}],44:[function(require,module,exports){
var Application, ListSegments,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

Application = require('./Application.coffee');


/**
 * Application for the "ls" command in Unix.
 * @class ListSegments
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

ListSegments = (function(_super) {
  __extends(ListSegments, _super);

  ListSegments.Command = "ls";

  function ListSegments(command) {
    ListSegments.__super__.constructor.call(this, command);
  }

  ListSegments.prototype.execute = function() {
    var child, createdDate, dirPermission, ext, extension, filename, files, group, out, output, owner, permission, size, _results;
    output = "";
    files = this.Controller.filesystem.ls();
    if (__indexOf.call(this.Arguments, "-la") >= 0) {
      _results = [];
      for (filename in files) {
        child = files[filename];
        dirPermission = child.extension !== "dir" ? "d" : "-";
        permission = "rwxrwxrwx";
        owner = this.Controller.identity.first_name;
        group = this.Controller.identity.first_name;
        size = 4096;
        createdDate = "Apr 17 20:37";
        extension = child.extension !== "dir" ? "." + child.extension : "";
        filename = filename + extension;
        out = "" + dirPermission + permission + "\t" + owner + "\t" + group + "\t" + size + "\t" + createdDate + "\t" + filename;
        _results.push(this.Console.add(out));
      }
      return _results;
    } else {
      for (filename in files) {
        child = files[filename];
        ext = child.extension !== "dir" ? "." + child.extension : "";
        output += "" + filename + ext + "    ";
      }
      return this.Console.add(output);
    }
  };

  return ListSegments;

})(Application);

module.exports = ListSegments;


},{"./Application.coffee":40}],45:[function(require,module,exports){
var Application, Move,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application for the mv comamnd in Unix
 * @class Move
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

Move = (function(_super) {
  __extends(Move, _super);

  Move.Command = "mv";

  function Move(command) {
    Move.__super__.constructor.call(this, command);
  }

  Move.prototype.locate = function(splitArgument) {
    var action, target, _i, _len;
    if (splitArgument[0] === "") {
      target = this.Controller.filesystem._root;
    } else {
      target = this.Controller.filesystem._fs;
    }
    for (_i = 0, _len = splitArgument.length; _i < _len; _i++) {
      action = splitArgument[_i];
      if (action === ".") {
        target = this.Controller.filesystem._fs;
      } else if (action === "..") {
        if (target.parent) {
          if (target.parent.extension === "dir") {
            target = target.parent;
          } else {
            console.log("Could NOT FIND... (not dir)");
          }
        }
      } else {
        if (target.children[action]) {
          target = target.children[action];
        }
      }
    }
    return target;
  };

  Move.prototype.execute = function() {
    var path, splitArgument;
    console.log(this.Arguments);
    console.log(this);
    splitArgument = this.Arguments[0].split("/");
    path = this.locate(splitArgument);
    console.log(path);
    return console.log(splitArgument);
  };

  return Move;

})(Application);

module.exports = Move;


},{"./Application.coffee":40}],46:[function(require,module,exports){
var Application, Ping,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application for Ping which simulates Unix based ping
 * @class Ping
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

Ping = (function(_super) {
  __extends(Ping, _super);

  Ping.Command = "ping";

  function Ping(command) {
    Ping.__super__.constructor.call(this, command);
    this.Packet = {
      sourceHost: null,
      target: null,
      inverval: 1,
      count: 5,
      packetsize: 56,
      quiet: false,
      deadline: false,
      max_ttl: 56
    };
  }

  Ping.prototype.switches = function() {
    var that;
    that = this;
    return [
      [
        '-h', '--help', 'Show Help', function() {
          that.Console.addArray(this.toString().split("\n"));
          return that.Packet = {};
        }
      ], [
        '-c', '--count NUMBER', 'Stop after sending count ECHO_REQUEST packets', function(key, val) {
          return that.Packet.count = val;
        }
      ], [
        '-i', '--interval DOUBLE', 'Ping Interval', function(key, val) {
          return that.Packet.interval = val;
        }
      ], [
        '-s', '--packetsize NUMBER', 'Packetsize', function(key, val) {
          return that.Packet.packetsize = val;
        }
      ], [
        '-q', '--quiet', 'Quiet output.', function(key, val) {
          return that.Packet.quiet = true;
        }
      ], [
        '-w', '--deadline NUMBER', 'Specify a timeout, in seconds, before ping exits', function(key, val) {
          return that.Packet.deadline = val;
        }
      ], [
        '-V', '--version', 'Show version number', function(key, val) {
          return that.Console.add("ping utility, iputils-GOTHAM2010002");
        }
      ]
    ];
  };

  Ping.prototype.execute = function() {
    var fetchIPAddress, parser, that;
    that = this;
    parser = this.ArgumentParser();
    parser.on(function() {
      return that.Console.addArray(this.toString().split("\n"));
    });
    fetchIPAddress = function(ipHost) {
      if (GothamGame.Tools.HostUtils.validIPHost(ipHost)) {
        return that.Packet.target = ipHost;
      } else {
        return that.Console.add("" + that.Command + ": unknown host: " + ipHost);
      }
    };
    [0, this.Arguments.length].forEach(function(idx) {
      return parser.on(idx, fetchIPAddress);
    });
    parser.parse(this.Arguments);
    this.Packet.sourceHost = this._commandObject.controller.host.id;
    if (this.Packet.target) {
      GothamGame.MissionEngine.emit("Ping", this.Packet.target, function(req) {
        return GothamGame.Announce.message("" + req._mission._title + "\n" + req._requirement + " --> " + req._current + "/" + req._expected, "MISSION", 50);
      });
      GothamGame.Network.Socket.emit('Ping', this.Packet);
      GothamGame.Network.Socket.on('Ping_Host_Not_found', function() {
        this.removeListener('Ping_Host_Not_found');
        return that.Console.add("ping: unknown host " + that.Packet.target);
      });
      return GothamGame.Network.Socket.on('Ping', function(session) {
        var avg_rtt, duration, i, max_rtt, min_rtt, onDone, ping, startTime, _i, _len, _ref, _results;
        this.removeListener('Ping_Host_Not_found');
        this.removeListener('Ping');
        that.Console.add("PING " + session.target + " (" + session.target + ") " + session.packetsize + "(" + (session.packetsize + session.HEADER_SIZE) + ") bytes of data.");
        i = 0;
        startTime = Date.now();
        duration = null;
        min_rtt = 10000000;
        max_rtt = -1000000;
        avg_rtt = 0;
        onDone = function() {
          that.Console.add("--- " + session.target + " ping statistics ---");
          that.Console.add("" + i + " packets transmitted, " + i + " received, 0% packet loss, time " + duration + "ms");
          return that.Console.add("rtt min/avg/max = " + (min_rtt.toFixed(3)) + "/" + (max_rtt.toFixed(3)) + "/" + (avg_rtt.toFixed(3)) + " ms");
        };
        _ref = session.pings;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ping = _ref[_i];
          _results.push(setTimeout((function() {
            var randomRTT;
            randomRTT = Math.floor(Math.random() * (ping.rtt + 10)) + Math.max(ping.rtt - 10, 0);
            avg_rtt += randomRTT;
            if (randomRTT < min_rtt) {
              min_rtt = randomRTT;
            }
            if (randomRTT > max_rtt) {
              max_rtt = randomRTT;
            }
            that.Console.add("" + (session.packetsize + 8) + " bytes from (" + session.target + "): icmp_seq=" + (i++) + " ttl=" + that.Packet.max_ttl + " time=" + (randomRTT.toFixed(3)) + " ms");
            if (i >= session.pings.length) {
              duration = Date.now() - startTime;
              avg_rtt = avg_rtt / i;
              return onDone();
            }
          }), ping.time));
        }
        return _results;
      });
    }
  };

  return Ping;

})(Application);

module.exports = Ping;


},{"./Application.coffee":40}],47:[function(require,module,exports){
var Application, Slowloris,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application which simulates the behaviour of the perl application Slow Loris
 * @class Slowloris
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

Slowloris = (function(_super) {
  __extends(Slowloris, _super);

  Slowloris.Command = "slowloris.pl";

  function Slowloris(command) {
    Slowloris.__super__.constructor.call(this, command);
    this.Packet = {};
  }

  Slowloris.prototype.boot = function() {
    return ["CCCCCCCCCCOOCCOOOOO888@8@8888OOOOCCOOO888888888@@@@@@@@@8@8@@@@888OOCooocccc::::", "CCCCCCCCCCCCCCCOO888@888888OOOCCCOOOO888888888888@88888@@@@@@@888@8OOCCoococc:::", "CCCCCCCCCCCCCCOO88@@888888OOOOOOOOOO8888888O88888888O8O8OOO8888@88@@8OOCOOOCoc::", "CCCCooooooCCCO88@@8@88@888OOOOOOO88888888888OOOOOOOOOOCCCCCOOOO888@8888OOOCc::::", "CooCoCoooCCCO8@88@8888888OOO888888888888888888OOOOCCCooooooooCCOOO8888888Cocooc:", "ooooooCoCCC88@88888@888OO8888888888888888O8O8888OOCCCooooccccccCOOOO88@888OCoccc", "ooooCCOO8O888888888@88O8OO88888OO888O8888OOOO88888OCocoococ::ccooCOO8O888888Cooo", "oCCCCCCO8OOOCCCOO88@88OOOOOO8888O888OOOOOCOO88888O8OOOCooCocc:::coCOOO888888OOCC", "oCCCCCOOO88OCooCO88@8OOOOOO88O888888OOCCCCoCOOO8888OOOOOOOCoc::::coCOOOO888O88OC", "oCCCCOO88OOCCCCOO8@@8OOCOOOOO8888888OoocccccoCO8O8OO88OOOOOCc.:ccooCCOOOO88888OO", "CCCOOOO88OOCCOOO8@888OOCCoooCOO8888Ooc::...::coOO88888O888OOo:cocooCCCCOOOOOO88O", "CCCOO88888OOCOO8@@888OCcc:::cCOO888Oc..... ....cCOOOOOOOOOOOc.:cooooCCCOOOOOOOOO", "OOOOOO88888OOOO8@8@8Ooc:.:...cOO8O88c.      .  .coOOO888OOOOCoooooccoCOOOOOCOOOO", "OOOOO888@8@88888888Oo:. .  ...cO888Oc..          :oOOOOOOOOOCCoocooCoCoCOOOOOOOO", "COOO888@88888888888Oo:.       .O8888C:  .oCOo.  ...cCCCOOOoooooocccooooooooCCCOO", "CCCCOO888888O888888Oo. .o8Oo. .cO88Oo:       :. .:..ccoCCCooCooccooccccoooooCCCC", "coooCCO8@88OO8O888Oo:::... ..  :cO8Oc. . .....  :.  .:ccCoooooccoooocccccooooCCC", ":ccooooCO888OOOO8OOc..:...::. .co8@8Coc::..  ....  ..:cooCooooccccc::::ccooCCooC", ".:::coocccoO8OOOOOOC:..::....coCO8@8OOCCOc:...  ....:ccoooocccc:::::::::cooooooC", "....::::ccccoCCOOOOOCc......:oCO8@8@88OCCCoccccc::c::.:oCcc:::cccc:..::::coooooo", ".......::::::::cCCCCCCoocc:cO888@8888OOOOCOOOCoocc::.:cocc::cc:::...:::coocccccc", "...........:::..:coCCCCCCCO88OOOO8OOOCCooCCCooccc::::ccc::::::.......:ccocccc:co", ".............::....:oCCoooooCOOCCOCCCoccococc:::::coc::::....... ...:::cccc:cooo", " ..... ............. .coocoooCCoco:::ccccccc:::ccc::..........  ....:::cc::::coC", "   .  . ...    .... ..  .:cccoCooc:..  ::cccc:::c:.. ......... ......::::c:cccco", "  .  .. ... ..    .. ..   ..:...:cooc::cccccc:.....  .........  .....:::::ccoocc", "       .   .         .. ..::cccc:.::ccoocc:. ........... ..  . ..:::.:::::::ccco", " Welcome to Slowloris - the low bandwidth, yet greedy and poisonous HTTP client"];
  };

  Slowloris.prototype.switches = function() {
    var that;
    that = this;
    return [
      [
        '-h', '--help', 'Show Help', function() {
          return that.Console.addArray(this.toString().split("\n"));
        }
      ], [
        '-V', '--version', 'Show version number', function(key, val) {
          return that.Console.add("Version 0.7-GOTHAM");
        }
      ], [
        '-dns', '--hostname STRING', 'The hostname to attack', function(key, val) {
          console.log(val);
          return that.Packet.dns = val;
        }
      ], [
        '-port', '--port NUMBER', 'Target Port', function(key, val) {
          return that.Packet.port = val;
        }
      ], [
        '-shost', '--stealthhost STRING', 'If you know the server has multiple webservers running on it in virtual hosts, you can send the attack to a seperate virtual host using the -shost variable.  This way the logs that are created will go to a different virtual host log file, but only if they are kept separately.', function(key, val) {
          return that.Packet.shost = val;
        }
      ], [
        '-num', '--connections NUMBER', 'Number of connections to open to the target', function(key, val) {
          return that.Packet.num = val;
        }
      ], [
        '-tcpto', '--tcptimeout NUMBER', 'TCP Timeout (TODO)', function(key, val) {
          return that.Packet.tcpto = val;
        }
      ], [
        '-timeout', '--timeout NUMBER', 'Retry timeout (TODO)', function(key, val) {
          return that.Packet.timeout = val;
        }
      ], [
        '-httpready', '--httpready', 'HTTPReady only follows certain rules so with a switch Slowloris can bypass HTTPReady by sending the attack as a POST verses a GET or HEAD request with the -httpready switch.', function(key, val) {
          return that.Packet.httpready = val;
        }
      ], [
        '-https', '--https', 'Targetting HTTPS', function(key, val) {
          return that.Packet.https = val;
        }
      ], [
        '-test', '--test', 'Benchmarking Test', function(key, val) {
          return that.Packet.test = true;
        }
      ]
    ];
  };

  Slowloris.prototype.printUsage = function() {
    return this.Console.addArray(["Usage:", "", "     perl ./slowloris.pl -dns [www.example.com] -options", "", "     Type 'perldoc ./slowloris.pl' for help with options.", ""]);
  };

  Slowloris.prototype.execute = function() {
    var parser, that, time, times, totalTime, _i, _j, _len, _len1;
    that = this;
    this.Console.addArray(this.boot());
    parser = this.ArgumentParser();
    if (this.Arguments.length === 0) {
      this.printUsage();
    }
    parser.on(function() {
      return that.printUsage();
    });
    parser.parse(this.Arguments);
    if (!this.Packet.dns) {
      return this.printUsage();
    } else {
      if (!this.Packet.port) {
        this.Packet.port = 80;
        this.Console.add("Defaulting to port 80");
      }
      if (!this.Packet.tcpto) {
        this.Packet.tcpto = 5;
        this.Console.add("Defaulting to a 5 second tcp connection timeout.");
      }
      this.Console.add("Multithreading enabled.");
      if (!this.Packet.timeout) {
        this.Packet.timeout = 100;
        this.Console.add("Defaulting to a 100 second re-try timeout.");
      }
      if (!this.Packet.connections) {
        this.Packet.connections = 1000;
        this.Console.add("Defaulting to 1000 connections.");
      }
      if (this.Packet.test) {
        times = [2, 30, 90, 240, 500];
        totalTime = 0;
        for (_i = 0, _len = times.length; _i < _len; _i++) {
          time = times[_i];
          totalTime += time;
        }
        totalTime = totalTime / 60;
        this.Console.add("This test could take up to " + totalTime + " minutes.");
        this.Packet.payload = "GET /$rand HTTP/1.1\r\n";
        "Host: $sendhost\r\n";
        "User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.503l3; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; MSOffice 12)\r\n";
        "Content-Length: 42\r\n";
        if (true) {
          this.Console.add("Connection successful, now comes the waiting game...\n");
        } else {
          this.Console.add("Uhm... I can't connect to " + this.Packet.dns + ":" + this.Packet.port);
          this.Console.add("Is something wrong?\nDying.\n");
          return;
        }
        for (_j = 0, _len1 = times.length; _j < _len1; _j++) {
          time = times[_j];
          this.Console.add("Trying a " + time + " second delay.");
          this.Console.add("\tWorked.");
        }
        this.Console.add("Remote server closed socket.");
        this.Console.add("Use 90 seconds for -timeout.");
      }
    }
  };

  return Slowloris;

})(Application);

module.exports = Slowloris;


},{"./Application.coffee":40}],48:[function(require,module,exports){
var Application, Traceroute,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Application = require('./Application.coffee');


/**
 * Application which simulates Traceroute from the Unix platform
 * @class Traceroute
 * @module Frontend
 * @submodule Frontend.Terminal.Application
 * @extends Application
 * @namespace GothamGame.Terminal.Application
 */

Traceroute = (function(_super) {
  __extends(Traceroute, _super);

  Traceroute.Command = "traceroute";

  function Traceroute(command) {
    Traceroute.__super__.constructor.call(this, command);
    this.Packet = {
      sourceHost: null,
      target: null,
      algorithm: "b*",
      max_ttl: 30,
      first_ttl: 1
    };
  }

  Traceroute.prototype.switches = function() {
    var that;
    that = this;
    return [
      [
        '-h', '--help', 'Show Help', function() {
          that.Console.addArray(this.toString().split("\n"));
          return that.Packet = {};
        }
      ], [
        '-a', '--algorithm STRING', 'Choose algorithm to use, Default: b*', function(key, val) {
          if (val != null) {
            return that.Packet.algorithm = val;
          } else {
            return that.Console.add("Available Algorithms: [a*, b*, brutus]");
          }
        }
      ], [
        '-m', '--max-hops max_ttl', 'Specifies the maximum number of hops (max time-to-live value) traceroute will probe. The default is 30.', function(key, val) {
          if (val != null) {
            return that.Packet.max_ttl = val;
          }
        }
      ], [
        '-f', '--first first_ttl', 'Specifies with what TTL to start. Defaults to 1.', function(key, val) {
          if (val != null) {
            return that.Packet.first_ttl = val;
          }
        }
      ], [
        '-V', '--version', 'Show version number', function(key, val) {
          return that.Console.add("traceroute utility, traceroute.v01501-GOTHAM");
        }
      ]
    ];
  };

  Traceroute.prototype.execute = function() {
    var ipCallback, parser, that;
    that = this;
    parser = this.ArgumentParser();
    ipCallback = function(ipHost) {
      if (GothamGame.Tools.HostUtils.validIPHost(ipHost)) {
        return that.Packet.target = ipHost;
      } else {
        return that.Console.add("" + that.Command + ": unknown host: " + ipHost);
      }
    };
    parser.on(function() {
      return that.Console.addArray(this.toString().split("\n"));
    });
    parser.on(0, ipCallback);
    parser.on(this.Arguments.length, ipCallback);
    this.Packet.sourceHost = this._commandObject.controller.host.id;
    parser.parse(this.Arguments);
    GothamGame.Network.Socket.emit('Traceroute', this.Packet, Gotham.Database.table("blacklist").data);
    GothamGame.MissionEngine.emit("Traceroute", this.Packet.target, function(req) {
      return GothamGame.Announce.message("" + req._mission._title + "\n" + req._requirement + " --> " + req._current + "/" + req._expected, "MISSION", 50);
    });
    return GothamGame.Network.Socket.on('Traceroute', function(path, output, targetNetwork) {
      var current, db_node, direction, hopCount, last, lengthGap, newEnd, newStart, nodeID, tween, _i, _len;
      this.removeListener('Traceroute');
      targetNetwork = JSON.parse(targetNetwork);
      GothamGame.MissionEngine.emit('traceroute', targetNetwork.external_ip_v4, function() {
        return console.log("Traceroute emit registererd. setting to completed!");
      });
      GothamGame.Renderer.getScene("World").getObject("WorldMap").View.clearAnimatePath();
      db_node = Gotham.Database.table("node");
      last = that._commandObject.controller.network;
      hopCount = 1;
      that.Console.add("traceroute to " + targetNetwork.external_ip_v4 + " (" + targetNetwork.external_ip_v4 + "), 30 hops max, 60 byte packets");
      that.Console.add(" " + (hopCount++) + "  " + last.internal_ip_v4 + " (" + last.internal_ip_v4 + ")");
      for (_i = 0, _len = path.length; _i < _len; _i++) {
        nodeID = path[_i];
        current = db_node.findOne({
          id: nodeID
        });
        that.Console.add(" " + (hopCount++) + "  " + current.Network.external_ip_v4 + " (" + current.Network.external_ip_v4 + ")");
        direction = last.lng < 0 ? 180 : -180;
        lengthGap = Math.abs(last.lng - current.lng);
        if (lengthGap > 160) {
          newEnd = {
            lat: current.lat,
            lng: direction * -1
          };
          newStart = {
            lat: current.lat,
            lng: direction
          };
          tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, newEnd);
          tween.start();
          last = newStart;
        }
        tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, current);
        tween.start();
        last = current;
      }
      while (hopCount++ < 30) {
        that.Console.add(" " + (hopCount++) + "  * * *");
      }
      tween = GothamGame.Renderer.getScene("World").getObject("WorldMap").View.animatePath(last, targetNetwork);
      return tween.start();
    });
  };

  return Traceroute;

})(Application);

module.exports = Traceroute;


},{"./Application.coffee":40}],49:[function(require,module,exports){

/**
 * Command is a terminal module which parses the input to the terminal. The command registers and identifies which command that should run.
 * @class Command
 * @module Frontend
 * @submodule Frontend.Terminal
 * @namespace GothamGame.Terminal
 * @constructor
 * @param tC {TerminalController} The terminal controller object
 * @param input {String} The input string from Terminal input field
 */
var Command;

Command = (function() {
  function Command(tC, input) {
    this.controller = tC;
    this.input = input;
    this.commandReference = void 0;
    this.command = void 0;
    this["arguments"] = [];
    this.parse();
  }

  Command.prototype.isCommand = function() {
    return !!this.commandReference;
  };

  Command.prototype.parse = function() {
    var appName, application, argument, commandArray, _i, _len, _ref, _results;
    commandArray = this.input.split(" ");
    this.command = commandArray.splice(0, 1)[0];
    for (_i = 0, _len = commandArray.length; _i < _len; _i++) {
      argument = commandArray[_i];
      this["arguments"].push(argument);
    }
    _ref = GothamGame.Terminal.Applications;
    _results = [];
    for (appName in _ref) {
      application = _ref[appName];
      if (this.command === application.GetCommand()) {
        console.log("Found command: " + this.command);
        this.commandReference = new application(this);
        break;
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Command.prototype.getCommandText = function() {
    return this.command;
  };

  Command.prototype.getArgs = function() {
    return this["arguments"];
  };

  Command.prototype.getInput = function() {
    return this.input;
  };

  Command.prototype.execute = function() {
    if (!this.commandReference) {
      throw new Error("RefCommand is not defined!");
    }
    return this.commandReference.execute();
  };

  return Command;

})();

module.exports = Command;


},{}],50:[function(require,module,exports){
var Console, Terminal,
  __modulo = function(a, b) { return (a % b + +b) % b; };

Terminal = require('./Terminal.coffee');


/**
 * Console Class Contains all data of the console window, Acts much like an array, but have some extended functionality for easy data manipulation
 * @class Console
 * @module Frontend
 * @submodule Frontend.Terminal
 * @namespace GothamGame.Terminal
 */

Console = (function() {
  function Console() {
    this._console = [];
    this._history = [];
    this._historyPointer = 0;
  }

  Console.prototype.redraw = function() {};

  Console.prototype.getAt = function(index) {
    return this._console[index];
  };

  Console.prototype.all = function() {
    return this._console;
  };

  Console.prototype.addAt = function(index, text) {
    return this._console.splice(index, 0, text);
  };

  Console.prototype.appendTo = function(index, text) {
    return this._console[index] += text;
  };

  Console.prototype.add = function(text) {
    this._console.push(text);
    return this.redraw();
  };

  Console.prototype.addArray = function(arr) {
    var i, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      i = arr[_i];
      _results.push(this.add(i));
    }
    return _results;
  };

  Console.prototype.addBefore = function(text) {
    return this.addAt(0, text);
  };

  Console.prototype.clear = function() {
    return this._console.length = 0;
  };

  Console.prototype.clearHistory = function() {
    return this._history.length = 0;
  };

  Console.prototype.getHistory = function() {
    return this._history;
  };

  Console.prototype.getHistoryAt = function(index) {
    if (this._history.length === 0) {
      return null;
    }
    return this._history[__modulo(index, this._history.length)];
  };

  Console.prototype.addHistory = function(command) {
    this._history.push(command);
    return this._historyPointer = this._history.length;
  };

  Console.prototype.incrementHistoryPointer = function(add) {
    this._historyPointer += add;
    return this._historyPointer;
  };

  return Console;

})();

module.exports = Console;


},{"./Terminal.coffee":52}],51:[function(require,module,exports){
var Filesystem, Terminal;

Terminal = require('./Terminal.coffee');


/**
 * The Filesystem Class parses the filestructure and makes it possible to navigate through the structure.
 * @class Filesystem
 * @module Frontend
 * @submodule Frontend.Terminal
 * @namespace GothamGame.Terminal
 */

Filesystem = (function() {
  function Filesystem(json) {
    var data;
    data = JSON.parse(json.data);
    this._fs = this.parse(data);
    this._root = this._fs;
    this.onError = function() {};
  }

  Filesystem.prototype.toRoot = function() {
    var root;
    root = this._fs;
    while (this._fs.parent !== null) {
      root = this._fs.parent;
    }
    return root;
  };

  Filesystem.prototype.parse = function(root) {
    var createParentNode;
    createParentNode = function(node, parent) {
      var key, value, _ref, _results;
      node.parent = parent;
      _ref = node.children;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        _results.push(createParentNode(value, node));
      }
      return _results;
    };
    createParentNode(root, null);
    return root;
  };

  Filesystem.prototype.navigate = function(path) {
    var child, curr, ext, filename, found, paths, startRoot, _i, _len, _path, _ref;
    startRoot = path.startsWith("/");
    paths = path.split("/");
    curr = startRoot ? this.toRoot() : this._fs;
    for (_i = 0, _len = paths.length; _i < _len; _i++) {
      _path = paths[_i];
      if (!curr) {
        break;
      }
      if (_path === "" || _path === ".") {
        continue;
      }
      if (_path === "..") {
        curr = curr.parent;
        continue;
      }
      found = null;
      _ref = curr.children;
      for (filename in _ref) {
        child = _ref[filename];
        ext = child.extension === "dir" ? "" : "." + child.extension;
        if (filename + ext === _path) {
          found = child;
          break;
        }
      }
      curr = found;
    }
    return curr;
  };

  Filesystem.prototype.findFiles = function(args) {
    var child, filename, matches, pattern, _i, _len, _ref;
    matches = [];
    for (_i = 0, _len = args.length; _i < _len; _i++) {
      pattern = args[_i];
      _ref = this._fs.children;
      for (filename in _ref) {
        child = _ref[filename];
        if (filename.contains(pattern)) {
          matches.push({
            extension: child.extension,
            name: filename
          });
        }
      }
    }
    return matches;
  };

  Filesystem.prototype.ls = function() {
    return this._fs.children;
  };

  Filesystem.prototype.mv = function(args) {
    var sourceNode, targetNode;
    sourceNode = this.navigate(args[0]);
    targetNode = this.navigate(args[1]);
    if (sourceNode === targetNode) {
      return;
    }
    if (targetNode === null) {
      sourceNode.Name = args[1];
      return;
    }
    sourceNode.parent.children.remove(sourceNode);
    sourceNode.parent = null;
    targetNode.children.push(sourceNode);
    return sourceNode.parent = targetNode;
  };

  Filesystem.prototype.cd = function(path) {
    var curr;
    if (path.length > 0) {
      path = path[0];
    } else {
      path = "";
    }
    curr = this.navigate(path);
    if (curr) {
      if (curr.extension === "dir") {
        return this._fs = curr;
      } else {
        return this.onError("-bash: cd: " + path + ": Not a directory");
      }
    } else {
      return this.onError("-bash: cd: " + path + ": No such file or directory");
    }
  };

  Filesystem.prototype.getPointer = function() {
    return this._fs;
  };

  Filesystem.prototype.print = function() {
    return console.log(this._fs);
  };

  return Filesystem;

})();

module.exports = Filesystem;


},{"./Terminal.coffee":52}],52:[function(require,module,exports){
'use strict';

/**
 * Terminal Class is a collection of modules. These modules in total represents a terminal which can be used by the User
 * @class Terminal
 * @module Frontend
 * @submodule Frontend.Terminal
 * @namespace GothamGame.Terminal
 */
var Terminal;

Terminal = (function() {
  function Terminal() {}

  Terminal.Command = require('./Command.coffee');

  Terminal.Filesystem = require('./Filesystem.coffee');

  Terminal.Console = require('./Console.coffee');

  Terminal.Applications = {
    'ChangeDirectory': require('./Applications/ChangeDirectory.coffee'),
    'Move': require('./Applications/Move.coffee'),
    'Copy': require('./Applications/Copy.coffee'),
    'Clear': require('./Applications/Clear.coffee'),
    'Ping': require('./Applications/Ping.coffee'),
    'Slowloris': require('./Applications/Slowloris.coffee'),
    'ListSegments': require('./Applications/ListSegments.coffee'),
    'Traceroute': require('./Applications/Traceroute.coffee')
  };

  return Terminal;

})();

module.exports = Terminal;


},{"./Applications/ChangeDirectory.coffee":41,"./Applications/Clear.coffee":42,"./Applications/Copy.coffee":43,"./Applications/ListSegments.coffee":44,"./Applications/Move.coffee":45,"./Applications/Ping.coffee":46,"./Applications/Slowloris.coffee":47,"./Applications/Traceroute.coffee":48,"./Command.coffee":49,"./Console.coffee":50,"./Filesystem.coffee":51}],53:[function(require,module,exports){
var Gotham, GothamGame, scene_Loading, setup;

Gotham = require('../../GameFramework/src/Gotham.coffee');

GothamGame = require('./GothamGame.coffee');

require('./dependencies/jquery-ui.min');

window.moment = require('./dependencies/moment.min');

setup = {
  started: false,
  preloadFonts: function(_c) {
    var done, s, s0, userAgent;
    userAgent = userAgent || navigator.userAgent;
    if (userAgent.indexOf('MSIE ') > -1 || userAgent.indexOf('Trident/') > -1) {
      _c();
      return false;
    }
    done = false;
    window.WebFontConfig = {
      google: {
        families: ['Inconsolata', 'Pacifico', 'Orbitron', 'Droid Serif']
      },
      active: function() {
        if (!done) {
          done = true;
          return _c();
        }
      }
    };
    setTimeout(window.WebFontConfig.active(), 5000);
    s = document.createElement('script');
    s.src = "" + (document.location.protocol === 'https:' ? 'https' : 'http') + "://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js";
    s.type = 'text/javascript';
    s.async = 'true';
    s0 = (document.getElementsByTagName('script'))[0];
    return s0.parentNode.insertBefore(s, s0);
  },
  preload: function() {
    Gotham.Preload.image("/assets/img/user_management_background.jpg", "user_management_background", "image");
    Gotham.Preload.image("/assets/img/user_management_frame.png", "user_management_frame", "image");
    Gotham.Preload.image("/assets/img/user_management_network_item.png", "user_management_network_item", "image");
    Gotham.Preload.image("/assets/img/user_mangement_host.png", "user_mangement_host", "image");
    Gotham.Preload.image("/assets/img/shop_background.jpg", "shop_background", "image");
    Gotham.Preload.image("/assets/img/mission_background.jpg", "mission_background", "image");
    Gotham.Preload.image("/assets/img/iron_button.jpg", "iron_button", "image");
    Gotham.Preload.image("/assets/img/mission_spacer.png", "mission_spacer", "image");
    Gotham.Preload.image("/assets/img/mission_item.png", "mission_item", "image");
    Gotham.Preload.image("/assets/img/user_management_frame.png", "mission_frame", "image");
    Gotham.Preload.image("/assets/img/node_details.png", "node_details", "image");
    Gotham.Preload.image("/assets/img/map_marker.png", "map_marker", "image");
    Gotham.Preload.image("/assets/img/map_marker_deactivated.png", "map_marker_deactivated", "image");
    Gotham.Preload.json("/assets/json/json.json", "map");
    Gotham.Preload.image("/assets/img/sea_background.png", "sea_background", "image");
    Gotham.Preload.image("/assets/img/sun.png", "sun", "image");
    Gotham.Preload.image("/assets/img/bottomBar.png", "bottomBar", "image");
    Gotham.Preload.image("/assets/img/sidebar.png", "sidebar", "image");
    Gotham.Preload.image("/assets/img/topbar.png", "topBar", "image");
    Gotham.Preload.image("/assets/img/home.png", "home", "image");
    Gotham.Preload.image("/assets/img/mission.png", "mission", "image");
    Gotham.Preload.image("/assets/img/menu.png", "menu", "image");
    Gotham.Preload.image("/assets/img/shop.png", "shop", "image");
    Gotham.Preload.image("/assets/img/settings.png", "settings", "image");
    Gotham.Preload.image("/assets/img/help.png", "help", "image");
    Gotham.Preload.image("/assets/img/attack.png", "attack", "image");
    Gotham.Preload.image("/assets/img/cable.png", "cable", "image");
    Gotham.Preload.image("/assets/img/user.png", "user", "image");
    Gotham.Preload.image("/assets/img/menu_button.png", "menu_button", "image");
    Gotham.Preload.image("/assets/img/menu_button_hover.png", "menu_button_hover", "image");
    Gotham.Preload.image("/assets/img/menu_background.jpg", "menu_background", "image");
    Gotham.Preload.image("/assets/img/menu_background2.jpg", "menu_background2", "image");
    Gotham.Preload.image("/assets/img/about_background.jpg", "about_background", "image");
    Gotham.Preload.mp3("./assets/audio/menu_theme.mp3", "menu_theme");
    Gotham.Preload.mp3("./assets/audio/button_click_1.mp3", "button_click_1");
    Gotham.Preload.image("/assets/img/settings_background.jpg", "settings_background", "image");
    Gotham.Preload.image("/assets/img/settings_close.png", "settings_close", "image");
    Gotham.Preload.image("/assets/img/slider_background.png", "slider_background", "image");
    Gotham.Preload.image("/assets/img/nodelist_background.jpg", "nodelist_background", "image");
    return Gotham.Preload.image("/assets/img/terminal_background.png", "terminal_background", "image");
  },
  networkPreload: function() {
    var socket;
    socket = GothamGame.Network;
    Gotham.Preload.network("GetNodes", Gotham.Database.table("node"), socket);
    Gotham.Preload.network("GetCables", Gotham.Database.table("cable"), socket);
    Gotham.Preload.network("GetUser", Gotham.Database.table("user"), socket);
    return Gotham.Preload.network("GetMission", Gotham.Database.table("mission"), socket);
  },
  startGame: function() {
    var scene_Menu, scene_World;
    scene_World = new GothamGame.Scenes.World(0xffffff, true);
    scene_Menu = new GothamGame.Scenes.Menu(0x000000, true);
    GothamGame.Renderer.addScene("World", scene_World);
    GothamGame.Renderer.addScene("Menu", scene_Menu);
    scene_Menu.documentContainer.addChild(GothamGame.Renderer.getScene("Loading").documentContainer);
    return GothamGame.Renderer.setScene("Menu");
  },
  startNetwork: function(callback) {
    GothamGame.Network = new Gotham.Network(location.hostname, 8081);
    GothamGame.Network.connect();
    console.log("Connecting to " + location.hostname + ":8081 ...");
    GothamGame.Network.onConnect = function() {
      console.log("Connected!");
      return callback(GothamGame.Network);
    };
    GothamGame.Network.onReconnecting = function() {
      return console.log("Attempting to reconnect");
    };
    GothamGame.Network.onReconnect = function() {
      GothamGame.Network.Socket.emit('ReconnectLogin', {
        "username": "per",
        "password": "per"
      });
      return console.log("Reconnected!");
    };
  }
};

setup.preloadFonts(function() {
  return setup.startNetwork(function() {
    setup.preload();
    GothamGame.Network.Socket.emit('Login', {
      "username": "per",
      "password": "per"
    });
    return GothamGame.Network.Socket.on('Login', function(reply) {
      if (reply.status === 200) {
        return setup.networkPreload();
      }
    });
  });
});

scene_Loading = new GothamGame.Scenes.Loading(0x3490CF, true);

GothamGame.Renderer.addScene("Loading", scene_Loading);

GothamGame.Renderer.setScene("Loading");

Gotham.Preload.onLoad = function(source, type, name, percent) {
  return scene_Loading.addAsset(name, type, Math.round(percent));
};

Gotham.Preload.onComplete = function() {
  console.log("Preload: Complete.. Starting Game");
  if (!setup.started) {
    setup.startGame();
  }
  return setup.started = true;
};


},{"../../GameFramework/src/Gotham.coffee":7,"./GothamGame.coffee":34,"./dependencies/jquery-ui.min":35,"./dependencies/moment.min":36}],54:[function(require,module,exports){
var AnnounceController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/AnnounceView.coffee');


/**
 * AnnounceController, This controller handles the Announcement which turn up on middle of the screen. Used in Mission for example
 * @class AnnounceController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

AnnounceController = (function(_super) {
  __extends(AnnounceController, _super);

  function AnnounceController(name) {
    AnnounceController.__super__.constructor.call(this, View, name);
    this.isWaiting = false;
    this.messageQueue = [];
  }

  AnnounceController.prototype.create = function() {
    this.queue();
    return this.networkMessages();
  };

  AnnounceController.prototype.networkMessages = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('ANNOUNCE', function(data) {
      return that.message(data.message, data.type, 40);
    });
  };

  AnnounceController.prototype.message = function(message, type, size) {
    var color, container, stroke;
    size = !size ? "100" : size;
    type = !type ? "NORMAL" : type;
    color = null;
    stroke = null;
    if (type === "NORMAL") {
      color = "#FFFFFF";
      stroke = "#000000";
    } else if (type === "ERROR") {
      color = "#FF0000";
      stroke = "#000000";
    } else if (type === "MISSION") {
      color = "#004600";
      stroke = "#FFFFFF";
    } else {
      color = "#000000";
    }
    message = new Gotham.Graphics.Text(message, {
      font: "bold " + size + "px calibri",
      stroke: stroke,
      strokeThickness: 4,
      fill: color,
      align: "center",
      dropShadow: true
    });
    message.x = 1920 / 2;
    message.y = 1080 / 6;
    message.anchor = {
      x: 0.5,
      y: 0.5
    };
    message.alpha = 1;
    message.visible = true;
    container = new Gotham.Graphics.Graphics();
    container.beginFill("#000000", 0.5);
    container.drawRect((1920 / 2) - (message.width / 2), (1080 / 6) - (message.height / 2), message.width, message.height);
    container.addChild(message);
    return this.messageQueue.push(container);
  };

  AnnounceController.prototype.queue = function() {
    var id, that;
    that = this;
    return id = setInterval((function() {
      var message;
      if (that.messageQueue.length > 0) {
        if (!that.isWaiting) {
          that.isWaiting = true;
          message = that.messageQueue.shift();
          that.View.startMessage(message, function() {
            that.isWaiting = false;
            return that.queue();
          });
          return clearInterval(id);
        }
      }
    }), 200);
  };

  return AnnounceController;

})(Gotham.Pattern.MVC.Controller);

module.exports = AnnounceController;


},{"../View/AnnounceView.coffee":66}],55:[function(require,module,exports){
var BarController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/BarView.coffee');


/**
 * Bar Controller keeps track of all menus is the World Scene. Left, Top, Right, Bottom bar.
 * @class BarController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

BarController = (function(_super) {
  __extends(BarController, _super);

  function BarController(name) {
    BarController.__super__.constructor.call(this, View, name);
  }

  BarController.prototype.create = function() {
    this.topBar();
    this.sideBarLeft();
    return this.sideBarRight();
  };

  BarController.prototype.topBar = function() {
    var that, world_clock;
    that = this;
    this.coordText = null;
    this.countryText = null;
    this.View.addItem(this.View.Bar.Top, "LEFT", function() {
      that.coordText = new Gotham.Controls.Button("Lat: 0\nLng: 0", 100, 70, {
        alpha: 0
      });
      return that.coordText;
    });
    this.View.addItem(this.View.Bar.Top, "LEFT", function() {
      that.countryText = new Gotham.Controls.Button("Country: None", 100, 70, {
        margin: 50,
        alpha: 0
      });
      return that.countryText;
    });
    world_clock = this.View.addItem(this.View.Bar.Top, "RIGHT", function() {
      that.clockText = new Gotham.Controls.Button("[WORLD_CLOCK]", 100, 70, {
        offset: -10,
        alpha: 0
      });
      return that.clockText;
    });
    return GothamGame.Network.Socket.on('World_Clock', function(data) {
      return world_clock.label.text = data.text;
    });
  };

  BarController.prototype.sideBarRight = function() {
    var that;
    that = this;
    this.View.addSidebarItem("RIGHT", 15, function() {
      var home;
      home = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("attack", "image"));
      home.tint = 0x4169E1;
      home.alpha = 0.4;
      home.interactive = true;
      home.mouseover = function() {
        return home.alpha = 1;
      };
      home.mouseout = function() {
        return home.alpha = 0.6;
      };
      home.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          GothamGame.Globals.showAttacks = true;
          return home.tint = 0xFF0000;
        } else {
          GothamGame.Globals.showAttacks = false;
          return home.tint = 0x4169E1;
        }
      };
      home.click();
      return home;
    });
    return this.View.addSidebarItem("RIGHT", 15, function() {
      var home;
      home = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("cable", "image"));
      home.tint = 0x4169E1;
      home.alpha = 0.4;
      home.interactive = true;
      home.mouseover = function() {
        return home.alpha = 1;
      };
      home.mouseout = function() {
        return home.alpha = 0.6;
      };
      home.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          GothamGame.Globals.showCables = true;
          that.scene.getObject("WorldMap").View.setCableVisibility(GothamGame.Globals.showCables);
          return home.tint = 0xFF0000;
        } else {
          GothamGame.Globals.showCables = false;
          that.scene.getObject("WorldMap").View.setCableVisibility(GothamGame.Globals.showCables);
          return home.tint = 0x4169E1;
        }
      };
      return home;
    });
  };

  BarController.prototype.closeAll = function(src) {
    var that;
    that = this;
    if (src !== that.home) {
      that.home.tint = 0x4169E1;
      that.home.toggle = false;
      that.scene.getObject("Identity").hide();
    }
    if (src !== that.user) {
      that.user.tint = 0x4169E1;
      that.user.toggle = false;
      that.scene.getObject("User").hide();
    }
    if (src !== that.mission) {
      that.mission.tint = 0x4169E1;
      that.mission.toggle = false;
      that.scene.getObject("Mission").hide();
    }
    if (src !== that.shop) {
      that.shop.tint = 0x4169E1;
      that.shop.toggle = false;
      that.scene.getObject("Shop").hide();
    }
    if (src !== that.help) {
      that.help.tint = 0x4169E1;
      that.help.toggle = false;
      that.scene.getObject("Help").hide();
      return GothamGame.Globals.canWheelScroll = true;
    }
  };

  BarController.prototype.sideBarLeft = function() {
    var that;
    that = this;
    this.View.addSidebarItem("LEFT", 15, function() {
      var home;
      that.home = home = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("home", "image"));
      home.tint = 0x4169E1;
      home.alpha = 0.4;
      home.interactive = true;
      home.mouseover = function() {
        return home.alpha = 1;
      };
      home.mouseout = function() {
        return home.alpha = 0.6;
      };
      home.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          that.closeAll(this);
          that.scene.getObject("Identity").show();
          that.scene.getObject("Identity").View.bringToFront();
          return home.tint = 0xFF0000;
        } else {
          that.scene.getObject("Identity").hide();
          return home.tint = 0x4169E1;
        }
      };
      return home;
    });
    this.View.addSidebarItem("LEFT", 15, function() {
      var user;
      that.user = user = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user", "image"));
      user.tint = 0x4169E1;
      user.alpha = 0.4;
      user.interactive = true;
      user.mouseover = function() {
        return user.alpha = 1;
      };
      user.mouseout = function() {
        return user.alpha = 0.6;
      };
      user.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          that.closeAll(this);
          that.scene.getObject("User").show();
          that.scene.getObject("User").View.bringToFront();
          return user.tint = 0xFF0000;
        } else {
          that.scene.getObject("User").hide();
          return user.tint = 0x4169E1;
        }
      };
      return user;
    });
    this.View.addSidebarItem("LEFT", 15, function() {
      var shop;
      that.shop = shop = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("shop", "image"));
      shop.tint = 0x4169E1;
      shop.alpha = 0.4;
      shop.interactive = true;
      shop.mouseover = function() {
        return this.alpha = 1;
      };
      shop.mouseout = function() {
        return this.alpha = 0.6;
      };
      shop.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          that.closeAll(this);
          that.scene.getObject("Shop").show();
          that.scene.getObject("Shop").View.bringToFront();
          return this.tint = 0xFF0000;
        } else {
          this.tint = 0x4169E1;
          return that.scene.getObject("Shop").hide();
        }
      };
      return shop;
    });
    this.View.addSidebarItem("LEFT", 15, function() {
      var mission;
      that.mission = mission = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("mission", "image"));
      mission.tint = 0x4169E1;
      mission.alpha = 0.4;
      mission.interactive = true;
      mission.mouseover = function() {
        return this.alpha = 1;
      };
      mission.mouseout = function() {
        return this.alpha = 0.6;
      };
      mission.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          that.closeAll(this);
          that.scene.getObject("Mission").show();
          that.scene.getObject("Mission").View.bringToFront();
          return this.tint = 0xFF0000;
        } else {
          that.scene.getObject("Mission").hide();
          return this.tint = 0x4169E1;
        }
      };
      return mission;
    });
    this.View.addSidebarItem("LEFT", 450, function() {
      var help;
      that.help = help = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("help", "image"));
      help.tint = 0x4169E1;
      help.alpha = 0.4;
      help.interactive = true;
      help.mouseover = function() {
        return this.alpha = 1;
      };
      help.mouseout = function() {
        return this.alpha = 0.6;
      };
      help.click = function() {
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          that.scene.getObject("Help").show();
          GothamGame.Globals.canWheelScroll = false;
          return this.tint = 0xFF0000;
        } else {
          that.scene.getObject("Help").hide();
          GothamGame.Globals.canWheelScroll = true;
          return this.tint = 0x4169E1;
        }
      };
      return help;
    });
    this.View.addSidebarItem("LEFT", 15, function() {
      var settings;
      settings = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("settings", "image"));
      settings.tint = 0x4169E1;
      settings.alpha = 0.4;
      settings.interactive = true;
      settings.mouseover = function() {
        return this.alpha = 1;
      };
      settings.mouseout = function() {
        return this.alpha = 0.6;
      };
      settings.click = function() {
        var Settings;
        this.toggle = !this.toggle ? true : !this.toggle;
        if (this.toggle) {
          Settings = new GothamGame.Controllers.Settings("Settings");
          that.scene.addObject(Settings);
          this._settings = Settings;
          return this.tint = 0xFF0000;
        } else {
          that.scene.removeObject(this._settings);
          return this.tint = 0x4169E1;
        }
      };
      return settings;
    });
    return this.View.addSidebarItem("LEFT", 15, function() {
      var menu;
      menu = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("menu", "image"));
      menu.tint = 0x4169E1;
      menu.alpha = 0.4;
      menu.interactive = true;
      menu.mouseover = function() {
        return this.alpha = 1;
      };
      menu.mouseout = function() {
        return this.alpha = 0.6;
      };
      menu.click = function() {
        return GothamGame.Renderer.setScene("Menu");
      };
      return menu;
    });
  };

  BarController.prototype.bottomBar = function() {};

  BarController.prototype.updateCoordinates = function(lat, long) {
    return this.coordText.label.text = "Lat: " + lat + "\nLng: " + long;
  };

  BarController.prototype.updateCountry = function(country) {
    var c;
    c = country ? country.name : "None";
    return this.countryText.label.text = "Country: " + c;
  };

  return BarController;

})(Gotham.Pattern.MVC.Controller);

module.exports = BarController;


},{"../View/BarView.coffee":67}],56:[function(require,module,exports){
var GothsharkController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/GothsharkView.coffee');


/**
 * GothsharkController is the data management of the Gothshark Application. This is a quite special controller, since gothshark is located inside index.html
 * @class GothsharkController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

GothsharkController = (function(_super) {
  __extends(GothsharkController, _super);

  function GothsharkController(name) {
    GothsharkController.__super__.constructor.call(this, View, name);
  }

  GothsharkController.prototype.create = function() {
    return this.setupPacketListener();
  };

  GothsharkController.prototype.setupPacketListener = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('Session', function(session) {
      var db_node, diff, diffData, i, layer, layerNum, node, nodeObject, packet, processedPacket, prop, template, val, _i, _j, _len, _ref, _ref1;
      db_node = Gotham.Database.table("node");
      template = session.layers;
      _ref = session.path;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        nodeObject = db_node.findOne({
          id: node
        });
        diffData = session.nodeHeaders[node];
        for (i = _j = 0, _ref1 = diffData.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          diff = diffData[i];
          packet = jQuery.extend({}, template);
          for (layerNum in diff) {
            layer = diff[layerNum];
            if (layerNum === "misc") {
              packet[layerNum] = layer;
              continue;
            }
            for (prop in layer) {
              val = layer[prop];
              packet[layerNum][prop] = val;
              packet["L7"] = {
                data: session.packets[i].data
              };
            }
          }
          processedPacket = that.processPacket(packet, nodeObject.packets.length + 1);
          nodeObject.packets.push(processedPacket);
        }
      }
      return that.redraw();
    });
  };


  /**
   * Redraws the node gothshark view with current node
   * @method redraw
   */

  GothsharkController.prototype.redraw = function() {
    if (this.currentNode) {
      return this.setNode(this.currentNode);
    }
  };

  GothsharkController.prototype.setNode = function(node) {
    var packet, _i, _len, _ref, _results;
    this.currentNode = node;
    this.View.clearTable();
    this.View.setNode({
      name: node.name,
      ip: node.Network.external_ip_v4
    });
    _ref = node.packets;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      packet = _ref[_i];
      _results.push(this.View.addPacket(packet));
    }
    return _results;
  };


  /**
   * Processed the packet information to a readable wireshark row
   * @method processPacket
   * @param packet {Object} The raw packet information
   * @param number {Number} Numbering
   */

  GothsharkController.prototype.processPacket = function(packet, number) {
    var processedPacket, type;
    processedPacket = {
      number: null,
      time: null,
      source: null,
      dest: null,
      protocol: null,
      length: null,
      info: null
    };
    if (packet.L3.type === "ICMP") {
      if (packet.L3.code === "0") {
        type = "Echo (ping) Reply";
      } else if (packet.L3.code === "8") {
        type = "Echo (ping) Request";
      }
      processedPacket["length"] = 74;
      processedPacket.info = "" + type + "   src=" + packet.L2.sourceMAC + " dest=" + packet.L2.destMAC + " ttl=" + packet.L3.ttl;
    }
    processedPacket.number = "" + number;
    processedPacket.time = packet.misc.time;
    processedPacket.source = "" + packet.L3.sourceIP;
    processedPacket.dest = "" + packet.L3.destIP;
    processedPacket.protocol = "" + packet.L3.type;
    return processedPacket;
  };

  return GothsharkController;

})(Gotham.Pattern.MVC.Controller);

module.exports = GothsharkController;


},{"../View/GothsharkView.coffee":68}],57:[function(require,module,exports){
var HelpController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/HelpView.coffee');


/**
 * Manage data for the HelpView
 * @class HelpController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

HelpController = (function(_super) {
  __extends(HelpController, _super);

  function HelpController(name) {
    HelpController.__super__.constructor.call(this, View, name);
  }

  HelpController.prototype.create = function() {
    var that;
    this.hide();
    that = this;
    GothamGame.Network.Socket.emit('GetHelpContent', {});
    return GothamGame.Network.Socket.on('GetHelpContent', function(data) {
      var category, child, childrenContainer, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        category = data[_i];
        childrenContainer = that.View.addCategory(category, null);
        if (category.Children.length > 0) {
          _results.push((function() {
            var _j, _len1, _ref, _results1;
            _ref = category.Children;
            _results1 = [];
            for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
              child = _ref[_j];
              _results1.push(that.View.addCategory(child, childrenContainer));
            }
            return _results1;
          })());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  };

  HelpController.prototype.show = function() {
    return this.View.show();
  };

  HelpController.prototype.hide = function() {
    return this.View.hide();
  };

  return HelpController;

})(Gotham.Pattern.MVC.Controller);

module.exports = HelpController;


},{"../View/HelpView.coffee":69}],58:[function(require,module,exports){
var IdentityController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/IdentityView.coffee');


/**
 * IdentityController, This controller manages data for the Identity + Host/Network view.
 * @class IdentityController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

IdentityController = (function(_super) {
  __extends(IdentityController, _super);

  function IdentityController(name) {
    IdentityController.__super__.constructor.call(this, View, name);
  }

  IdentityController.prototype.create = function() {
    this.setupIdentities();
    this.setupHosts();
    this.emitNetwork();
    this.emitHost();
    return this.View.hide();
  };

  IdentityController.prototype.setupIdentities = function() {
    var db_user, identities, identity, _i, _len, _results;
    db_user = Gotham.Database.table("user");
    identities = db_user.data[0].Identities;
    _results = [];
    for (_i = 0, _len = identities.length; _i < _len; _i++) {
      identity = identities[_i];
      identity = jQuery.extend({}, identity);
      delete identity.id;
      delete identity.fk_user;
      delete identity.Networks;
      delete identity.lat;
      delete identity.lng;
      _results.push(this.View.addIdentity(identity));
    }
    return _results;
  };


  /**
   * Emits for when Networks has been updated. For example a purchase
   * @method emitNetwork
   */

  IdentityController.prototype.emitNetwork = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('NetworkPurchaseUpdate', function(network) {
      return that.View.addNetwork(network);
    });
  };


  /**
   * Emits for when A host has been purchased,
   * @method emitHost
   */

  IdentityController.prototype.emitHost = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('HostPurchaseUpdate', function(host) {
      var sprite;
      sprite = that.View.addHost(host.Network, host);
      that.createTerminal(sprite, host, host.Network, host.Identity);
      return that.View.redraw();
    });
  };

  IdentityController.prototype.setupHosts = function() {
    var db_user, host, identities, identity, network, sprite, _i, _j, _k, _len, _len1, _len2, _ref, _ref1;
    db_user = Gotham.Database.table("user");
    identities = db_user.data[0].Identities;
    for (_i = 0, _len = identities.length; _i < _len; _i++) {
      identity = identities[_i];
      _ref = identity.Networks;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        network = _ref[_j];
        this.View.addNetwork(network);
        _ref1 = network.Hosts;
        for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
          host = _ref1[_k];
          sprite = this.View.addHost(network, host);
          this.createTerminal(sprite, host, network, identity);
        }
      }
    }
    return this.View.redraw();
  };

  IdentityController.prototype.createTerminal = function(sprite, host, network, identity) {
    var terminal, that;
    that = this;
    terminal = new GothamGame.Controllers.Terminal("Terminal_" + host.ip);
    terminal.View.create();
    terminal.setIdentity(identity);
    terminal.setHost(host);
    terminal.setNetwork(network);
    terminal.create();
    sprite.terminal = terminal;
    sprite.click = function() {
      var toggled;
      toggled = this.terminal.toggle();
      if (toggled) {
        return that.scene.getObject("Bar").closeAll(null);
      }
    };
    sprite.mouseout = function() {
      return this.tint = 0xffffff;
    };
    return sprite.mouseover = function() {
      return this.tint = 0xff0000;
    };
  };

  IdentityController.prototype.show = function() {
    return this.View.show();
  };

  IdentityController.prototype.hide = function() {
    return this.View.hide();
  };

  return IdentityController;

})(Gotham.Pattern.MVC.Controller);

module.exports = IdentityController;


},{"../View/IdentityView.coffee":70}],59:[function(require,module,exports){
var MissionController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/MissionView.coffee');


/**
 * MissionController, This controller manages all Mission related data. This beeing the emitter from Backend and adding Missions to the view.
 * @class MissionController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

MissionController = (function(_super) {
  __extends(MissionController, _super);

  function MissionController(name) {
    MissionController.__super__.constructor.call(this, View, name);
  }

  MissionController.prototype.create = function() {
    this.setupMissions();
    this.setupMissionEmitter();
    return this.hide();
  };

  MissionController.prototype.setupMissionEmitter = function() {
    var that;
    that = this;
    GothamGame.Network.Socket.on('AcceptMission', function(mission) {
      var elements, _m, _mission;
      _mission = mission.Mission;
      _mission.userMissionId = mission.id;
      _mission.UserMissionRequirements = mission.UserMissionRequirements;
      _m = GothamGame.MissionEngine.createMission(_mission);
      _m.setOngoing(true);
      _m.onRequirementComplete = _m.onProgress = function(requirement) {
        return GothamGame.Network.Socket.emit('ProgressMission', {
          userMissionRequirement: requirement.userMissionRequirementData.id,
          current: requirement._current
        });
      };
      GothamGame.MissionEngine.addMission(_m);
      that.View.removeAvailableMission(_m);
      elements = that.View.addOngoingMission(_m);
      return _m.onComplete = function(mission) {
        elements.journal.abandonButton.visible = false;
        elements.journal.completeMissionButton.visible = true;
        return elements.missionTitle.text = elements.missionTitle.text + " (Complete)";
      };
    });
    GothamGame.Network.Socket.on('AbandonMission', function(mission) {
      var _m;
      _m = GothamGame.MissionEngine.createMission(mission);
      GothamGame.MissionEngine.removeMission(_m);
      that.View.addAvailableMission(_m);
      return that.View.removeOngoingMission(_m);
    });
    return GothamGame.Network.Socket.on('CompleteMission', function(mission) {
      var _m;
      _m = GothamGame.MissionEngine.createMission(mission);
      GothamGame.MissionEngine.removeMission(_m);
      that.View.addAvailableMission(_m);
      return that.View.removeOngoingMission(_m);
    });
  };

  MissionController.prototype.setupMissions = function() {
    var allMissions, db_mission, elements, mission, missions, userMissionId, _i, _j, _k, _len, _len1, _len2, _m, _ref, _ref1, _results;
    db_mission = Gotham.Database.table("mission");
    allMissions = db_mission.data[0];
    missions = [];
    _ref = allMissions.available;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _m = _ref[_i];
      _m.ongoing = false;
      missions.push(_m);
    }
    _ref1 = allMissions.ongoing;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      _m = _ref1[_j];
      _m["Mission"]["UserMissionRequirements"] = _m["UserMissionRequirements"];
      userMissionId = _m.id;
      _m = _m["Mission"];
      _m.userMissionId = userMissionId;
      _m.ongoing = true;
      missions.push(_m);
    }
    _results = [];
    for (_k = 0, _len2 = missions.length; _k < _len2; _k++) {
      mission = missions[_k];
      _m = GothamGame.MissionEngine.createMission(mission);
      _m.setOngoing(mission.ongoing);
      _m.onRequirementComplete = _m.onProgress = function(requirement) {
        return GothamGame.Network.Socket.emit('ProgressMission', {
          userMissionRequirement: requirement.userMissionRequirementData.id,
          current: requirement._current
        });
      };
      _m.updateState();
      if (mission.ongoing) {
        GothamGame.MissionEngine.addMission(_m);
        elements = this.View.addOngoingMission(_m);
      } else {
        elements = this.View.addAvailableMission(_m);
      }
      _results.push(_m.onComplete = function(mission) {
        elements.journal.abandonButton.visible = false;
        elements.journal.completeMissionButton.visible = true;
        return elements.missionTitle.text = elements.missionTitle.text + " (Complete)";
      });
    }
    return _results;
  };

  MissionController.prototype.show = function() {
    return this.View.visible = true;
  };

  MissionController.prototype.hide = function() {
    return this.View.visible = false;
  };

  MissionController.prototype.updateView = function() {
    return this.View.updateStats();
  };

  return MissionController;

})(Gotham.Pattern.MVC.Controller);

module.exports = MissionController;


},{"../View/MissionView.coffee":71}],60:[function(require,module,exports){
var NodeListController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/NodeListView.coffee');


/**
 * NodeListController, Manages the NodeList data. Mainly only adding nodes to the list.
 * @class NodeListController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

NodeListController = (function(_super) {
  __extends(NodeListController, _super);

  function NodeListController(name) {
    NodeListController.__super__.constructor.call(this, View, name);
    this.hide();
  }

  NodeListController.prototype.create = function() {};

  NodeListController.prototype.show = function() {
    return this.View.visible = true;
  };

  NodeListController.prototype.hide = function() {
    return this.View.visible = false;
  };

  return NodeListController;

})(Gotham.Pattern.MVC.Controller);

module.exports = NodeListController;


},{"../View/NodeListView.coffee":72}],61:[function(require,module,exports){
var SettingsController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/SettingsView.coffee');


/**
 * SettingsController, This controller does basically nothing. But in the future should hold different Game settings
 * @class SettingsController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

SettingsController = (function(_super) {
  __extends(SettingsController, _super);

  function SettingsController(name) {
    SettingsController.__super__.constructor.call(this, View, name);
  }

  SettingsController.prototype.create = function() {};

  return SettingsController;

})(Gotham.Pattern.MVC.Controller);

module.exports = SettingsController;


},{"../View/SettingsView.coffee":73}],62:[function(require,module,exports){
var ShopController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/ShopView.coffee');


/**
 * Controller which manages network purchase etc.
 * @class ShopController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

ShopController = (function(_super) {
  __extends(ShopController, _super);

  function ShopController(name) {
    ShopController.__super__.constructor.call(this, View, name);
    this.hide();
  }

  ShopController.prototype.create = function() {
    var hostButton, hostPurchase, networkButton, networkPurchase;
    networkPurchase = false;
    hostPurchase = false;
    networkButton = null;
    hostButton = null;
    this.View.createCategory("Network", "- Purchase by clicking X then on a node on the map", 300, "500", function(src, state) {
      networkPurchase = state;
      networkButton = src;
      if (state) {
        return GothamGame.Announce.message("Click on a node to complete the purchase", "NORMAL", 50);
      }
    });
    this.View.createCategory("Host", "- Purchase by clicking X then on a network", 500, "500", function(src, state) {
      hostPurchase = state;
      hostButton = src;
      if (state) {
        return GothamGame.Announce.message("Click on a network to complete the purchase", "NORMAL", 50);
      }
    });
    this.scene.getObject("Identity").View.shopOnNetworkClick = function(network) {
      if (hostPurchase) {
        hostButton.click();
        return GothamGame.Network.Socket.emit('ShopPurchaseHost', {
          id: network.id
        });
      }
    };
    this.scene.getObject("WorldMap").View.shopOnNodeClick = function(node) {
      if (networkPurchase) {
        networkButton.click();
        return GothamGame.Network.Socket.emit('ShopPurchaseNetwork', {
          id: node.id
        });
      }
    };
    GothamGame.Network.Socket.on('ShopPurchaseHost_Complete', function(data) {
      return GothamGame.Announce.message("A host was successfully purchased!", "NORMAL", 50);
    });
    return GothamGame.Network.Socket.on('ShopPurchaseNetwork_Complete', function(data) {
      return GothamGame.Announce.message("A network was successfully purchased!", "NORMAL", 50);
    });
  };

  ShopController.prototype.show = function() {
    return this.View.show();
  };

  ShopController.prototype.hide = function() {
    return this.View.hide();
  };

  return ShopController;

})(Gotham.Pattern.MVC.Controller);

module.exports = ShopController;


},{"../View/ShopView.coffee":74}],63:[function(require,module,exports){
var TerminalController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __modulo = function(a, b) { return (a % b + +b) % b; };

View = require('../View/TerminalView.coffee');


/**
 * This class keeps track of the terminal data + redrawing of the terminal.
 * @class TerminalController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

TerminalController = (function(_super) {
  __extends(TerminalController, _super);

  TerminalController.KEYCODE = {
    TAB: 9,
    ENTER: 13,
    ARROW_UP: 38,
    ARROW_DOWN: 40
  };

  function TerminalController(name) {
    TerminalController.__super__.constructor.call(this, View, name);
    this.data = void 0;
    this.filesystem = void 0;
    this.console = void 0;
    this.host = void 0;
    this.identity = void 0;
    this.Network = void 0;
  }

  TerminalController.prototype.create = function() {
    var that;
    that = this;
    this.console = new GothamGame.Terminal.Console();
    this.console.redraw = function() {
      return that.View.redraw();
    };
    this.View.setConsole(this.console);
    this.filesystem = new GothamGame.Terminal.Filesystem(this.host.Filesystem);
    this.filesystem.onError = function(error) {
      return that.console.add(error);
    };
    this.setupInput();
    return this.boot();
  };

  TerminalController.prototype.setupInput = function() {
    var arrow, enter, input, tab, that;
    that = this;
    input = this.View._input;
    "###\n### Tab action\n###";
    tab = function(e, inputField) {
      var child, command, ext, files, output, _i, _len;
      e.preventDefault();
      that.__tabCount = !that.__tabCount ? 0 : that.__tabCount;
      that.__tabCount = __modulo(that.__tabCount + 1, 2);
      input = $(inputField).val();
      command = new GothamGame.Terminal.Command(that, input);
      if (!command.isCommand()) {
        return;
      }
      if (that.__tabCount !== 1) {
        return;
      }
      files = that.filesystem.findFiles(command["arguments"]);
      output = "";
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        child = files[_i];
        ext = child.extension !== "dir" ? "." + child.extension : "";
        child.fullname = "" + child.name + ext;
        output += "" + child.fullname + "    ";
      }
      if (files.length === 1) {
        return $(inputField).val("" + command.command + " " + files[0].fullname);
      } else if (files.length > 1) {
        that.console.add(output);
        return that.console.redraw();
      }
    };
    enter = function(e, obj) {
      var val;
      val = $(obj).val();
      $(obj).val("");
      return that.parseInput(val);
    };
    arrow = function(e, obj) {
      var historyItem, historyPointer, isUp, text;
      isUp = e.which === TerminalController.KEYCODE.ARROW_UP;
      historyPointer = isUp ? that.console.incrementHistoryPointer(-1) : that.console.incrementHistoryPointer(1);
      historyItem = that.console.getHistoryAt(historyPointer);
      if (historyItem) {
        text = historyItem.command + " " + historyItem["arguments"].join(" ");
        return $(obj).val(text);
      }
    };
    return input.on('keydown', function(e) {
      var keycode;
      keycode = e.which;
      if (keycode === TerminalController.KEYCODE.ENTER) {
        enter(e, this);
      }
      if (keycode === TerminalController.KEYCODE.TAB) {
        tab(e, this);
      } else {
        that.__tabCount = 0;
      }
      if (keycode === TerminalController.KEYCODE.ARROW_UP || keycode === TerminalController.KEYCODE.ARROW_DOWN) {
        return arrow(e, this);
      }
    });
  };

  TerminalController.prototype.parseInput = function(input) {
    var command;
    command = new GothamGame.Terminal.Command(this, input);
    this.console.add("" + this.identity.first_name + "@" + this.host.machine_name + ":~# " + (command.getInput()));
    this.console.addHistory(command);
    if (!command.isCommand()) {
      return this.console.add("" + (command.getInput()) + ": command not found");
    } else {
      return command.execute();
    }
  };

  TerminalController.prototype.toggle = function() {
    if ($(this.View.terminal_frame).is(":visible")) {
      this.View.terminal_frame.hide();
      return false;
    } else {
      $(".terminal_frame").hide();
      this.View.terminal_frame.show();
      $(this.View.terminal_input_field).focus();
      return true;
    }
  };

  TerminalController.prototype.show = function() {
    $(".terminal_frame").hide();
    return this.View.terminal_frame.show();
  };

  TerminalController.prototype.hide = function() {
    return this.View.terminal_frame.hide();
  };

  TerminalController.prototype.setHost = function(host) {
    return this.host = host;
  };

  TerminalController.prototype.setIdentity = function(identity) {
    return this.identity = identity;
  };

  TerminalController.prototype.setNetwork = function(network) {
    return this.network = network;
  };

  TerminalController.prototype.boot = function() {
    this.console.addArray(["Welcome to GothOS 1.0 (GNU/Linux 3.16.0-23-generic x86_64)", "", " * Documentation:  https://help.gotham.no/", "", "  System information as of " + (new Date()), "", "  IP address for eth0: " + this.host.ip, "", "", "0 packages can be updated.", "0 updates are security updates.", "", "Last login: Fri Mar 20 17:09:49 2015 from grm-studby-128-39-148-43.studby.uia.no"]);
    return this.console.redraw();
  };

  return TerminalController;

})(Gotham.Pattern.MVC.Controller);

module.exports = TerminalController;


},{"../View/TerminalView.coffee":75}],64:[function(require,module,exports){
var UserController, View,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/UserView.coffee');


/**
 * Manages data which is to be drawn on the UserView
 * @class UserController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

UserController = (function(_super) {
  __extends(UserController, _super);

  function UserController(name) {
    UserController.__super__.constructor.call(this, View, name);
  }

  UserController.prototype.create = function() {
    return this.setupUser();
  };

  UserController.prototype.setupUser = function() {
    var db_user;
    db_user = Gotham.Database.table("user");
    return this.View.setUser(db_user.data[0]);
  };

  UserController.prototype.addMoney = function() {};

  UserController.prototype.show = function() {
    return this.View.show();
  };

  UserController.prototype.hide = function() {
    return this.View.hide();
  };

  return UserController;

})(Gotham.Pattern.MVC.Controller);

module.exports = UserController;


},{"../View/UserView.coffee":76}],65:[function(require,module,exports){
var View, WorldMapController,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('../View/WorldMapView.coffee');


/**
 * World map controller manages all events inside the WorldMap. Hosts, Cables, Nodes, IPViking
 * @class WorldMapController
 * @module Frontend
 * @submodule Frontend.Controllers
 * @namespace GothamGame.Controllers
 * @constructor
 * @param name {String} Name of the Controller
 * @extends Gotham.Pattern.MVC.Controller
 */

WorldMapController = (function(_super) {
  __extends(WorldMapController, _super);

  function WorldMapController(name) {
    WorldMapController.__super__.constructor.call(this, View, name);
  }

  WorldMapController.prototype.create = function() {
    this.View.clearNodeContainer();
    this.createHost();
    this.createNodes();
    this.createCables();
    this.setupIPViking();
    this.emitNodeLoad();
    this.emitClock();
    return this.currentMinutes = 0;
  };

  WorldMapController.prototype.createNodes = function() {
    var db_node, node, start, that, _i, _len, _ref;
    that = this;
    start = new Date().getTime();
    db_node = Gotham.Database.table("node");
    _ref = db_node.find();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      node.packets = [];
      that.View.addNode(node, true);
    }
    return console.log("Process Nodes: " + (new Date().getTime() - start) + "ms");
  };

  WorldMapController.prototype.createCables = function() {
    var cable, db_cable, start, that, _i, _len, _ref;
    that = this;
    db_cable = Gotham.Database.table("cable");
    start = new Date().getTime();
    _ref = db_cable.find();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cable = _ref[_i];
      that.View.addCable(cable);
    }
    return console.log("Process Cables: " + (new Date().getTime() - start) + "ms");
  };

  WorldMapController.prototype.createHost = function() {
    var db_user, identity, network, that, user, _i, _j, _len, _len1, _ref, _ref1;
    that = this;
    GothamGame.Network.Socket.on('NetworkPurchaseUpdate', function(network) {
      var gNetworkNode;
      gNetworkNode = that.View.addNetwork(network);
      return gNetworkNode.bringToBack();
    });
    db_user = Gotham.Database.table('user');
    user = db_user.find()[0];
    _ref = user.Identities;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      identity = _ref[_i];
      _ref1 = identity.Networks;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        network = _ref1[_j];
        this.View.addNetwork(network);
      }
    }
  };


  /**
   * Create a emit listener NodeLoad
   * This stream is relayed from main server
   * Emitter: NodeLoadUpdate
   * @method emitNodeLoad
   */

  WorldMapController.prototype.emitNodeLoad = function() {
    var db_node, that;
    that = this;
    db_node = Gotham.Database.table("node");
    return GothamGame.Network.Socket.on('NodeLoadUpdate', function(json) {
      var id, load, node, nowthen, utc, _results;
      _results = [];
      for (id in json) {
        load = json[id];
        node = db_node.findOne({
          id: parseInt(id)
        });
        node.time = ((node.lng + 180) / 0.25) + that.currentMinutes;
        node.loadColor = GothamGame.Tools.ColorUtil.getColorForPercentage(load);
        if (node.sprite.infoFrame) {
          node.sprite.infoFrame.nodeLoad.text = "Load: " + ((load * 100).toFixed(2));
        }
        utc = moment().utcOffset('+0000');
        utc.subtract(utc.hours(), "hours");
        utc.minutes(utc.minutes(), "minutes");
        utc.add(12, 'hours');
        nowthen = utc.add(node.time, "minutes");
        if (node.sprite.infoFrame) {
          node.sprite.infoFrame.nodeTime.text = "Time: " + (nowthen.format('H:mm'));
        }
        _results.push(node.sprite.tint = node.loadColor);
      }
      return _results;
    });
  };


  /**
   * Create a emit for World Clock
   * @method emitClock
   */

  WorldMapController.prototype.emitClock = function() {
    var maxTime, that;
    that = this;
    maxTime = 1440;
    return GothamGame.Network.Socket.on('World_Clock', function(data) {
      var current, position;
      that.currentMinutes = data.minutes;
      current = ((data.minutes / maxTime) * (180 * 2) - 180) * -1;
      position = that.View.coordinateToPixel(10, current);
      that.View.sun.visible = true;
      return that.View.sun.x = position.x;
    });
  };

  WorldMapController.prototype.setupIPViking = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('IPViking_Attack', function(json) {
      var attack, source, target;
      attack = JSON.parse(json);
      source = {
        latitude: attack.latitude,
        longitude: attack.longitude,
        country: attack.countrycode,
        org: attack.org
      };
      target = {
        latitude: attack.latitude2,
        longitude: attack.longitude2,
        country: attack.countrycode2,
        city2: attack.city2
      };
      if (Gotham.Running && GothamGame.Globals.showAttacks === true) {
        return that.View.animateAttack(source, target);
      }
    });
  };

  return WorldMapController;

})(Gotham.Pattern.MVC.Controller);

module.exports = WorldMapController;


},{"../View/WorldMapView.coffee":77}],66:[function(require,module,exports){

/**
 * View for the announcement messages
 * @class AnnounceView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var AnnounceView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

AnnounceView = (function(_super) {
  __extends(AnnounceView, _super);

  function AnnounceView() {
    AnnounceView.__super__.constructor.apply(this, arguments);
  }

  AnnounceView.prototype.create = function() {};

  AnnounceView.prototype.startMessage = function(text, callback) {
    var that, tween;
    that = this;
    this.bringToFront();
    this.addChild(text);
    tween = new Gotham.Tween(text);
    tween.delay(2000);
    tween.to({
      alpha: 0
    }, 1000);
    tween.onComplete(function() {
      that.removeChild(text);
      return callback();
    });
    return tween.start();
  };

  return AnnounceView;

})(Gotham.Pattern.MVC.View);

module.exports = AnnounceView;


},{}],67:[function(require,module,exports){

/**
 * View for the Bars
 * @class BarView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var BarView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BarView = (function(_super) {
  __extends(BarView, _super);

  BarView.prototype.Bar = {
    Top: void 0,
    Bottom: void 0,
    Side: {
      Left: void 0,
      Right: void 0
    }
  };

  function BarView() {
    BarView.__super__.constructor.apply(this, arguments);
  }

  BarView.prototype.create = function() {
    this.create_topBar();
    return this.create_sideBars();
  };

  BarView.prototype.create_sideBars = function() {
    var texture_side_left, texture_side_right;
    texture_side_left = Gotham.Preload.fetch("sidebar", "image");
    this.Bar.Side.Left = new Gotham.Graphics.Sprite(texture_side_left);
    this.Bar.Side.Left.y = 80;
    this.Bar.Side.Left.x = 10;
    this.Bar.Side.Left.width = 70;
    this.Bar.Side.Left.height = 1080;
    this.addChild(this.Bar.Side.Left);
    texture_side_right = Gotham.Preload.fetch("sidebar", "image");
    this.Bar.Side.Right = new Gotham.Graphics.Sprite(texture_side_right);
    this.Bar.Side.Right.y = 80;
    this.Bar.Side.Right.x = 1920 - 80;
    this.Bar.Side.Right.width = 70;
    this.Bar.Side.Right.height = 1080;
    return this.addChild(this.Bar.Side.Right);
  };

  BarView.prototype.create_topBar = function() {
    var texture_topBar, topBar;
    texture_topBar = Gotham.Preload.fetch("topBar", "image");
    this.Bar.Top = topBar = new Gotham.Graphics.Sprite(texture_topBar);
    this.Bar.Top._left = [];
    this.Bar.Top._right = [];
    topBar.position.x = 0;
    topBar.position.y = 0;
    topBar.width = 1920;
    topBar.height = 70;
    return this.addChild(topBar);
  };

  BarView.prototype.createBottomBar = function() {
    var bottomBar, texture_bottomBar;
    texture_bottomBar = Gotham.Preload.fetch("bottomBar", "image");
    this.Bar.Bottom = bottomBar = new Gotham.Graphics.Sprite(texture_bottomBar);
    this.Bar.Bottom._left = [];
    this.Bar.Bottom._right = [];
    bottomBar.width = 1920;
    bottomBar.height = 70;
    bottomBar.position.x = 0;
    bottomBar.position.y = 1080 - bottomBar.height;
    return this.addChild(bottomBar);
  };

  BarView.prototype.addSidebarItem = function(side, margin, callback) {
    var bar, lastElement, newItem, _ch, _i, _len, _ref;
    if (side === "LEFT") {
      bar = this.Bar.Side.Left;
    } else if (side === "RIGHT") {
      bar = this.Bar.Side.Right;
    } else {
      throw new Error("adding To sidebar requires LEFT or RIGHT");
    }
    newItem = callback();
    lastElement = null;
    _ref = bar.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ch = _ref[_i];
      if (!lastElement) {
        lastElement = _ch;
        continue;
      }
      if (_ch.y > lastElement.y) {
        lastElement = _ch;
      }
    }
    if (!lastElement) {
      newItem.y = 10;
      bar.addChild(newItem);
      return;
    }
    newItem.y = lastElement.y + lastElement.height + margin;
    return bar.addChild(newItem);
  };

  BarView.prototype.addItem = function(bar, align, callback) {
    var child, childArray, lastElement, x;
    if (align === "LEFT") {
      childArray = bar._left;
      lastElement = childArray.last();
      child = callback();
      x = lastElement ? lastElement.x + lastElement.width + 5 : 0;
    } else if (align === "RIGHT") {
      childArray = bar._right;
      lastElement = childArray.last();
      child = callback();
      x = lastElement ? lastElement.x - lastElement.width - 5 : (bar.width / bar.scale.x) - child.width;
    } else {
      throw new Error("No Valid Alignment set in addItem");
    }
    bar.addChild(child);
    childArray.push(child);
    child.y = 0;
    child.x = x + child.margin;
    return child;
  };

  return BarView;

})(Gotham.Pattern.MVC.View);

module.exports = BarView;


},{}],68:[function(require,module,exports){

/**
 * View for gothsshark. This is empty as the View is actually located in the index.html (Because of Angular datababinding (TODO)
 * @class GothsharkView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var GothsharkView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

GothsharkView = (function(_super) {
  __extends(GothsharkView, _super);

  function GothsharkView() {
    GothsharkView.__super__.constructor.apply(this, arguments);
  }

  GothsharkView.prototype.create = function() {
    var table;
    this.gothshark_frame = $('<div\>', {
      id: "gothshark_frame",
      "class": "gothshark_frame",
      style: "background-color: whitesmoke;\nbackground-image: url('http://128.39.148.43:9001/assets/img/gothshark-logo.png');\nbackground-repeat: no-repeat;\nbackground-position: 50% 60%;\nposition: fixed;\ndisplay: none;\ntop: 47%;\nleft: 20%;\nwidth: 60%;\nheight: 52%;"
    });
    this.gothshark_frame.append("<div class=\"navbar navbar-default navbar-sm\">\n     <div class=\"navbar-header\"><a class=\"navbar-brand\" href=\"#\">GothShark</a>\n         <a class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\">\n             <span class=\"icon-bar\"></span>\n             <span class=\"icon-bar\"></span>\n             <span class=\"icon-bar\"></span>\n         </a>\n     </div>\n     <div class=\"navbar-collapse collapse\">\n         <ul class=\"nav navbar-nav\">\n             <li class=\"active\"><a href=\"#\">File</a></li>\n             <li><a href=\"#\">Edit</a></li>\n             <li><a href=\"#\">View</a></li>\n             <li><a href=\"#\">Help</a></li>\n         </ul>\n     </div>\n\n     <div class=\"navbar-collapse collapse table-striped\">\n\n         <form class=\"form-inline\">\n             <div class=\"form-group\" style=\"padding:2px;\">\n                 Filter:\n                 <input type=\"text\" class=\"form-control input-sm gothshark-filter\" style=\"border-radius:0px;\" id=\"filter\">\n                 | Node: <div id=\"node-name\" style=\"display: inline;\">A node name</div> | IP: <div id=\"node-ip\" style=\"display: inline;\">192.168.10.101</div>\n             </div>\n         </form>\n     </div>\n </div>\n <table class=\"table table-condensed gothshark-table\">\n     <thead>\n     <tr>\n         <td>No.</td>\n         <td>Time</td>\n         <td>Source</td>\n         <td>Destination</td>\n         <td>Protocol</td>\n         <td>Length</td>\n         <td>Info</td>\n     </tr>\n     </thead>\n\n     <tbody>\n\n     <tr class=\"info\">\n         <td>1388</td>\n         <td>2.05082800</td>\n         <td>192.168.1.18</td>\n         <td>128.39.149.110</td>\n         <td>UDP</td>\n         <td>1066</td>\n         <td>Source port: 62262  Destination port: 63446</td>\n     </tr>\n\n     <tr class=\"info\">\n         <td>1389</td>\n         <td>2.05082800</td>\n         <td>192.168.1.18</td>\n         <td>128.39.149.110</td>\n         <td>UDP</td>\n         <td>1066</td>\n         <td>Source port: 62262  Destination port: 63446</td>\n     </tr>\n     </tbody>\n </table>");
    $("#node-details").append(this.gothshark_frame);
    $(window).resize(function() {
      var newHeight;
      newHeight = $(this).height() * ($(".gothshark-table").height() / 100) + 20;
      return $(".dataTables_scrollBody").height(newHeight);
    });
    table = this.table = $(".gothshark-table").DataTable({
      "paging": false,
      "ordering": true,
      "info": false,
      bFilter: true,
      bInfo: false,
      "dom": "rtiS",
      "scrollY": "400px"
    });
    return $('.gothshark-filter').keyup(function() {
      table.search(this.value);
      return table.draw();
    });
  };


  /**
   * Adds a packet to the table,
   * @method addPacket
   * @param data {Object} The data object
   * @param data.number {Number} The packet number
   * @param data.time {String} The packet time (arrival)
   * @param data.source {String} The source address of the packet
   * @param data.dest {String} The destination address of the packet
   * @param data.protocol {String} The protocol of the packet (TCP, ICMP ,ect)
   * @param data.length {Number} Length in bytes of the packet
   * @param data.info {String} The information string
   */

  GothsharkView.prototype.addPacket = function(data) {
    return this.table.row.add([data.number, data.time, data.source, data.dest, data.protocol, data.length, data.info]).draw();
  };


  /**
   * Sets node data
   * @method setNode
   * @param data {Object} The node data
   * @param data.name {String} Name of the node
   * @param data.ip {String} IP of the node
   */

  GothsharkView.prototype.setNode = function(data) {
    $("#node-name").text(data.name);
    return $("#node-ip").text(data.ip);
  };


  /**
   * Clears the table data
   * @method clearTable
   */

  GothsharkView.prototype.clearTable = function() {
    this.table.clear();
    return this.table.draw();
  };

  return GothsharkView;

})(Gotham.Pattern.MVC.View);

module.exports = GothsharkView;


},{}],69:[function(require,module,exports){

/**
 * HelpView shows all help sections of the game.
 * @class HelpView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var HelpView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HelpView = (function(_super) {
  __extends(HelpView, _super);

  function HelpView() {
    return HelpView.__super__.constructor.apply(this, arguments);
  }


  /**
   * Adds a help category
   * @method addCategory
   * @param {Object} category
   * @returns {JQUERY-DIV} The resulting jquery child div
   */

  HelpView.prototype.addCategory = function(category, origSelector) {
    var childrenContainer, contentContainer, menuItem, selector, tabbed;
    selector = !origSelector ? $(this.helpMenu) : origSelector;
    tabbed = origSelector ? "padding-left: 40px;" : "";
    menuItem = $("<a/>", {
      "href": ".item-" + category.id,
      "data-toggle": "collapse",
      "text": category.title,
      "style": "" + tabbed,
      "class": "list-group-item squared help-menu-item"
    });
    childrenContainer = $("<div/>", {
      "class": "collapse item-" + category.id
    });
    contentContainer = $("<div/>", {
      "class": "help-content-item",
      "id": "content-" + category.id,
      "style": "display: none;"
    });
    $(contentContainer).html(category.text);
    $(menuItem).on("click", function() {
      $(".help-content-item").hide();
      return $(contentContainer).show();
    });
    selector.append(menuItem);
    selector.append(childrenContainer);
    $(this.helpContent).append(contentContainer);
    return childrenContainer;
  };

  HelpView.prototype.create = function() {
    var helpForm, helpTitle, innerContainer;
    helpForm = $("<div/>", {
      "class": "help-form",
      "style": "position: absolute; top: 20%; left:20%; width: 600px; height: 400px; background-color: #fdf5e8; box-shadow: 10px 10px 5px #000000; border: 1px solid black;"
    });
    innerContainer = $("<div/>", {
      "style": "height: 100%;"
    });
    this.helpMenu = $("<div/>", {
      "class": "col-sm-4 b-col help-menu",
      "style": "height: 100%; overflow-y: scroll; overflow-x: hidden; background-color: #FFFFFF; border-right: 1px solid #ddd; float: left; padding: 0;"
    });
    helpTitle = $("<div/>", {
      "class": "col-sm-7 help-title",
      "html": "<p>Help Central</p>",
      "style": "            height: 25px; text-align: center; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 24px; font-style: normal; font-variant: normal; font-weight: 500; line-height: 26.3999996185303px;"
    });
    this.helpContent = $("<div/>", {
      "class": "col-sm-7 help-content",
      "style": "padding: 10px; height: 90%; overflow: scroll;"
    });
    $("#help-section").append(helpForm);
    $(helpForm).append(innerContainer);
    $(innerContainer).append(this.helpMenu);
    $(innerContainer).append(helpTitle);
    return $(innerContainer).append(this.helpContent);
  };

  HelpView.prototype.show = function() {
    return $("#help-section").show();
  };

  HelpView.prototype.hide = function() {
    return $("#help-section").hide();
  };

  return HelpView;

})(Gotham.Pattern.MVC.View);

module.exports = HelpView;


},{}],70:[function(require,module,exports){

/**
 * View for the Identity + Host/Networks
 * @class IdentityView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var IdentityView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

IdentityView = (function(_super) {
  __extends(IdentityView, _super);

  function IdentityView() {
    IdentityView.__super__.constructor.apply(this, arguments);
    this.movable();
    this.click = function() {
      return this.bringToFront();
    };
    this.selectedIdentity = null;
    this.identityCount = 0;
    this.identityTextMapping = {};
    this.itemCount = 0;
    this.startY = 0;
    this.networks = {};
    this.shopOnNetworkClick = function() {};
  }

  IdentityView.prototype.create = function() {
    var window;
    window = this.createFrame();
    this.createTerminal(window);
    return this.createUserInfo(window);
  };

  IdentityView.prototype.show = function() {
    return this.window.visible = true;
  };

  IdentityView.prototype.hide = function() {
    return this.window.visible = false;
  };

  IdentityView.prototype.createFrame = function() {
    var frame, window, windowMask;
    window = this.window = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user_management_background", "image"));
    window.width = 800;
    window.height = 700;
    window.y = 1080 - 70 - 700;
    window.x = 400;
    window.interactive = true;
    window.mousemove = function(e) {};
    windowMask = new Gotham.Graphics.Graphics;
    windowMask.beginFill(0x000000, 1);
    windowMask.drawRect(0, 0, window.width / window.scale.x, window.height / window.scale.y);
    window.addChild(windowMask);
    window.mask = windowMask;
    frame = this.frame = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user_management_frame", "image"));
    frame.width = window.width / window.scale.x;
    frame.height = window.height / window.scale.y;
    window.addChild(frame);
    return this.addChild(window);
  };

  IdentityView.prototype.createTerminal = function(window) {
    var networkContainer, networkContainerMask, networkContainerTexture, that, title;
    that = this;
    title = new Gotham.Graphics.Text("Available Hosts", {
      font: "bold 50px calibri",
      fill: "#ffffff",
      align: "center"
    });
    title.x = 40;
    title.y = 30;
    window.addChild(title);
    networkContainerTexture = new Gotham.Graphics.Graphics();
    networkContainerTexture.beginFill(0x00ff00, 0.2);
    networkContainerTexture.drawRect(0, 0, 360, 660);
    networkContainerTexture.endFill();
    networkContainerTexture = networkContainerTexture.generateTexture();
    networkContainer = this.networkContainer = new Gotham.Graphics.Sprite(networkContainerTexture);
    networkContainer.x = 40;
    networkContainer.y = 90;
    GothamGame.Renderer.pixi.addWheelScrollObject(networkContainer);
    networkContainerMask = new Gotham.Graphics.Graphics;
    networkContainerMask.beginFill(0x00ff00, 0.2);
    networkContainerMask.drawRect(0, 0, 360, 660);
    networkContainer.addChild(networkContainerMask);
    networkContainer.mask = networkContainerMask;
    networkContainer.interactive = true;
    networkContainer.mouseover = function() {
      return this.canScroll = true;
    };
    networkContainer.mouseout = function() {
      return this.canScroll = false;
    };
    networkContainer.onWheelScroll = function(e) {
      var direction, isZoomOut, nextY, zoomOut;
      if (!this.canScroll) {
        return;
      }
      direction = e.wheelDeltaY / Math.abs(e.wheelDeltaY);
      isZoomOut = zoomOut = direction === -1 ? true : false;
      nextY = isZoomOut ? that.startY - 60 : that.startY + 60;
      if (nextY > 0 || Math.abs(nextY) > Math.abs((that.itemCount * 60) - 660)) {
        return;
      }
      that.startY = nextY;
      return that.redraw();
    };
    return window.addChild(networkContainer);
  };

  IdentityView.prototype.createUserInfo = function(window) {
    var title;
    title = new Gotham.Graphics.Text("Identities", {
      font: "bold 50px calibri",
      fill: "#ffffff",
      align: "center"
    });
    title.x = 450;
    title.y = 30;
    return window.addChild(title);
  };

  IdentityView.prototype.addIdentity = function(identity) {
    var button, container, createItem, descriptionText, modText, texts, that, type, value, y;
    that = this;
    this.identityCount += 1;
    container = new Gotham.Graphics.Graphics();
    container.visible = false;
    if (!this.selectedIdentity) {
      container.visible = true;
      this.selectedIdentity = container;
    }
    this.window.addChild(container);
    createItem = function(title, value) {
      var item, modItem;
      item = new Gotham.Graphics.Text("" + title + ":", {
        font: "bold 25px calibri",
        fill: "#ffffff",
        align: "center"
      });
      item.x = 450;
      container.addChild(item);
      modItem = new Gotham.Graphics.Text(value, {
        font: "bold 25px calibri",
        fill: "#ffffff",
        align: "center"
      });
      modItem.x = 600;
      container.addChild(modItem);
      return [item, modItem];
    };
    y = 85;
    for (type in identity) {
      value = identity[type];
      texts = createItem(type.replace("_", " ").toTitleCase(), value);
      descriptionText = texts[0];
      modText = texts[1];
      descriptionText.y = y;
      modText.y = y;
      y += 45;
    }
    button = new Gotham.Controls.Button(this.identityCount, 50, 50, {
      toggle: false,
      textSize: 100
    });
    button.x = 450 + (60 * (this.identityCount - 1));
    button.y = y;
    button.identity = container;
    button.setBackground(identity.active ? 0x00ff00 : 0x808080);
    button.onClick = function() {
      that.selectedIdentity.visible = false;
      that.selectedIdentity = this.identity;
      return this.identity.visible = true;
    };
    return this.window.addChild(button);
  };

  "for type, value of identity\n@identityTextMapping[type].setText value";

  IdentityView.prototype.addNetwork = function(network) {
    var db_node, networkSprite, text, that;
    this.itemCount++;
    that = this;
    db_node = Gotham.Database.table("node");
    networkSprite = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user_management_network_item", "image"));
    networkSprite.y = 0;
    networkSprite.interactive = true;
    networkSprite.click = function() {
      return that.shopOnNetworkClick(network);
    };
    text = new Gotham.Graphics.Text("IP: " + network.external_ip_v4 + " Mask: " + network.submask + "\nNode: " + (db_node.findOne({
      id: network.Node
    }).name), {
      font: "bold 20px calibri",
      fill: "#ffffff",
      align: "left"
    });
    text.x = 5;
    text.y = 5;
    networkSprite.addChild(text);
    this.networks[network.id] = {
      sprite: networkSprite,
      hosts: []
    };
    return this.networkContainer.addChild(networkSprite);
  };

  IdentityView.prototype.addHost = function(network, host) {
    var hostSprite, text;
    this.itemCount++;
    hostSprite = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user_mangement_host", "image"));
    hostSprite.x = 0;
    hostSprite.y = 0;
    hostSprite.interactive = true;
    this.networkContainer.addChild(hostSprite);
    text = new Gotham.Graphics.Text("" + host.machine_name + "          Online: " + host.online + "\n" + host.ip + "       " + host.mac, {
      font: "bold 20px calibri",
      fill: "#ffffff",
      align: "left"
    });
    text.x = 30;
    text.y = 5;
    hostSprite.addChild(text);
    this.networks[network.id]["hosts"].push(hostSprite);
    return hostSprite;
  };

  IdentityView.prototype.redraw = function() {
    var host, network, networkID, y, _ref, _results;
    y = this.startY;
    _ref = this.networks;
    _results = [];
    for (networkID in _ref) {
      network = _ref[networkID];
      network.sprite.y = y;
      y += 60;
      _results.push((function() {
        var _i, _len, _ref1, _results1;
        _ref1 = network.hosts;
        _results1 = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          host = _ref1[_i];
          host.y = y;
          _results1.push(y += 60);
        }
        return _results1;
      })());
    }
    return _results;
  };

  return IdentityView;

})(Gotham.Pattern.MVC.View);

module.exports = IdentityView;


},{}],71:[function(require,module,exports){

/**
 * MissionVIew shows all available mission + ongoing missions
 * @class MissionView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var MissionView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MissionView = (function(_super) {
  __extends(MissionView, _super);

  function MissionView() {
    MissionView.__super__.constructor.apply(this, arguments);
    this.movable();
    this.click = function() {
      return this.bringToFront();
    };
    this.selected = null;
    this.missions = {
      ongoing: {
        isOngoing: true,
        elements: [],
        index: 0,
        elementsPerPage: 5,
        numPages: 0,
        y: 450
      },
      available: {
        isOngoing: false,
        elements: [],
        index: 0,
        elementsPerPage: 5,
        numPages: 0,
        y: 60
      }
    };
  }

  MissionView.prototype.create = function() {
    return this.setupListView();
  };

  MissionView.prototype.setupListView = function() {
    var availMissions, frame, ongoingMissions, spacer, that, window;
    that = this;
    this.window = window = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("mission_background", "image"));
    window.x = 190;
    window.y = 110;
    window.interactive = true;
    window.click = function(e) {};
    this.addChild(window);
    availMissions = new Gotham.Graphics.Text("Available Missions", {
      font: "bold 20px calibri",
      fill: "#ffffff",
      align: "left"
    });
    availMissions.x = 35;
    availMissions.y = 30;
    window.addChild(availMissions);
    ongoingMissions = new Gotham.Graphics.Text("Ongoing Missions", {
      font: "bold 20px calibri",
      fill: "#ffffff",
      align: "left"
    });
    ongoingMissions.x = 35;
    ongoingMissions.y = 420;
    window.addChild(ongoingMissions);
    this.noDisplayedMission = new Gotham.Graphics.Text("No Mission Selected", {
      font: "bold 45px calibri",
      fill: "#ffffff",
      align: "left"
    });
    this.noDisplayedMission.x = 480;
    this.noDisplayedMission.y = 300;
    this.noDisplayedMission.visible = true;
    this.window.addChild(this.noDisplayedMission);
    frame = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("mission_frame", "image"));
    window.addChild(frame);
    spacer = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("mission_spacer", "image"));
    spacer.y = 5;
    spacer.x = window.width / 2;
    return window.addChild(spacer);
  };

  MissionView.prototype.addOngoingMission = function(mission) {
    return this.addMission(mission, this.missions.ongoing);
  };

  MissionView.prototype.removeOngoingMission = function(mission) {
    return this.removeMission(mission, this.missions.ongoing);
  };

  MissionView.prototype.addAvailableMission = function(mission) {
    return this.addMission(mission, this.missions.available);
  };

  MissionView.prototype.removeAvailableMission = function(mission) {
    return this.removeMission(mission, this.missions.available);
  };

  MissionView.prototype.removeMission = function(mission, container) {
    var element, _i, _len, _ref, _results;
    _ref = container.elements;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      element = _ref[_i];
      if (element.mission.id === mission.id) {
        element.journalItem.visible = false;
        container.elements.remove(element);
        this.window.removeChild(element);
        break;
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  MissionView.prototype.updateVisibility = function() {
    var container, count, element, end, i, key, start, _i, _len, _ref, _ref1, _results;
    _ref = this.missions;
    _results = [];
    for (key in _ref) {
      container = _ref[key];
      start = container.index * container.elementsPerPage;
      end = (container.index * container.elementsPerPage) + container.elementsPerPage;
      _ref1 = container.elements;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        element = _ref1[_i];
        element.visible = false;
      }
      count = 0;
      _results.push((function() {
        var _j, _results1;
        _results1 = [];
        for (i = _j = start; start <= end ? _j < end : _j > end; i = start <= end ? ++_j : --_j) {
          if (container.elements[i]) {
            container.elements[i].visible = true;
            container.elements[i].y = container.y + (count * container.elements[i].height) + (5 * count);
            _results1.push(count++);
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  MissionView.prototype.generateMissionJournalItem = function(mission, missionItem) {
    var abandonButton, acceptButton, completeMissionButton, current, descText, experienceGainText, gainTitle, journalContainer, key, missionDescription, missionDescription_title, missionTitle, moneyGainText, requirement, requirmentGraphics, startY, that, _ref;
    that = this;
    journalContainer = new Gotham.Graphics.Container;
    journalContainer.visible = false;
    this.window.addChild(journalContainer);
    missionTitle = new Gotham.Graphics.Text(mission.getTitle(), {
      font: "bold 45px calibri",
      fill: "#ffffff",
      align: "left"
    });
    missionTitle.x = 480;
    missionTitle.y = 60;
    journalContainer.addChild(missionTitle);
    missionDescription_title = new Gotham.Graphics.Text("Description", {
      font: "bold 30px calibri",
      fill: "#ffffff",
      align: "left"
    });
    missionDescription_title.x = 480;
    missionDescription_title.y = 120;
    journalContainer.addChild(missionDescription_title);
    descText = mission.getOngoing() ? mission.getExtendedDescription() : mission.getDescription();
    missionDescription = new Gotham.Graphics.Text(descText, {
      wordWrap: true,
      wordWrapWidth: 400,
      font: "bold 20px calibri",
      fill: "#000000",
      align: "left"
    });
    missionDescription.x = 480;
    missionDescription.y = 180;
    journalContainer.addChild(missionDescription);
    startY = missionDescription.y + missionDescription.height + 60;
    if (!mission.getOngoing()) {
      acceptButton = new Gotham.Controls.Button("Accept", 100, 50, {
        toggle: false,
        texture: Gotham.Preload.fetch("iron_button", "image"),
        textSize: 50
      });
      acceptButton.y = missionDescription.y + missionDescription.height + 20;
      acceptButton.x = 480;
      acceptButton.click = function() {
        that.selected.tint = 0xFFFFFF;
        that.selected._toggle = false;
        that.selected.journalItem.visible = false;
        that.selected = null;
        that.noDisplayedMission.visible = true;
        return GothamGame.Network.Socket.emit('AcceptMission', {
          id: mission.getID()
        });
      };
      journalContainer.addChild(acceptButton);
    } else {
      _ref = mission.getRequirements();
      for (key in _ref) {
        requirement = _ref[key];
        current = !requirement.getCurrent() ? "None" : requirement.getCurrent();
        requirmentGraphics = new Gotham.Graphics.Text("" + (requirement.getName()) + ": " + current + "/" + (requirement.getExpected()), {
          font: "bold 20px calibri",
          fill: "#000000",
          align: "left"
        });
        requirmentGraphics.y = startY;
        requirmentGraphics.x = 480;
        missionItem.requirements.push(requirmentGraphics);
        journalContainer.addChild(requirmentGraphics);
        startY += requirmentGraphics.height + 5;
      }
      startY += 40;
      abandonButton = new Gotham.Controls.Button("Abandon", 100, 50, {
        toggle: false,
        texture: Gotham.Preload.fetch("iron_button", "image"),
        textSize: 50
      });
      abandonButton.y = startY;
      abandonButton.x = 480;
      abandonButton.interactive = true;
      abandonButton.visible = false;
      journalContainer.addChild(abandonButton);
      abandonButton.click = function() {
        that.selected.journalItem.visible = false;
        that.selected = null;
        that.noDisplayedMission.visible = true;
        return GothamGame.Network.Socket.emit('AbandonMission', {
          id: mission.getUserMissionID()
        });
      };
      completeMissionButton = new Gotham.Controls.Button("Complete Mission", 100, 50, {
        toggle: false,
        texture: Gotham.Preload.fetch("iron_button", "image"),
        textSize: 35
      });
      completeMissionButton.y = startY;
      completeMissionButton.x = 480;
      completeMissionButton.visible = false;
      journalContainer.addChild(completeMissionButton);
      completeMissionButton.click = function() {
        return GothamGame.Network.Socket.emit('CompleteMission', {
          id: mission.getUserMissionID()
        });
      };
      if (!mission.isCompleted()) {
        abandonButton.visible = true;
      } else {
        completeMissionButton.visible = true;
      }
    }
    gainTitle = new Gotham.Graphics.Text("You will gain", {
      font: "bold 30px calibri",
      fill: "#ffffff",
      align: "left"
    });
    gainTitle.x = 480;
    gainTitle.y = startY + 70;
    journalContainer.addChild(gainTitle);
    moneyGainText = new Gotham.Graphics.Text(mission.getMoneyGain() + "$", {
      stroke: "#000000",
      strokeThickness: 2,
      font: "bold 30px calibri",
      fill: "#006400",
      align: "left"
    });
    moneyGainText.x = 480;
    moneyGainText.y = startY + 110;
    journalContainer.addChild(moneyGainText);
    experienceGainText = new Gotham.Graphics.Text(mission.getExperienceGain() + " experience", {
      stroke: "#000000",
      strokeThickness: 2,
      font: "bold 30px calibri",
      fill: "#006400",
      align: "left"
    });
    experienceGainText.x = 480;
    experienceGainText.y = startY + 140;
    journalContainer.addChild(experienceGainText);
    return {
      container: journalContainer,
      completeMissionButton: completeMissionButton,
      abandonButton: abandonButton
    };
  };

  MissionView.prototype.updateStats = function() {
    var current, element, i, key, keys, mission, requirements, type, _ref, _results;
    _ref = this.missions;
    _results = [];
    for (key in _ref) {
      type = _ref[key];
      _results.push((function() {
        var _i, _len, _ref1, _results1;
        _ref1 = type.elements;
        _results1 = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          element = _ref1[_i];
          mission = element.mission;
          requirements = mission.getRequirements();
          keys = Object.keys(requirements);
          _results1.push((function() {
            var _j, _ref2, _results2;
            _results2 = [];
            for (i = _j = 0, _ref2 = element.requirements.length; 0 <= _ref2 ? _j < _ref2 : _j > _ref2; i = 0 <= _ref2 ? ++_j : --_j) {
              current = !requirements[keys[i]].getCurrent() ? "None" : requirements[keys[i]].getCurrent();
              _results2.push(element.requirements[i].text = "" + (requirements[keys[i]].getName()) + ": " + current + "/" + (requirements[keys[i]].getExpected()));
            }
            return _results2;
          })());
        }
        return _results1;
      })());
    }
    return _results;
  };

  MissionView.prototype.addMission = function(mission, container) {
    var journalItems, missionItem, missionTitle, missionXPReq, pageButton, pageNum, that, title;
    that = this;
    missionItem = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("mission_item", "image"));
    missionItem.y = container.y + (container.elements.length * missionItem.height) + (5 * container.elements.length);
    missionItem.x = 35;
    missionItem.mission = mission;
    missionItem.requirements = [];
    missionItem.interactive = true;
    missionItem.visible = true;
    journalItems = this.generateMissionJournalItem(mission, missionItem);
    missionItem.journalItem = journalItems.container;
    container.elements.push(missionItem);
    pageNum = Math.ceil(container.elements.length / container.elementsPerPage);
    if (container.numPages < pageNum) {
      container.numPages = pageNum;
      pageButton = new Gotham.Controls.Button(pageNum, 25, 25, {
        toggle: false,
        textSize: 100
      });
      pageButton.visible = true;
      pageButton.x = pageNum * 35;
      pageButton.y = container.y + (50 * container.elementsPerPage + 1) + (5 * container.elementsPerPage);
      pageButton.click = function() {
        container.index = pageNum - 1;
        return that.updateVisibility();
      };
      this.window.addChild(pageButton);
    }
    missionItem.click = function() {
      this._toggle = !this._toggle ? true : !this._toggle;
      if (that.selected) {
        that.selected.tint = 0xffffff;
        that.selected.journalItem.visible = false;
        that.selected._toggle = false;
        that.noDisplayedMission.visible = true;
      }
      that.selected = missionItem;
      if (this._toggle) {
        this.tint = 0x00ff00;
        this.journalItem.visible = true;
        that.noDisplayedMission.visible = false;
        return that.selected = this;
      } else {
        this.tint = 0xffffff;
        this.journalItem.visible = false;
        that.noDisplayedMission.visible = true;
        return that.selected = null;
      }
    };
    title = mission.isCompleted() && mission.getOngoing() ? "" + (mission.getTitle()) + " (Complete)" : mission.getTitle();
    missionTitle = new Gotham.Graphics.Text(title, {
      font: "bold 20px calibri",
      fill: "#ffffff",
      align: "left"
    });
    missionTitle.x = 10;
    missionTitle.y = 15;
    missionItem.addChild(missionTitle);
    missionXPReq = new Gotham.Graphics.Text("Req XP: " + (mission.getRequiredXP()), {
      font: "bold 20px calibri",
      fill: "#ffffff",
      align: "right"
    });
    missionXPReq.x = 270;
    missionXPReq.y = 15;
    missionItem.addChild(missionXPReq);
    this.window.addChild(missionItem);
    this.updateVisibility();
    return {
      missionItem: missionItem,
      missionTitle: missionTitle,
      journal: journalItems
    };
  };

  MissionView.prototype.updateQuestList = function(container) {
    var mission, missions, _i, _j, _len, _len1, _ref, _results;
    _ref = container.elements;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      mission = _ref[_i];
      mission.visible = false;
    }
    missions = container.pages[container.currentPage];
    _results = [];
    for (_j = 0, _len1 = missions.length; _j < _len1; _j++) {
      mission = missions[_j];
      _results.push(mission.visible = true);
    }
    return _results;
  };

  return MissionView;

})(Gotham.Pattern.MVC.View);

module.exports = MissionView;


},{}],72:[function(require,module,exports){

/**
 * NodeListView shows all nodes on the map
 * @class NodeListView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var NodeListView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

NodeListView = (function(_super) {
  __extends(NodeListView, _super);

  function NodeListView() {
    var that;
    NodeListView.__super__.constructor.apply(this, arguments);
    that = this;
    this._selected = null;
    this._scrollIndex = 0;
    this._maxVisible = 7;
    this._nodeCount = 0;
  }

  NodeListView.prototype.create = function() {
    var background, frame, object_name, that;
    that = this;
    frame = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("terminal_background", "image"));
    frame.width = 250 * frame.scale.x;
    frame.height = 600 * frame.scale.y;
    this.addChild(frame);
    this.movable();
    object_name = new Gotham.Graphics.Text("Node List", {
      font: "bold 20px Arial",
      fill: "#ffffff",
      align: "left"
    });
    object_name.position.x = this.width / 2;
    object_name.position.y = 10;
    object_name.anchor.x = 0.5;
    this.addChild(object_name);
    background = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("nodelist_background", "image"));
    background.x = 0;
    background.y = 50;
    background.width = 250 * background.scale.x;
    background.height = 530;
    background.setInteractive(true);
    this.addChild(background);
    return GothamGame.Renderer.pixi.addWheelScrollObject(background);
  };

  NodeListView.prototype.create_frame = function() {};

  NodeListView.prototype.create_item = function() {
    var drawNodeItems;
    drawNodeItems = function() {
      var child, count, db_node, _i, _len, _ref;
      _ref = background.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        background.removeChild(child);
      }
      count = 0;
      db_node = GothamGame.Database.table("node");
      that._nodeCount = db_node().count();
      return db_node().start(that._scrollIndex).limit(that._maxVisible).each(function(row) {
        var node_item_background, node_marker, node_name, node_tier;
        node_item_background = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("bottomBar", "image"));
        node_item_background.height = (background.height / background.scale.y) / that._maxVisible;
        node_item_background.width = background.width / background.scale.x;
        node_item_background.y = node_item_background.height * count++;
        node_item_background.setInteractive(true);
        node_marker = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("map_marker", "image"));
        node_marker.height = 32 / node_item_background.scale.y;
        node_marker.width = 32 / node_item_background.scale.x;
        node_marker.x = 10 / node_item_background.scale.x;
        node_marker.y = (node_item_background.height / 2) / node_item_background.scale.y;
        node_marker.anchor.y = 0.5;
        node_item_background.addChild(node_marker);
        node_name = new Gotham.Graphics.Text((row.Name.length > 20 ? row.name.substring(0, 20) + "..." : row.Name), {
          font: "bold 20px Arial",
          fill: "#ffffff",
          align: "left"
        });
        node_name.width = node_item_background.width / node_item_background.scale.x;
        node_name.position.x = node_marker.width + node_marker.y;
        node_name.position.y = (node_item_background.height / 2) / node_item_background.scale.y;
        node_name.anchor.y = 0.4;
        node_item_background.addChild(node_name);
        node_tier = new Gotham.Graphics.Text("Tier " + row.Tier.Id, {
          font: "bold 15px Arial",
          fill: "#3399ff",
          align: "left"
        });
        node_tier.width = node_item_background.width / node_item_background.scale.x;
        node_tier.position.x = (node_item_background.width / node_item_background.scale.x) - node_tier.width;
        node_tier.position.y = 10 / node_item_background.scale.y;
        node_item_background.addChild(node_tier);
        node_item_background.click = function(e) {
          this._clickToggle = !this._clickToggle;
          if (this._clickToggle) {
            row.sprite.mouseover(e);
            node_marker.tint = row.sprite.tint = 0xffff00;
            row.sprite.scale.x = row.sprite.scale.x * 2;
            return row.sprite.scale.y = row.sprite.scale.y * 2;
          } else {
            row.sprite.mouseout(e);
            node_marker.tint = row.sprite.tint = 0xffffff;
            row.sprite.scale.x = row.sprite.scale.x / 2;
            return row.sprite.scale.y = row.sprite.scale.y / 2;
          }
        };
        return background.addChild(node_item_background);
      });
    };
    drawNodeItems();
    background.mouseover = function() {
      return this.canScroll = true;
    };
    background.mouseout = function() {
      return this.canScroll = false;
    };
    background.onWheelScroll = function(e) {
      var direction;
      if (!this.canScroll) {
        return;
      }
      direction = (e.wheelDeltaY / Math.abs(e.wheelDeltaY)) * -1;
      if (direction + that._scrollIndex < 0) {
        return;
      }
      if (direction + that._scrollIndex > (that._nodeCount - that._maxVisible + 1)) {
        return;
      }
      that._scrollIndex += direction;
      return drawNodeItems();
    };
    return this.addChild(background);
  };

  return NodeListView;

})(Gotham.Pattern.MVC.View);

module.exports = NodeListView;


},{}],73:[function(require,module,exports){

/**
 * SettingsView shows the setting panel
 * @class SettingsView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var SettingsView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SettingsView = (function(_super) {
  __extends(SettingsView, _super);

  function SettingsView() {
    return SettingsView.__super__.constructor.apply(this, arguments);
  }

  SettingsView.prototype.create = function() {
    var soundLevel, soundLevelTitle, spriteContainer, that, topBar, topBarTexture, topBar_Close, topBar_Title;
    that = this;
    spriteContainer = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("settings_background", "image"));
    spriteContainer.width = 1920 * 0.80;
    spriteContainer.height = 1080 * 0.80;
    spriteContainer.x = 1920 * 0.10;
    spriteContainer.y = 1080 * 0.10;
    spriteContainer.interactive = true;
    this.addChild(spriteContainer);
    topBarTexture = Gotham.Preload.fetch("topBar", "image");
    topBar = new PIXI.Sprite(topBarTexture);
    topBar.position.x = 0;
    topBar.position.y = 0;
    topBar.width = 1920;
    topBar.height = 1080 * 0.10;
    topBar.setInteractive(true);
    spriteContainer.addChild(topBar);
    topBar_Title = new Gotham.Graphics.Text("Settings", {
      font: "bold 20px Arial",
      fill: "#ffffff",
      align: "left"
    });
    topBar_Title.x = (topBar.width / 4) + (topBar_Title.width / 2);
    topBar_Title.y = topBar.height / 4 - (topBar_Title.height / 2);
    topBar.addChild(topBar_Title);
    topBar_Close = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("settings_close", "image"));
    topBar_Close.width = 64;
    topBar_Close.height = 64;
    topBar_Close.x = topBar.width - topBar_Close.width;
    topBar_Close.y = 0;
    topBar_Close.interactive = true;
    spriteContainer.addChild(topBar_Close);
    topBar_Close.mouseover = function() {
      return this.tint = 0xFF0000;
    };
    topBar_Close.mouseout = function() {
      return this.tint = 0xFFFFFF;
    };
    topBar_Close.click = function(data) {
      return that.parent.removeObject(that.Controller);
    };

    /*
     */

    /* Settings controls
     */
    soundLevelTitle = new Gotham.Graphics.Text("Sound Volume", {
      font: "bold 20px Arial",
      fill: "#ffffff",
      align: "left"
    });
    soundLevelTitle.x = 400;
    soundLevelTitle.y = 180;
    spriteContainer.addChild(soundLevelTitle);
    soundLevel = new Gotham.Controls.Slider(Gotham.Preload.fetch("map_marker", "image"), Gotham.Preload.fetch("slider_background", "image"));
    soundLevel.x = 350;
    soundLevel.y = 210;
    soundLevel.width = 500;
    soundLevel.height = 100;
    soundLevel.onProgress = function(progress) {
      var audio, _i, _len, _ref, _results;
      _ref = Gotham.Preload.getDatabase("audio").find();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        audio = _ref[_i];
        _results.push(audio.object.volume(progress / 100));
      }
      return _results;
    };
    return spriteContainer.addChild(soundLevel);
  };

  return SettingsView;

})(Gotham.Pattern.MVC.View);

module.exports = SettingsView;


},{}],74:[function(require,module,exports){

/**
 * ShopView is the view of the shop in the game. Possible top purchase networks etc.
 * @class ShopView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var ShopView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ShopView = (function(_super) {
  __extends(ShopView, _super);

  function ShopView() {
    return ShopView.__super__.constructor.apply(this, arguments);
  }

  ShopView.prototype.create = function() {
    this.categories = [];
    this.movable();
    this.createFrame();
    return this.createTitles();
  };

  ShopView.prototype.createFrame = function() {
    this.frame = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("shop_background", "image"));
    this.frame.width = 1920 * 0.30;
    this.frame.height = 1080 * 0.30;
    this.frame.x = 1920 * 0.33;
    this.frame.y = 1080 * 0.33;
    this.frame.interactive = true;
    return this.addChild(this.frame);
  };

  ShopView.prototype.createTitles = function() {
    var title;
    title = new Gotham.Graphics.Text("Dell Computer Shop", {
      font: "bold 150px calibri",
      fill: "#ffffff",
      stroke: "#000000",
      strokeThickness: 5,
      align: "center"
    });
    title.x = 350;
    title.y = 60;
    return this.frame.addChild(title);
  };

  ShopView.prototype.createCategory = function(name, helpText, y, price, onClick) {
    var buyButton, help, title;
    if (onClick == null) {
      onClick = function() {};
    }
    title = new Gotham.Graphics.Text("Buy " + name + " for ", {
      font: "bold 100px calibri",
      fill: "#ffffff",
      align: "center"
    });
    title.x = 400;
    title.y = y;
    this.frame.addChild(title);
    help = new Gotham.Graphics.Text(helpText, {
      font: "bold 50px calibri",
      fill: "#ffffff",
      align: "center"
    });
    help.x = 400;
    help.y = y + 100;
    this.frame.addChild(help);
    price = new Gotham.Graphics.Text("" + price + "$", {
      font: "bold 130px calibri",
      fill: "#006400",
      stroke: "#323232",
      strokeThickness: 10,
      align: "center"
    });
    price.x = title.x + title.width + 10;
    price.y = y - 20;
    this.frame.addChild(price);
    buyButton = new Gotham.Controls.Button("X", 70, 70, {
      margin: 0,
      alpha: 1,
      textSize: 120,
      toggle: true,
      buttonColor: 0xF0F8FF
    });
    buyButton.x = title.x - 90;
    buyButton.y = y + 20;
    buyButton.interactive = true;
    buyButton.tint = 0x4169E1;
    buyButton.click = function() {
      this.toggle = !this.toggle ? true : !this.toggle;
      if (this.toggle) {
        onClick(this, true);
        return buyButton.tint = 0xFF0000;
      } else {
        onClick(this, false);
        return buyButton.tint = 0x4169E1;
      }
    };
    return this.frame.addChild(buyButton);
  };

  ShopView.prototype.show = function() {
    return this.visible = true;
  };

  ShopView.prototype.hide = function() {
    return this.visible = false;
  };

  return ShopView;

})(Gotham.Pattern.MVC.View);

module.exports = ShopView;


},{}],75:[function(require,module,exports){

/**
 * The terminal view shows / displays the terminal. These are created with JQUERY and appended to the index file
 * @class TerminalView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var TerminalView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TerminalView = (function(_super) {
  __extends(TerminalView, _super);

  TerminalView.count = 0;

  function TerminalView() {
    TerminalView.__super__.constructor.apply(this, arguments);
    this.name = null;
    TerminalView.count += 1;
    this.id = JSON.parse(JSON.stringify("" + TerminalView.count));
    this._console = void 0;
    this._input = void 0;
    this._console_window = void 0;
  }

  TerminalView.prototype.create = function() {
    return this.create_terminal();
  };

  TerminalView.prototype.setConsole = function(console) {
    this._console = console;
    return this._console;
  };

  TerminalView.prototype.redraw = function() {
    var objDiv;
    $(this._console_window).html(this._console.all().join("<br/>"));
    objDiv = document.getElementById($(this._console_window).attr("id"));
    return objDiv.scrollTop = objDiv.scrollHeight;
  };

  TerminalView.prototype.create_terminal = function() {
    var minimized, oldHeight, selection, terminalCount, terminal_console_content, terminal_console_frame, terminal_frame, terminal_input_field, terminal_input_frame, terminal_title_close, terminal_title_frame, terminal_title_minimize, terminal_title_text;
    selection = '-moz-user-select: none; -webkit-user-select: none; -ms-user-select:none; user-select:none;-o-user-select:none;';
    terminalCount = $(".terminal_frame").length;
    this.terminal_frame = terminal_frame = $('<div\>', {
      id: "terminal_frame_" + terminalCount,
      "class": "terminal_frame",
      style: "width: 700px;\nheight: 350px;\nbackground-color: red;\nposition: fixed;\ntop: 27%;\nleft: 40%;"
    });
    terminal_title_frame = $('<div\>', {
      id: "terminal_title_frame_" + terminalCount,
      style: "width: 100%;\nheight: 5%;\nmin-height: 25px;\nbackground-color: black;\nborder-bottom: 1px solid gray;\nposition: relative;\ntop: 0px;\nleft: 0px;\n" + selection
    });
    terminal_title_text = $('<div\>', {
      id: "terminal_title_text_" + terminalCount,
      style: "text-align: center;\ncolor: white;\nposition: relative;\ndisplay: inline-block;\nwidth:90%;\n" + selection,
      text: "Terminal x64"
    });
    terminal_title_close = $('<div\>', {
      id: "terminal_title_close" + terminalCount,
      style: "text-align: center;\ncolor: white;\nposition: relative;\ndisplay: inline-block;\nwidth:5%;\ncursor: pointer;\n" + selection,
      text: "X"
    });
    $(terminal_title_close).on('click', function() {
      return $(terminal_frame).hide();
    });
    terminal_console_frame = $('<div\>', {
      id: "terminal_console_frame_" + terminalCount,
      style: "width: 100%;\nheight: 85%;\nborder-bottom: 1px solid gray;\nposition: relative;\ntop: 0px;\nleft: 0px;"
    });
    this._console_window = terminal_console_content = $('<div\>', {
      id: "terminal_console_frame_content_" + terminalCount,
      style: "width: 100%;\nheight: 100%;\nbackground-image: url('./assets/img/terminal_background.png');\nbackground-size:cover;\nborder-bottom: 1px solid gray;\nfont-family: Courier New;\nfont-size: 11px;\nposition: relative;\ntop: 0px;\nleft: 0px;\ncolor: white;\noverflow-y: scroll;\npadding: 1%;\nwhite-space:pre;\nword-wrap: break-word;",
      text: ""
    });
    terminal_input_frame = $('<div\>', {
      id: "terminal_input_frame_" + terminalCount,
      style: "width: 100%;\nheight: 10%;\nbackground-color: gray;\nposition: relative;"
    });
    this._input = this.terminal_input_field = terminal_input_field = $('<input\>', {
      type: "text",
      id: "terminal_input_field_" + terminalCount,
      style: "width: 100%;\nheight: 100%;\nbackground-color: black;\ndisplay: inline-block;\nfont-family: Courier New;\nfont-size: 11px;\nposition: relative;\npadding:0;\npadding-left: 1%;\nborder: 0;\ncolor: white;\noutline: none;"
    });
    terminal_title_minimize = $('<div\>', {
      id: "terminal_title_close" + terminalCount,
      style: "text-align: center;\ncolor: white;\nposition: relative;\ndisplay: inline-block;\nwidth:5%;\ncursor: pointer;\n" + selection,
      text: "_"
    });
    minimized = false;
    oldHeight = 0;
    terminal_title_minimize.on('click', function() {
      minimized = !minimized;
      if (minimized) {
        $(terminal_console_frame).hide();
        $(terminal_input_frame).hide();
        oldHeight = $(terminal_frame).css("height");
        $(terminal_title_minimize).text("+");
        return $(terminal_frame).css("height", "auto");
      } else {
        $(terminal_console_frame).show();
        $(terminal_input_frame).show();
        $(terminal_title_minimize).text("_");
        return $(terminal_frame).css("height", oldHeight);
      }
    });
    $(terminal_frame).append(terminal_title_frame);
    $(terminal_title_frame).append(terminal_title_text);
    $(terminal_title_frame).append(terminal_title_minimize);
    $(terminal_title_frame).append(terminal_title_close);
    $(terminal_frame).append(terminal_console_frame);
    $(terminal_console_frame).append(terminal_console_content);
    $(terminal_frame).append(terminal_input_frame);
    $(terminal_input_frame).append(terminal_input_field);
    $(terminal_frame).draggable({
      handle: terminal_title_frame,
      drag: function(e, ui) {
        ui.position.top = Math.max(0, ui.position.top);
        ui.position.left = Math.max(0, ui.position.left);
        ui.position.top = Math.min($(window).height() - $(this).height(), ui.position.top);
        return ui.position.left = Math.min($(window).width() - $(this).width(), ui.position.left);
      }
    });
    $(terminal_frame).resizable();
    $("body").append(this.terminal_frame);
    return this.terminal_frame.hide();
  };

  return TerminalView;

})(Gotham.Pattern.MVC.View);

module.exports = TerminalView;


},{}],76:[function(require,module,exports){

/**
 * The user view shows the user data. Example is Name, Money, Experience etc.
 * @class UserView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var UserView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

UserView = (function(_super) {
  __extends(UserView, _super);

  function UserView() {
    UserView.__super__.constructor.apply(this, arguments);
    this.movable();
    this.click = function() {
      return this.bringToFront();
    };
  }

  UserView.prototype.create = function() {
    this.createFrame();
    this.createTitles();
    this.hide();
    this.emitSetExperience();
    return this.emitSetMoney();
  };

  UserView.prototype.createTitles = function() {
    var email, experience, hosts, identities, money, networks, title, username;
    title = this.title = new Gotham.Graphics.Text("Player Information", {
      font: "bold 50px calibri",
      fill: "#ffffff",
      align: "center"
    });
    title.x = 40;
    title.y = 30;
    this.window.addChild(title);
    username = this.username = new Gotham.Graphics.Text("Username: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    username.y = 100;
    username.x = 40;
    this.window.addChild(username);
    email = this.email = new Gotham.Graphics.Text("Email: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    email.y = 140;
    email.x = 40;
    this.window.addChild(email);
    money = this.money = new Gotham.Graphics.Text("Money: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    money.y = 180;
    money.x = 40;
    this.window.addChild(money);
    experience = this.experience = new Gotham.Graphics.Text("Experience: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    experience.y = 220;
    experience.x = 40;
    this.window.addChild(experience);
    identities = this.identities = new Gotham.Graphics.Text("Identities: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    identities.y = 100;
    identities.x = 400;
    this.window.addChild(identities);
    networks = this.networks = new Gotham.Graphics.Text("Networks: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    networks.y = 140;
    networks.x = 400;
    this.window.addChild(networks);
    hosts = this.hosts = new Gotham.Graphics.Text("Hosts: [NONE]", {
      font: "bold 25px calibri",
      fill: "#ffffff",
      align: "center"
    });
    hosts.y = 180;
    hosts.x = 400;
    return this.window.addChild(hosts);
  };

  UserView.prototype.emitSetMoney = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('UpdatePlayerMoney', function(money) {
      var gain, oldMoney;
      oldMoney = parseInt(that.money.text.replace("Money: ", ""));
      gain = money - oldMoney;
      GothamGame.Announce.message("You gained " + gain + " money!", "MISSION", 50);
      return that.money.text = "Money: " + money;
    });
  };

  UserView.prototype.emitSetExperience = function() {
    var that;
    that = this;
    return GothamGame.Network.Socket.on('UpdatePlayerExperience', function(experience) {
      var gain, oldExperience;
      oldExperience = parseInt(that.experience.text.replace("Experience: ", ""));
      gain = experience - oldExperience;
      GothamGame.Announce.message("You gained " + gain + " experience!", "MISSION", 50);
      return that.experience.text = "Experience: " + experience;
    });
  };

  UserView.prototype.setUser = function(user) {
    var host, identity, network, numHosts, numIdentities, numNetworks, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    numIdentities = 0;
    numNetworks = 0;
    numHosts = 0;
    _ref = user.Identities;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      identity = _ref[_i];
      numIdentities++;
      _ref1 = identity.Networks;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        network = _ref1[_j];
        numNetworks++;
        _ref2 = network.Hosts;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          host = _ref2[_k];
          numHosts++;
        }
      }
    }
    this.username.text = this.username.text.replace("[NONE]", user.username);
    this.email.text = this.email.text.replace("[NONE]", user.email);
    this.money.text = this.money.text.replace("[NONE]", user.money);
    this.experience.text = this.experience.text.replace("[NONE]", user.experience);
    this.identities.text = this.identities.text.replace("[NONE]", numIdentities);
    this.networks.text = this.networks.text.replace("[NONE]", numNetworks);
    return this.hosts.text = this.hosts.text.replace("[NONE]", numHosts);
  };

  UserView.prototype.show = function() {
    return this.window.visible = true;
  };

  UserView.prototype.hide = function() {
    return this.window.visible = false;
  };

  UserView.prototype.createFrame = function() {
    var frame, window, windowMask;
    window = this.window = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user_management_background", "image"));
    window.width = 800;
    window.height = 700;
    window.y = 1080 - 70 - 700;
    window.x = 400;
    window.interactive = true;
    window.mousemove = function(e) {};
    windowMask = new Gotham.Graphics.Graphics;
    windowMask.beginFill(0x232323, 1);
    windowMask.drawRect(0, 0, window.width / window.scale.x, window.height / window.scale.y);
    window.addChild(windowMask);
    window.mask = windowMask;
    frame = this.frame = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("user_management_frame", "image"));
    frame.width = window.width / window.scale.x;
    frame.height = window.height / window.scale.y;
    window.addChild(frame);
    return this.addChild(window);
  };

  return UserView;

})(Gotham.Pattern.MVC.View);

module.exports = UserView;


},{}],77:[function(require,module,exports){

/**
 * WorldMapView is the view part of the world map. Map creation, node, calbe and animations are done here. see method docs
 * @class WorldMapView
 * @module Frontend.View
 * @namespace GothamGame.View
 * @extends Gotham.Pattern.MVC.View
 */
var WorldMapView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

WorldMapView = (function(_super) {
  __extends(WorldMapView, _super);

  function WorldMapView() {
    WorldMapView.__super__.constructor.apply(this, arguments);

    /**
     * Width of the world map
     * @property {Number} __width
     */
    this.__width = 1920;

    /**
     * Height of the world map
     * @property {Number} __height
     */
    this.__height = 1080;

    /**
     * Initial / Original map size
     * @property {Object} __mapSize
     */
    this.__mapSize = {
      width: 7200,
      height: 3600
    };

    /**
     * List of all info frames currently drawn on the monitor
     * @property {Array} _visible_info_frames
     */
    this._visible_info_frames = [];

    /**
     * Callback which are used to purchase networks. This callback goes to ShopView
     * @property {Callback} shopOnNodeClick
     */
    this.shopOnNodeClick = function() {};
  }


  /**
   * Get the coorinate factors for latitude and longitude based on the maps current size and scale
   * @method getCoordFactors
   * @return {Object}the latitude and longitude property inside a object
   */

  WorldMapView.prototype.getCoordFactors = function() {
    return {
      latitude: ((this.__height / 2) / 90) * -1,
      longitude: (this.__width / 2) / 180
    };
  };


  /**
   * Converts a lat,lng coordinate to a pixel coordinate (x,y)
   *
   * @method coordinateToPixel
   * @param lat {Number} The latitude
   * @param lng {Number} The longitude
   * @returns {Object} The X and Y coordinate inside a object
   */

  WorldMapView.prototype.coordinateToPixel = function(lat, lng) {
    return {
      x: (lng * this.getCoordFactors().longitude) + (this.__width / 2),
      y: (lat * this.getCoordFactors().latitude) + (this.__height / 2)
    };
  };


  /**
   * Creates everything
   *
   * @method create
   */

  WorldMapView.prototype.create = function() {
    "Create the background";
    this.createBackground();
    "Create the world map and node container";
    this.createWorldMap();
    "Create the sun object";
    return this.createSun();
  };


  /**
   * Creates the background object
   *
   * @method createBackground
   */

  WorldMapView.prototype.createBackground = function() {
    var background;
    this._background = background = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("sea_background", "image"));
    background.width = this.__width;
    background.height = this.__height + 140;
    background._size = this.size;
    background.y = 0;
    return this.addChild(background);
  };


  /**
   * Creates a sun object, Hidden by default
   * @method createSun
   */

  WorldMapView.prototype.createSun = function() {
    this.sun = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("sun", "image"));
    this.sun.x = 5;
    this.sun.y = -20;
    this.sun.width = 64;
    this.sun.height = 64;
    this.sun.visible = true;
    this.sun.anchor = {
      x: 0.5,
      y: 0.5
    };
    return this.mapContainer.addChild(this.sun);
  };


  /**
   * Scale the node to reflect WorldMap's scale
   *
   * @method scaleNodes
   */

  WorldMapView.prototype.scaleNodes = function() {
    var db_node, node, row, that, _i, _len, _ref, _results;
    that = this;
    db_node = Gotham.Database.table("node");
    _ref = db_node.find();
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      row = _ref[_i];
      node = row.sprite;
      node.scale.x = Math.max(0.08, Math.pow(that.mapContainer.scale.x * 4, -1));
      _results.push(node.scale.y = Math.max(0.08, Math.pow(that.mapContainer.scale.y * 4, -1)));
    }
    return _results;
  };


  /**
   * Creates the WorldMap container with the worldMap function.
   * Adds this sprite array to the container and creates the map.
   *
   * @method createWorldMap
   */

  WorldMapView.prototype.createWorldMap = function() {
    var mapContainer, mapItem, middle, nodeContainer, that, worldMap, _i, _len;
    that = this;
    "Create a container for world map";
    this.mapContainer = mapContainer = new Gotham.Graphics.Container;
    mapContainer.interactive = true;
    mapContainer.scale = {
      x: 0.8,
      y: 0.8
    };
    mapContainer.x = (this.__width - (this.__width * mapContainer.scale.x)) / 2;
    mapContainer.hitArea = new Gotham.Graphics.Rectangle(0, 0, this.__width, this.__height);
    this._background.addChild(mapContainer);
    "Activate WheelScrolling on the mapContainer";
    GothamGame.Renderer.pixi.addWheelScrollObject(mapContainer);
    "Activate Panning - Return False and ignore if Longitude < -180 or > 180 and False if Latitude < -90 or > 90";
    mapContainer.setPanning(function(newPosition) {
      that.hideNodeDetails();
      this.offset = newPosition;
      return {
        x: true,
        y: true
      };
    });
    mapContainer.offset = {
      y: -70,
      x: 0
    };
    "MapContainers mouse move:\n* Calculates coordinate in lat,lng\n* Determines country based on lat,lng\n* Sets topBarText";
    mapContainer.onMouseMove = function(e) {
      var lat, long, pos, posX, posY;
      pos = e.data.getLocalPosition(this);
      this._lastMousePosition = pos;
      posX = -(that.__width / 2) + pos.x;
      posY = -(that.__height / 2) + pos.y;
      lat = Math.max(Math.min((posY / that.getCoordFactors().latitude).toFixed(4), 90), -90);
      long = Math.max(Math.min((posX / that.getCoordFactors().longitude).toFixed(4), 180), -180);
      that.currentCoordinates = {
        latitude: lat,
        longitude: long
      };
      return that.parent.getObject("Bar").updateCoordinates(lat, long);
    };
    mapContainer.click = function() {
      var isHovering;
      if ($("#gothshark_frame").is(":visible")) {
        isHovering = false;
        $('.terminal_frame').each(function(index) {
          var check;
          check = $(this).is(":hover");
          if (check) {
            isHovering = true;
          }
        });
        if (!isHovering) {
          that.hideNodeDetails();
          that.zoomMap(0.8, 400);
          return this.offset.y = 0;
        }
      }
    };
    "OnWheelScroll";
    mapContainer.mouseover = function() {
      return this.canScroll = true;
    };
    mapContainer.mouseout = function() {
      this.canScroll = false;
      return this.isDragging = false;
    };
    mapContainer.onWheelScroll = function(e) {
      var diffSize, direction, factor, nextScale, nextSize, prevScale, prevSize, zoomOut;
      if (!GothamGame.Globals.canWheelScroll) {
        return;
      }
      if (!this.canScroll) {
        return;
      }
      direction = e.wheelDeltaY / Math.abs(e.wheelDeltaY);
      this.isZoomOut = zoomOut = direction === -1 ? true : false;
      factor = 1.1;
      prevScale = {
        x: this.scale.x,
        y: this.scale.y
      };
      nextScale = {
        x: this.scale.x * (Math.pow(factor, direction)),
        y: this.scale.y * (Math.pow(factor, direction))
      };
      if (nextScale.x < 0.4 || nextScale.y < 0.4) {
        return;
      } else if (nextScale.x > 10 || nextScale.y > 10) {
        return;
      } else {
        that.hideNodeDetails();
        this.scale = nextScale;
        that.scaleNodes(zoomOut);
      }
      this.offset.x = this.offset.x * (Math.pow(factor, direction));
      this.offset.y = this.offset.y * (Math.pow(factor, direction));
      prevSize = {
        width: that.__width,
        height: that.__height
      };
      nextSize = {
        width: that.__width * nextScale.x,
        height: that.__height * nextScale.y
      };
      diffSize = {
        width: prevSize.width - nextSize.width,
        height: prevSize.height - nextSize.height
      };
      this.position.x = (diffSize.width / 2) + this.offset.x;
      return this.position.y = (diffSize.height / 2) + this.offset.y;
    };
    "Create World Map";
    worldMap = this.createMap();
    for (_i = 0, _len = worldMap.length; _i < _len; _i++) {
      mapItem = worldMap[_i];
      if (mapItem.width < 10 || mapItem.height < 10) {
        continue;
      }
      mapContainer.addChild(mapItem);
    }
    "count = 0\nsetInterval (() ->\n\n  mapContainer.addChild worldMap[count++]\n  console.log worldMap[count].width, worldMap[count].height\n), 50";
    this.pathContainer = new Gotham.Graphics.Graphics();
    mapContainer.addChild(this.pathContainer);
    "Create a container for all nodes";
    this.nodeContainer = nodeContainer = new Gotham.Graphics.Graphics;
    mapContainer.addChild(nodeContainer);
    "Determine Center of the map and create a red dot";
    middle = new Gotham.Graphics.Graphics();
    middle.lineStyle(0);
    middle.beginFill(0xff0000, 1);
    middle.drawCircle(this.__width / 2, this.__height / 2, 1);
    mapContainer.addChild(middle);
    return mapContainer;
  };


  /**
   * Creates the World map from json,
   * @method createMap
   * @return {Gotham.Graphics.Sprite[]} Array of all the country polygons
   */

  WorldMapView.prototype.createMap = function() {
    var graphics, graphicsList, hitarea, hoverTexture, key, mapJson, point, polygonList, sprite, texture, that, translatedPoints, worldMap, xory, _i, _j, _len, _len1, _ref;
    that = this;
    mapJson = Gotham.Preload.fetch("map", "json");
    polygonList = Gotham.Graphics.Tools.polygonFromJSON(mapJson, 1, {
      x: this.__mapSize.width / this.__width,
      y: this.__mapSize.height / this.__height
    });
    graphicsList = Gotham.Graphics.Tools.polygonToGraphics(polygonList, true);
    worldMap = [];
    for (key = _i = 0, _len = graphicsList.length; _i < _len; key = ++_i) {
      graphics = graphicsList[key];
      "Generate country texture";
      texture = graphics.generateTexture();
      "Generate country texture, with hover effect";
      graphics.clear();
      graphics.lineStyle(2, 0x000000, 1);
      graphics.beginFill(0xffffff, 0.8);
      graphics.blendMode = PIXI.BLEND_MODES.ADD;
      graphics.drawPolygon(graphics.polygon.points);
      hoverTexture = graphics.generateTexture();
      "Create a country sprite, Using generated textures";
      sprite = new Gotham.Graphics.Sprite(texture);
      sprite.hoverTexture = hoverTexture;
      sprite.position.x = graphics.minX;
      sprite.position.y = graphics.minY;
      "Translate sprite position correctly.\nUse polygon points to determine the position";
      translatedPoints = [];
      xory = 0;
      _ref = graphics.polygon.points;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        point = _ref[_j];
        if (xory++ % 2 === 0) {
          translatedPoints.push(point - sprite.x);
        } else {
          translatedPoints.push(point - sprite.y);
        }
      }
      "Create a hitarea of the translated points\nActivate interaction";
      hitarea = new PIXI.Polygon(translatedPoints);
      sprite.hitArea = hitarea;
      sprite.setInteractive(true);
      "Mouseover callback";
      sprite.mouseover = function(e) {
        setTimeout((function() {
          var country;
          country = Gotham.Util.Geocoding.getCountry(that.currentCoordinates.latitude, that.currentCoordinates.longitude);
          return that.parent.getObject("Bar").updateCountry(country);
        }), 20);
        return this.texture = this.hoverTexture;
      };
      "Mouseout callback";
      sprite.mouseout = function(e) {
        that.parent.getObject("Bar").updateCountry(null);
        return this.texture = this.normalTexture;
      };
      worldMap.push(sprite);
    }
    return worldMap;
  };


  /**
   * Deletes all nodes in the node container
   * @method clearNodeContainer
   */

  WorldMapView.prototype.clearNodeContainer = function() {
    var i, sprite, _i, _len, _ref, _results;
    _ref = this.nodeContainer.children;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      if (i) {
        i.texture.destroy(false);
        sprite = this.nodeContainer.removeChild(i);
        _results.push(sprite = null);
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };


  /**
   * Adds a nopde to the node container
   * @method addNode
   * @param node {Object} The Node ObjECT
   * @param interact {Boolean} Weither the node should be interactive or not
   */

  WorldMapView.prototype.addNode = function(node, interact) {
    var activatedMarker, coordinates, deactivatedMarker, gNode;
    coordinates = this.coordinateToPixel(node.lat, node.lng);
    deactivatedMarker = Gotham.Preload.fetch("map_marker_deactivated", "image");
    activatedMarker = Gotham.Preload.fetch("map_marker", "image");
    gNode = new Gotham.Graphics.Sprite(activatedMarker);
    gNode.tint = 0xF8E23B;
    gNode.deactivated_marker = deactivatedMarker;
    gNode.activated_marker = gNode.texture;
    gNode.position = {
      x: coordinates.x,
      y: coordinates.y
    };
    gNode.originalScale = {
      x: gNode.scale.x,
      y: gNode.scale.y
    };
    gNode.width = 8;
    gNode.height = 8;
    gNode.anchor = {
      x: 0.4,
      y: 0.4
    };
    node.sprite = gNode;
    this.nodeContainer.addChild(gNode);
    if (interact) {
      this.addNodeInteraction(node);
    }
  };


  /**
   * Adds interaction to a node, Typically hovering it showing cables.
   * @method addNodeInteraction
   * @param node {Node}
   */

  WorldMapView.prototype.addNodeInteraction = function(node) {
    var nodeHover, that;
    that = this;
    node.sprite.interactive = true;
    node.sprite.buttonMode = true;
    nodeHover = function(node, tint, visible) {
      var cable, part, _cable, _i, _j, _len, _len1, _ref, _ref1;
      if (GothamGame.Globals.showCables) {
        visible = true;
      }
      that.parent.getObject("Bar").updateCountry(node.Country);
      node.sprite.tint = tint;
      _ref = node.Cables;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _cable = _ref[_i];
        cable = Gotham.Database.table("cable").findOne({
          id: _cable.id
        });
        if (!cable) {
          return;
        }
        _ref1 = cable.CableParts;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          part = _ref1[_j];
          part.visible = visible;
        }
      }
    };
    node.sprite.rightclick = function() {
      var db_blacklist, element;
      db_blacklist = Gotham.Database.table("blacklist");
      element = db_blacklist.findOne({
        node: node.id
      });
      if (!element) {
        db_blacklist.insert({
          node: node.id
        });
        GothamGame.Announce.message("Disabled " + node.name + " (" + node.id + ")", "NORMAL", 50);
        this.texture = this.deactivated_marker;
      } else {
        db_blacklist.remove(element);
        GothamGame.Announce.message("Enabled " + node.name + " (" + node.id + ")", "NORMAL", 50);
        this.texture = this.activated_marker;
      }
      return that.scaleNodes();
    };
    node.sprite.click = function() {
      var _i, _info_frames, _len, _ref;
      this._toggle = !this._toggle ? true : !this._toggle;
      if (this._toggle) {
        if (!this.infoFrame) {
          this.infoFrame = that.nodeInfoFrame(node);
          this.addChild(this.infoFrame);
        }
        this.infoFrame.visible = true;
        that.shopOnNodeClick(node);
        _ref = that._visible_info_frames;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          _info_frames = _ref[_i];
          _info_frames.visible = false;
          that._visible_info_frames.remove(_info_frames);
        }
        that._visible_info_frames.push(this.infoFrame);
        return this.bringToFront();
      } else {
        this.infoFrame.visible = false;
        return that._visible_info_frames.remove(this.infoFrame);
      }
    };
    node.sprite.mouseover = function() {
      return nodeHover(node, 0xFF0000, true);
    };
    return node.sprite.mouseout = function() {
      return nodeHover(node, 0xF8E23B, false);
    };
  };


  /**
   * Shows the node-details selector in HTML (GothShark)
   * @method showNodeDetails
   */

  WorldMapView.prototype.showNodeDetails = function(node) {
    this.parent.getObject("Gothshark").setNode(node);
    $("#gothshark_frame").fadeIn();
    $("thead tr td")[0].click();
    return $("thead tr td")[0].click();
  };


  /**
   * Hides the node-details selector in HTML (GothShark)
   * @method hideNodeDetails
   */

  WorldMapView.prototype.hideNodeDetails = function() {
    return $("#gothshark_frame").fadeOut();
  };


  /**
   * Set the cable visibility
   * @method setCableVisibility
   * @param {Boolean} visible
   */

  WorldMapView.prototype.setCableVisibility = function(visible) {
    var cable, cables, part, _i, _len, _results;
    cables = Gotham.Database.table("cable").find();
    _results = [];
    for (_i = 0, _len = cables.length; _i < _len; _i++) {
      cable = cables[_i];
      _results.push((function() {
        var _j, _len1, _ref, _results1;
        _ref = cable.CableParts;
        _results1 = [];
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          part = _ref[_j];
          _results1.push(part.visible = visible);
        }
        return _results1;
      })());
    }
    return _results;
  };


  /**
   * Creates the information plate of each of the node,
   * @method nodeInfoFrame
   * @param node {Gotham.Graphics.Sprite} The node object
   * @return {Gotham.Graphics.Sprite} The newly created sprite (Info Frame)
   */

  WorldMapView.prototype.nodeInfoFrame = function(node) {
    var infoFrame, infoFrameMask, nodeIP, nodeLoad, nodeName, nodeTime, nowthen, that, utc, wireShark;
    that = this;
    infoFrame = new Gotham.Graphics.Sprite(Gotham.Preload.fetch("node_details", "image"));
    infoFrame.visible = false;
    infoFrame.interactive = true;
    infoFrameMask = new Gotham.Graphics.Graphics;
    infoFrameMask.beginFill(0x00ff00, 0.2);
    infoFrameMask.drawRect(0, 0, infoFrame.width - 5, infoFrame.height);
    infoFrame.addChild(infoFrameMask);
    infoFrame.mask = infoFrameMask;
    if (node.sprite === null) {
      return infoFrame;
    }
    nodeName = new Gotham.Graphics.Text("Name: " + node.name, {
      font: "bold 70px calibri",
      fill: "#ffffff",
      dropShadow: true,
      align: "center"
    });
    nodeName.x = 80;
    nodeName.y = 30;
    nodeName.width = 260;
    infoFrame.addChild(nodeName);
    nodeLoad = new Gotham.Graphics.Text("Load: " + ((node.load * 100).toFixed(2)), {
      font: "bold 70px calibri",
      dropShadow: true,
      fill: "#ffffff",
      align: "center"
    });
    nodeLoad.x = 80;
    nodeLoad.y = 100;
    nodeLoad.width = 260;
    infoFrame.addChild(nodeLoad);
    infoFrame.nodeLoad = nodeLoad;
    utc = moment().utcOffset('+0000');
    utc.subtract(utc.hours(), "hours");
    utc.minutes(utc.minutes(), "minutes");
    utc.add(12, 'hours');
    nowthen = utc.add(node.time, "minutes");
    nodeTime = new Gotham.Graphics.Text("Time: " + (nowthen.format('H:mm')), {
      font: "bold 70px calibri",
      fill: "#ffffff",
      dropShadow: true,
      align: "center"
    });
    nodeTime.x = 80;
    nodeTime.y = 170;
    nodeTime.width = 260;
    infoFrame.addChild(nodeTime);
    infoFrame.nodeTime = nodeTime;
    nodeIP = new Gotham.Graphics.Text("IP: " + node.Network.external_ip_v4, {
      font: "bold 70px calibri",
      fill: "#ffffff",
      dropShadow: true,
      align: "center"
    });
    nodeIP.x = 80;
    nodeIP.y = 240;
    infoFrame.addChild(nodeIP);
    wireShark = new Gotham.Controls.Button("Sniff", 300, 150, {
      textSize: 70
    });
    wireShark.x = 140;
    wireShark.y = 350;
    infoFrame.addChild(wireShark);
    infoFrame.click = function() {
      var tween;
      this.ready = !this.ready ? true : this.ready;
      if (this.ready) {
        infoFrame.visible = false;
        this.ready = false;
        that.mapContainer.interactive = false;
        that.mapContainer.isDragging = false;
        tween = that.zoomMap(0.4, 400);
        return tween.onComplete(function(tweenObj) {
          that.mapContainer.offset = {
            y: -305,
            x: 0
          };
          that.mapContainer.interactive = true;
          that.showNodeDetails(node);
          return this.ready = true;
        });
      }
    };
    return infoFrame;
  };


  /**
   * Clears the pathContainer, This is typically Traceroutes
   * @method clearAnimatePath
   */

  WorldMapView.prototype.clearAnimatePath = function() {
    var child, _i, _len, _ref;
    if (!this.pathContainer) {
      return;
    }
    _ref = this.pathContainer.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      child.tween.stop();
    }
    return this.pathContainer.children = [];
  };


  /**
   * Create a animated attack sequence between two coordinates
   * Parameters are as folloiwng
   * @method animateAttack
   * @param source {Object} Source Data
   * @param target {Object} Target Data
   * @example Input format
   *   source =
   *     latitude: ""
   *     longitude: ""
   *     country: ""
   *     company: ""
   *   target =
   *     latitude: ""
   *     longitude: ""
   *     country: ""
   *     city: ""
   *     company: ""
   */

  WorldMapView.prototype.animateAttack = function(source, target) {
    var diff, distance, endModifier, lazer, length, sourcePixel, t, targetPixel, that, tween;
    if (target.country === "O1") {
      return;
    }
    that = this;
    sourcePixel = this.coordinateToPixel(source.latitude, source.longitude);
    targetPixel = this.coordinateToPixel(target.latitude, target.longitude);
    lazer = new Gotham.Graphics.Graphics();
    lazer.visible = true;
    lazer.lineStyle(3, 0xff00ff, 1);
    this.nodeContainer.addChild(lazer);
    diff = {
      x: targetPixel.x - sourcePixel.x,
      y: targetPixel.y - sourcePixel.y
    };
    distance = Math.sqrt((Math.pow(diff.x, 2)) + (Math.pow(diff.y, 2)));
    length = 20.0;
    endModifier = length / distance;
    t = distance / 0.4;
    tween = new Gotham.Tween(lazer);
    tween.to({}, t);
    tween.onUpdate(function(chainItem) {
      var elapsed, points;
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration;
      points = {
        start: {
          x: sourcePixel.x + diff.x * Math.max(elapsed, 0),
          y: sourcePixel.y + diff.y * Math.max(elapsed, 0)
        },
        end: {
          x: sourcePixel.x + diff.x * Math.min(elapsed + endModifier, 1),
          y: sourcePixel.y + diff.y * Math.min(elapsed + endModifier, 1)
        }
      };
      lazer.clear();
      lazer.lineStyle(3, 0xff00ff, 1);
      lazer.moveTo(points.start.x, points.start.y);
      return lazer.lineTo(points.end.x, points.end.y);
    });
    tween.onComplete(function() {
      return that.nodeContainer.removeChild(lazer);
    });
    return tween.start();
  };


  /**
   * Creates a animated line between two nodes
   *
   * @method animatePath
   * @param startNode {Node} starting node
   * @param endNode {Node} End Node
   * @return {Tween} The tween object for the animation
   */

  WorldMapView.prototype.animatePath = function(startNode, endNode) {
    var animationGraphics, diff, gCable, path, tween;
    path = {
      start: this.coordinateToPixel(startNode.lat, startNode.lng),
      end: this.coordinateToPixel(endNode.lat, endNode.lng)
    };
    gCable = new Gotham.Graphics.Graphics();
    gCable.visible = true;
    gCable.lineStyle(3, 0xff00ff, 1);
    gCable.moveTo(path.start.x, path.start.y);
    gCable.lineTo(path.end.x, path.end.y);
    this.pathContainer.addChild(gCable);
    animationGraphics = new Gotham.Graphics.Graphics();
    animationGraphics.visible = true;
    animationGraphics.blendMode = PIXI.BLEND_MODES.ADD;
    gCable.addChild(animationGraphics);
    diff = {
      x: path.end.x - path.start.x,
      y: path.end.y - path.start.y
    };
    tween = new Gotham.Tween();
    gCable.tween = tween;
    tween.repeat(Infinity);
    tween.to({}, 1500);
    tween.onUpdate(function(chainItem) {
      var elapsed, points;
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration;
      points = {
        start: {
          x: path.start.x + diff.x * Math.max(elapsed - 0, 0),
          y: path.start.y + diff.y * Math.max(elapsed - 0, 0)
        },
        end: {
          x: path.start.x + diff.x * Math.min(elapsed + 0.1, 1),
          y: path.start.y + diff.y * Math.min(elapsed + 0.1, 1)
        }
      };
      animationGraphics.clear();
      animationGraphics.lineStyle(1, 0x00ff00, 1);
      animationGraphics.moveTo(points.start.x, points.start.y);
      return animationGraphics.lineTo(points.end.x, points.end.y);
    });
    return tween;
  };


  /**
   * Adds a cable and draws it between two nodes (Sibling)
   * @method addCable
   * @param cable {Object}
   */

  WorldMapView.prototype.addCable = function(cable) {
    var cablePartsGraphics, currentLocation, graphics, partData, _i, _len, _ref;
    graphics = new Gotham.Graphics.Graphics();
    graphics.visible = GothamGame.Globals.showCables;
    if (cable.CableType.id === 1) {
      graphics.lineStyle(1, 0x3399FF, 1);
    } else {
      graphics.lineStyle(1, 0x009900, 1);
    }
    graphics.coordinates = {
      start: null,
      end: null
    };
    cablePartsGraphics = [];
    _ref = cable.CableParts;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      partData = _ref[_i];
      currentLocation = this.coordinateToPixel(partData.lat, partData.lng);
      if (partData.number === 0) {
        graphics.coordinates.start = currentLocation;
        graphics.moveTo(currentLocation.x, currentLocation.y);
        cablePartsGraphics.push(graphics);
      } else {
        graphics.coordinates.end = currentLocation;
        graphics.lineTo(currentLocation.x, currentLocation.y);
      }
    }
    cable.CableParts = cablePartsGraphics;
    return this.nodeContainer.addChild(graphics);
  };


  /**
   * Adds a network to the worldMap
   * @method addNetwork
   * @param host [Host] Host object
   * @param lat [Double] Latitude position
   * @param lng [Double Longitude position
   * @param isPlayer [Boolean] If its the player
   */

  WorldMapView.prototype.addNetwork = function(network, isPlayer) {
    var animationGraphics, cable, gCable, networkNode, tween;
    networkNode = {
      lat: network.lat,
      lng: network.lng,
      sprite: null
    };
    this.addNode(networkNode, false);
    networkNode.sprite.width = 16;
    networkNode.sprite.height = 16;
    networkNode.sprite.tint = 0x00ff00;
    return networkNode.sprite;
    return;
    cable = {
      start: this.coordinateToPixel(network.lat, network.lng),
      end: this.coordinateToPixel(network.Node.lat, network.Node.lng)
    };
    gCable = new Gotham.Graphics.Graphics();
    gCable.visible = true;
    gCable.lineStyle(5, 0xff0000, 1);
    gCable.moveTo(cable.start.x, cable.start.y);
    gCable.lineTo(cable.end.x, cable.end.y);
    this.nodeContainer.addChild(gCable);
    animationGraphics = new Gotham.Graphics.Graphics();
    animationGraphics.visible = true;
    animationGraphics.blendMode = PIXI.BLEND_MODES.ADD;
    gCable.addChild(animationGraphics);
    tween = new Gotham.Tween();
    tween.repeat(Infinity);
    tween.to({}, 2500);
    tween.onUpdate(function(chainItem) {
      var elapsed, points;
      elapsed = (performance.now() - chainItem.startTime) / chainItem.duration;
      points = {
        start: {
          x: cable.start.x + (cable.end.x - cable.start.x) * elapsed,
          y: cable.start.y + (cable.end.y - cable.start.y) * elapsed
        },
        end: {
          x: cable.start.x + (cable.end.x - cable.start.x) * Math.min(elapsed + 0.2, 1),
          y: cable.start.y + (cable.end.y - cable.start.y) * Math.min(elapsed + 0.2, 1)
        }
      };
      animationGraphics.clear();
      animationGraphics.lineStyle(2, 0x00ff00, 1);
      animationGraphics.moveTo(points.start.x, points.start.y);
      animationGraphics.lineTo(points.end.x, points.end.y);
      if (elapsed + 0.2 > 1) {
        points = {
          start: {
            x: cable.start.x + (cable.end.x - cable.start.x) * 0,
            y: cable.start.y + (cable.end.y - cable.start.y) * 0
          },
          end: {
            x: cable.start.x + (cable.end.x - cable.start.x) * Math.min(elapsed + 0.2 - 1, 1),
            y: cable.start.y + (cable.end.y - cable.start.y) * Math.min(elapsed + 0.2 - 1, 1)
          }
        };
        animationGraphics.moveTo(points.start.x, points.start.y);
        return animationGraphics.lineTo(points.end.x, points.end.y);
      }
    });
    return tween.start();
  };


  /**
   * Zooms the map to a given Scale, The map is Centered around Width/2 and Height /2
   * The animation is done by tweening
   * @method zoomMap
   * @param scale {Number} The scale number, Usually, never above 1.5
   * @param duration=2000 {Number} The Animation duration
   */

  WorldMapView.prototype.zoomMap = function(scale, duration) {
    var originalScale, that, tween;
    if (duration == null) {
      duration = 400;
    }
    that = this;
    originalScale = {
      x: that.mapContainer.scale.x,
      y: that.mapContainer.scale.y
    };
    tween = new Gotham.Tween(that.mapContainer);
    tween.easing(Gotham.Tween.Easing.Quadratic.In);
    tween.to({
      position: {
        y: 1,
        x: (that.__width / 2) - (that.__width * scale) / 2
      }
    }, duration);
    tween.start();
    tween.onUpdate(function(tweenChain) {
      var diffScale, diffSize, elapsed, factor, nexScale, nextSize, prevSize;
      elapsed = tweenChain.elapsed;
      diffScale = {
        x: (scale - originalScale.x) * elapsed,
        y: (scale - originalScale.y) * elapsed
      };
      nexScale = {
        x: originalScale.x - (diffScale.x * -1),
        y: originalScale.y - (diffScale.y * -1)
      };
      factor = {
        x: (that.__width * nexScale.x) / (that.__width * that.mapContainer.scale.x),
        y: (that.__height * nexScale.y) / (that.__height * that.mapContainer.scale.y)
      };
      prevSize = {
        width: that.__width,
        height: that.__height
      };
      nextSize = {
        width: that.__width * nexScale.x,
        height: that.__height * nexScale.y
      };
      diffSize = {
        width: prevSize.width - nextSize.width,
        height: prevSize.height - nextSize.height
      };
      that.mapContainer.scale.x = nexScale.x;
      that.mapContainer.scale.y = nexScale.y;
      that.mapContainer.offset.x *= factor.x;
      that.mapContainer.offset.y *= factor.y;
      that.mapContainer.position.x = (diffSize.width / 2) + that.mapContainer.offset.x;
      that.mapContainer.position.y = (diffSize.height / 2) + that.mapContainer.offset.y;
      return that.scaleNodes(true);
    });
    return tween;
  };

  return WorldMapView;

})(Gotham.Pattern.MVC.View);

module.exports = WorldMapView;


},{}],78:[function(require,module,exports){

/**
 * The game loading scene. Happens while preloading the game files
 * @class Loading
 * @module Frontend.Scenes
 * @namespace GothamGame.Scenes
 * @extends Gotham.Graphics.Scene
 */
var Loading,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Loading = (function(_super) {
  __extends(Loading, _super);

  function Loading() {
    return Loading.__super__.constructor.apply(this, arguments);
  }

  Loading.prototype.create = function() {
    var background, text, tween;
    background = Gotham.Graphics.Sprite.fromImage('./assets/img/loading_background.jpg');
    background.x = 0;
    background.y = 0;
    background.width = 1920;
    background.height = 1080;
    background.anchor = {
      x: 0.5,
      y: 0.5
    };
    background.position = {
      x: background.width / 2,
      y: background.height / 2
    };
    background.scale = {
      x: 1.4,
      y: 1.4
    };
    this.addChild(background);
    tween = new Gotham.Tween(background);
    tween.repeat(Infinity);
    tween.easing(Gotham.Tween.Easing.Linear.None);
    tween.to({
      scale: {
        x: 1,
        y: 1
      }
    }, 20000);
    tween.start();
    this.documentContainer = new Gotham.Graphics.Container();
    this.addChild(this.documentContainer);
    this.text = text = new Gotham.Graphics.Text("Loading, Please Wait\n0%", {
      font: "bold 90px calibri",
      fill: "#ffffff",
      stroke: "0x808080",
      strokeThickness: 6,
      align: "center"
    });
    text.position = {
      x: 1920 / 2,
      y: 1080 / 3
    };
    text.anchor = {
      x: 0.5,
      y: 0.5
    };
    tween = new Gotham.Tween(text);
    tween.repeat(Infinity);
    tween.easing(Gotham.Tween.Easing.Linear.None);
    tween.to({
      alpha: 0
    }, 1500);
    tween.to({
      alpha: 1
    }, 1500);
    tween.onStart(function() {});
    tween.start();
    return this.addChild(text);
  };

  Loading.prototype.addNetworkItem = function() {};

  Loading.prototype.addAsset = function(name, type, percent) {
    var document, random, tween;
    this._c = !this._c ? 0 : void 0;
    this.text.text = "Loading, Please Wait\n" + percent + "%";
    random = function(min, max) {
      return Math.floor(Math.random() * (max - min)) + min;
    };
    if (type === "Image") {
      document = Gotham.Graphics.Sprite.fromImage('./assets/img/load_image.png');
    } else if (type === "JSON") {
      document = Gotham.Graphics.Sprite.fromImage('./assets/img/load_json.png');
    } else if (type === "Data") {
      document = Gotham.Graphics.Sprite.fromImage('./assets/img/load_data.png');
    } else if (type === "Audio") {
      document = Gotham.Graphics.Sprite.fromImage('./assets/img/load_audio.png');
    }
    document.x = -64;
    document.y = random(600, 900);
    document.alpha = 0.4;
    tween = new Gotham.Tween(document);
    tween.easing(Gotham.Tween.Easing.Linear.None);
    tween.delay(random(0, 20000));
    tween.to({
      position: {
        x: 1960
      }
    }, 10000);
    tween.onStart(function() {});
    tween.onComplete(function() {});
    tween.onUpdate(function(chain) {
      var amplitude, wavelenght;
      amplitude = 1.5;
      wavelenght = 0.01;
      return document.position.y = document.position.y + (Math.sin(document.position.x * wavelenght) * amplitude);
    });
    tween.start();
    this.documentContainer.addChild(document);
  };

  return Loading;

})(Gotham.Graphics.Scene);

module.exports = Loading;


},{}],79:[function(require,module,exports){

/**
 * THe menu scene is running after the loading scene. Options are to Play Game ,
 * @class Menu
 * @module Frontend.Scenes
 * @namespace GothamGame.Scenes
 * @extends Gotham.Graphics.Scene
 */
var Menu,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Menu = (function(_super) {
  __extends(Menu, _super);

  function Menu() {
    return Menu.__super__.constructor.apply(this, arguments);
  }

  Menu.prototype.create = function() {
    var ready, that;
    that = this;
    this.createBackground();
    this.documentContainer = new Gotham.Graphics.Container();
    this.addChild(this.documentContainer);
    this.buttons = [];
    this.addButton("Play Game", function() {
      return GothamGame.Renderer.setScene("World");
    });
    this.addButton("Settings", function() {
      var Settings;
      Settings = new GothamGame.Controllers.Settings("Settings");
      return that.addObject(Settings);
    });
    ready = true;
    this.addButton("About", function() {
      var credits, i, intervalID;
      if (ready) {
        ready = false;
      } else {
        return;
      }
      credits = [["                 Introducing               ", 60, 0], ["Project Development       Per-Arne Andersen", 40, 0], ["Project Development       Paul Richard Lilleland", 40, 0], ["                                                ", 40, 1000], ["                   Thanks to                    ", 60, 0], ["Supervisor                 Christian Auby       ", 60, 0], ["Supervisor                 Sigurd Kristian Brinch", 60, 0], ["Assisting Supervisor       Morten Goodwin       ", 60, 0], ["                                                ", 40, 1000], ["              Special Thanks to                 ", 60, 0], ["Library Provider          PIXI.js Team          ", 40, 0], ["Library Provider          Howler.js Team        ", 40, 0], ["Library Provider          Socket.IO Team        ", 40, 0], ["Library Provider          JQuery Team           ", 40, 0], ["Library Provider          Sequelize Team        ", 40, 0], ["Library Provider          TaffyDB Team          ", 40, 0], ["Library Provider          nHibernate Team       ", 40, 0], ["                                                ", 40, 1000], ["               Other Technologies               ", 60, 0], ["                    MariaDB                     ", 60, 0], ["                    nginx                       ", 60, 0], ["                  Google Maps                   ", 60, 0], ["                    Node.JS                     ", 60, 0]];
      i = 0;
      return intervalID = setInterval((function() {
        var item, text, tween;
        item = credits[i++];
        text = new Gotham.Graphics.Text(item[0], {
          font: "bold " + item[1] + "px calibri",
          stroke: "#000000",
          strokeThickness: 4,
          fill: "#ffffff",
          align: "left",
          dropShadow: true
        });
        text.anchor = {
          x: 0.5,
          y: 0.5
        };
        text.x = 1920 / 2;
        text.y = 1080;
        text.alpha = 0;
        that.addChild(text);
        tween = new Gotham.Tween(text);
        tween.delay(item[2]);
        tween.to({
          y: 800,
          alpha: 1
        }, 2000);
        tween.to({
          y: 300
        }, 7000);
        tween.to({
          y: 200,
          alpha: 0
        }, 1300);
        tween.onComplete(function() {
          return that.removeChild(text);
        });
        tween.start();
        if (i >= credits.length) {
          ready = true;
          return clearInterval(intervalID);
        }
      }), 1000);
    });
    this.addButton("Exit", function() {
      return window.location.href = "http://gotham.no";
    });
    this.drawButtons();
    return this.setupMusic();
  };

  Menu.prototype.setupMusic = function() {
    var sound;
    sound = Gotham.Preload.fetch("menu_theme", "audio");
    sound.volume(0.5);
    sound.loop(true);
    return sound.play();
  };

  Menu.prototype.createBackground = function() {
    var gameTitle, originalScale, originalTitleScale, sprite, swap, texture, texture2, textures, tween;
    this.gameTitle = gameTitle = new Gotham.Graphics.Text("Gotham", {
      font: "bold 100px Orbitron",
      fill: "#000000",
      align: "center",
      stroke: "#FFFFFF",
      strokeThickness: 4
    });
    gameTitle.x = 1920 / 2;
    gameTitle.y = 125;
    gameTitle.anchor = {
      x: 0.5,
      y: 0.5
    };
    originalTitleScale = {
      x: gameTitle.scale.x,
      y: gameTitle.scale.y
    };
    tween = new Gotham.Tween(gameTitle);
    tween.repeat(Infinity);
    tween.easing(Gotham.Tween.Easing.Linear.None);
    tween.to({
      scale: {
        x: originalTitleScale.x + 0.2,
        y: originalTitleScale.y + 0.2
      }
    }, 10000);
    tween.to({
      scale: {
        x: originalTitleScale.x,
        y: originalTitleScale.y
      }
    }, 10000);
    tween.start();
    texture = Gotham.Preload.fetch("menu_background", "image");
    texture2 = Gotham.Preload.fetch("menu_background2", "image");
    textures = [texture, texture2];
    swap = function() {
      var next;
      next = textures.shift();
      textures.push(next);
      return next;
    };
    sprite = new Gotham.Graphics.Sprite(swap());
    sprite.width = 1920;
    sprite.height = 1080;
    sprite.alpha = 1;
    sprite.anchor = {
      x: 0.5,
      y: 0.5
    };
    sprite.position = {
      x: sprite.width / 2,
      y: sprite.height / 2
    };
    originalScale = {
      x: sprite.scale.x,
      y: sprite.scale.y
    };
    tween = new Gotham.Tween(sprite);
    tween.repeat(Infinity);
    tween.easing(Gotham.Tween.Easing.Linear.None);
    tween.to({
      scale: {
        x: originalScale.x + 0.8,
        y: originalScale.y + 0.8
      }
    }, 80000);
    tween.delay(2000);
    tween.to({
      alpha: 0
    }, 5000);
    tween.to({
      scale: {
        x: originalScale.x,
        y: originalScale.y
      }
    }, 1);
    tween.func(function() {
      return sprite.texture = swap();
    });
    tween.to({
      alpha: 1
    }, 2000);
    tween.start();
    this.addChild(sprite);
    return this.addChild(gameTitle);
  };

  Menu.prototype.addButton = function(text, onClick) {
    var hoverTexture, sprite, texture, that;
    texture = Gotham.Preload.fetch("menu_button", "image");
    hoverTexture = Gotham.Preload.fetch("menu_button_hover", "image");
    sprite = new Gotham.Graphics.Sprite(texture);
    sprite.width = 300;
    sprite.height = 100;
    sprite.originalScale = sprite.scale;
    sprite.anchor = {
      x: 0.5,
      y: 0.5
    };
    sprite.interactive = true;
    sprite.buttonMode = true;
    text = new Gotham.Graphics.Text(text, {
      font: "bold 70px Arial",
      fill: "#ffffff",
      align: "center",
      dropShadow: true
    }, 0, 0);
    text.anchor = {
      x: 0.5,
      y: 0.5
    };
    text.x = 0;
    text.y = 0;
    sprite.mouseover = function(mouseData) {
      var sound;
      this.texture = hoverTexture;
      sound = Gotham.Preload.fetch("button_click_1", "audio");
      sound.volume(0.5);
      sound.loop(false);
      return sound.play();
    };
    that = this;
    sprite.mouseout = function(mouseData) {
      return this.texture = texture;
    };
    sprite.click = function(mouseData) {
      return onClick(mouseData);
    };
    sprite.addChild(text);
    return this.buttons.push(sprite);
  };

  Menu.prototype.drawButtons = function() {
    var button, counter, startX, startY, _i, _len, _ref, _results;
    startX = 1920 / 2;
    startY = 350;
    counter = 0;
    _ref = this.buttons;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      button = _ref[_i];
      button.x = startX;
      button.y = startY + (counter * (button.height + 10));
      counter++;
      _results.push(this.addChild(button));
    }
    return _results;
  };

  return Menu;

})(Gotham.Graphics.Scene);

module.exports = Menu;


},{}],80:[function(require,module,exports){

/**
 * The World Scene is the Main Game Scene. All objects of the game is created here.
 * @class World
 * @module Frontend.Scenes
 * @namespace GothamGame.Scenes
 * @extends Gotham.Graphics.Scene
 */
var World,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

World = (function(_super) {
  __extends(World, _super);

  function World() {
    return World.__super__.constructor.apply(this, arguments);
  }

  World.prototype.create = function() {
    var Bar, Gothshark, Help, IdentityManagement, Mission, NodeList, Shop, UserManagement, WorldMap;
    WorldMap = new GothamGame.Controllers.WorldMap("WorldMap");
    this.addObject(WorldMap);
    Bar = new GothamGame.Controllers.Bar("Bar");
    this.addObject(Bar);
    IdentityManagement = new GothamGame.Controllers.Identity("Identity");
    this.addObject(IdentityManagement);
    UserManagement = new GothamGame.Controllers.User("User");
    this.addObject(UserManagement);
    NodeList = new GothamGame.Controllers.NodeList("NodeList");
    this.addObject(NodeList);
    Mission = new GothamGame.Controllers.Mission("Mission");
    this.addObject(Mission);
    Shop = new GothamGame.Controllers.Shop("Shop");
    this.addObject(Shop);
    Gothshark = new GothamGame.Controllers.Gothshark("Gothshark");
    this.addObject(Gothshark);
    Help = new GothamGame.Controllers.Help("Help");
    this.addObject(Help);
    return this.addObject(GothamGame.Announce);
  };

  return World;

})(Gotham.Graphics.Scene);

module.exports = World;


},{}],81:[function(require,module,exports){
var ColorUtil;

ColorUtil = (function() {
  var percentColors;

  function ColorUtil() {}

  percentColors = [
    {
      pct: 0.0,
      color: {
        r: 0x00,
        g: 0xff,
        b: 0
      }
    }, {
      pct: 0.5,
      color: {
        r: 0xff,
        g: 0xff,
        b: 0
      }
    }, {
      pct: 1.0,
      color: {
        r: 0xff,
        g: 0x00,
        b: 0
      }
    }
  ];

  ColorUtil.getColorForPercentage = function(pct) {
    var color, i, lower, pctLower, pctUpper, range, rangePct, toHex, upper;
    i = 1;
    while (i < percentColors.length - 1) {
      if (pct < percentColors[i].pct) {
        break;
      }
      i++;
    }
    lower = percentColors[i - 1];
    upper = percentColors[i];
    range = upper.pct - lower.pct;
    rangePct = (pct - lower.pct) / range;
    pctLower = 1 - rangePct;
    pctUpper = rangePct;
    color = {
      r: Math.floor(lower.color.r * pctLower + upper.color.r * pctUpper),
      g: Math.floor(lower.color.g * pctLower + upper.color.g * pctUpper),
      b: Math.floor(lower.color.b * pctLower + upper.color.b * pctUpper)
    };
    toHex = function(c) {
      var hex;
      hex = c.toString(16);
      if (hex.length === 1) {
        return '0' + hex;
      } else {
        return hex;
      }
    };
    return "0x" + toHex(color.r) + toHex(color.g) + toHex(color.b);
    return 'rgb(' + [color.r, color.g, color.b].join(',') + ')';
  };

  return ColorUtil;

})();

module.exports = ColorUtil;


},{}],82:[function(require,module,exports){

/**
 * Tools for Host / IP validation
 * @class HostUtils
 * @module Frontend.Tools
 * @namespace GothamGame.Tools
 */
var HostUtils;

HostUtils = (function() {
  function HostUtils() {}

  HostUtils.validIP = function(ipaddress) {
    if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(myForm.emailAddr.value)) {
      return true;
    }
    return false;
  };

  HostUtils.validIPHost = function(str) {
    return /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$|^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$|^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/.test(str);
  };

  return HostUtils;

})();

module.exports = HostUtils;


},{}]},{},[53]);