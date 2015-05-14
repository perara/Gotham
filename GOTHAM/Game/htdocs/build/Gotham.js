(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// creates a global "addWheelListener" method
//Feature	    Chrome	Firefox (Gecko)	Internet Explorer	Opera	        Safari
//Basic support	  31	  17.0 (17.0)	   9.0[1]	      Not supported	   7.0.5
// example: addWheelListener( elem, function( e ) { console.log( e.deltaY ); e.preventDefault(); } );

module.exports = addWheelListener;

var prefix = "", _addEventListener, onwheel, support;

// detect event model
if ( window.addEventListener ) {
    _addEventListener = "addEventListener";
} else {
    _addEventListener = "attachEvent";
    prefix = "on";
}

// detect available wheel event
support = "onwheel" in document.createElement("div") ? "wheel" : // Modern browsers support "wheel"
    document.onmousewheel !== undefined ? "mousewheel" : // Webkit and IE support at least "mousewheel"
        "DOMMouseScroll"; // let's assume that remaining browsers are older Firefox

function addWheelListener( elem, callback, useCapture ) {
    _addWheelListener( elem, support, callback, useCapture );

    // handle MozMousePixelScroll in older Firefox
    if( support == "DOMMouseScroll" ) {
        _addWheelListener( elem, "MozMousePixelScroll", callback, useCapture );
    }
};

function _addWheelListener( elem, eventName, callback, useCapture ) {
    elem[ _addEventListener ]( prefix + eventName, support == "wheel" ? callback : function( originalEvent ) {
        !originalEvent && ( originalEvent = window.event );

        // create a normalized event object
        var event = {
            // keep a ref to the original event object
            originalEvent: originalEvent,
            target: originalEvent.target || originalEvent.srcElement,
            type: "wheel",
            deltaMode: originalEvent.type == "MozMousePixelScroll" ? 0 : 1,
            deltaX: 0,
            deltaZ: 0,
            preventDefault: function() {
                originalEvent.preventDefault ?
                    originalEvent.preventDefault() :
                    originalEvent.returnValue = false;
            }
        };

        // calculate deltaY (and deltaX) according to the event
        if ( support == "mousewheel" ) {
            event.deltaY = - 1/40 * originalEvent.wheelDelta;
            // Webkit also support wheelDeltaX
            originalEvent.wheelDeltaX && ( event.deltaX = - 1/40 * originalEvent.wheelDeltaX );
        } else {
            event.deltaY = originalEvent.detail;
        }

        // it's time to fire the callback
        return callback( event );

    }, useCapture || false );
}
},{}],2:[function(require,module,exports){
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



},{}],3:[function(require,module,exports){
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
    parent.children[0] = parent.children[parent.children.indexOf(this)];
    return parent.children[parent.children.indexOf(this)] = b;
  }
};

PIXI.Container.prototype.onInteractiveChange = null;

PIXI.Container.prototype.setInteractive = function(state) {
  var item, queue, results1;
  if (this.onInteractiveChange) {
    this.onInteractiveChange(state);
  }
  queue = [];
  queue.push(this);
  results1 = [];
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
      results1.push(item.mouseup = null);
    } else {
      item.click = item.__click;
      item.mousedown = item.__mousedown;
      item.mouseup = item.__mouseup;
      item.__click = null;
      item.__mousedown = null;
      results1.push(item.__mouseup = null);
    }
  }
  return results1;
};

PIXI.Container.prototype.addChildArray = function(array) {
  var child, i, len, results1;
  results1 = [];
  for (i = 0, len = array.length; i < len; i++) {
    child = array[i];
    results1.push(this.addChild(child));
  }
  return results1;
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



},{}],4:[function(require,module,exports){

/*
 * object.watch polyfill
#
 * 2012-04-03
#
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
var mozAddWheelListener;

mozAddWheelListener = require('../Dependencies/mozAddWheelListener');

PIXI.WebGLRenderer.prototype.wheelScrollObjects = [];

PIXI.WebGLRenderer.prototype.addWheelScrollObject = function(object) {
  return this.wheelScrollObjects.push(object);
};

PIXI.WebGLRenderer.prototype.setWheelScroll = function(state) {
  if (state == null) {
    return mozAddWheelListener(this.view, function(e) {});
  } else {
    return mozAddWheelListener(this.view, function(e) {
      var i, len, object, ref, results;
      ref = PIXI.WebGLRenderer.prototype.wheelScrollObjects;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        object = ref[i];
        results.push(object.onWheelScroll(e));
      }
      return results;
    });
  }
};

PIXI.CanvasRenderer.prototype.wheelScrollObjects = [];

PIXI.CanvasRenderer.prototype.addWheelScrollObject = function(object) {
  return this.wheelScrollObjects.push(object);
};

PIXI.CanvasRenderer.prototype.setWheelScroll = function(state) {
  if (state == null) {
    return mozAddWheelListener(this.view, function(e) {});
  } else {
    return mozAddWheelListener(this.view, function(e) {
      var i, len, object, ref, results;
      ref = PIXI.CanvasRenderer.prototype.wheelScrollObjects;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        object = ref[i];
        results.push(object.onWheelScroll(e));
      }
      return results;
    });
  }
};



},{"../Dependencies/mozAddWheelListener":1}],6:[function(require,module,exports){
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



},{"./Extensions/Array.coffee":2,"./Extensions/Container.coffee":3,"./Extensions/Object.coffee":4,"./Extensions/PixiRenderer.coffee":5,"./Extensions/String.coffee":6,"./Modules/Controls/Button.coffee":8,"./Modules/Controls/Slider.coffee":9,"./Modules/Database.coffee":10,"./Modules/GameLoop.coffee":11,"./Modules/Graphics/Container.coffee":12,"./Modules/Graphics/Graphics.coffee":13,"./Modules/Graphics/Polygon.coffee":14,"./Modules/Graphics/Rectangle.coffee":15,"./Modules/Graphics/Sprite.coffee":16,"./Modules/Graphics/Text.coffee":17,"./Modules/Graphics/Texture.coffee":18,"./Modules/Graphics/Tools.coffee":19,"./Modules/Network.coffee":20,"./Modules/Pattern/MVC/Controller.coffee":21,"./Modules/Pattern/MVC/View.coffee":22,"./Modules/Preload.coffee":23,"./Modules/Renderer.coffee":24,"./Modules/Scene.coffee":25,"./Modules/Sound.coffee":26,"./Modules/Tween/Tween.coffee":27,"./Util/Util.coffee":28}],8:[function(require,module,exports){

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Button = (function(superClass) {
  extend(Button, superClass);

  function Button(text, width, height, options) {
    var _alpha, _margin, _offset, _textSize, _texture, _toggle, button_text, that;
    that = this;
    options = options == null ? {} : options;
    _toggle = options.toggle != null ? options.toggle : true;
    _textSize = options.textSize != null ? options.textSize : 40;
    _texture = options.texture != null ? options.texture : null;
    _offset = options.offset ? options.offset : 0;
    _margin = options.margin ? options.margin : 0;
    _alpha = options.alpha != null ? options.alpha : 1;
    this.margin = _margin;
    if (_texture == null) {
      _texture = new Gotham.Graphics.Graphics;
      _texture.beginFill(0x000000, _alpha);
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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Slider = (function(superClass) {
  extend(Slider, superClass);

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
#
 * This is responsible for updating and drawing each frame of
 * the game, It does so by calling requestAnimationFrame.
#
 * In Addition, it also handles the Tween ticks in its update loop
#
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
    var _task, i, len, ref, s;
    this.FPSMeter.tickStart();
    ref = this._tasks;
    for (i = 0, len = ref.length; i < len; i++) {
      _task = ref[i];
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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Container = (function(superClass) {
  var _created;

  extend(Container, superClass);

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Graphics = (function(superClass) {
  extend(Graphics, superClass);

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Polygon = (function(superClass) {
  extend(Polygon, superClass);

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Rectangle = (function(superClass) {
  extend(Rectangle, superClass);

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Sprite = (function(superClass) {
  extend(Sprite, superClass);

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Text = (function(superClass) {
  extend(Text, superClass);

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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Texture = (function(superClass) {
  extend(Texture, superClass);

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
    var _key, count, i, j, key, len, len1, point, pointList, polygon, polygonList;
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
    for (key = i = 0, len = json.length; i < len; key = ++i) {
      polygon = json[key];
      pointList = new Array;
      count = 0;
      for (_key = j = 0, len1 = polygon.length; j < len1; _key = ++j) {
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
    var graphicsList, grp, i, j, key, len, len1, minX, minY, point, polygonList, ref, xory;
    polygonList = [];
    graphicsList = [];
    if (polygon.constructor !== Array) {
      polygonList.push(polygon);
    } else {
      polygonList = polygon;
    }
    for (key = i = 0, len = polygonList.length; i < len; key = ++i) {
      polygon = polygonList[key];
      xory = 0;
      minX = 10000000;
      minY = 10000000;
      ref = polygon.points;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        point = ref[j];
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
    var ref;
    this.host = host;
    this.port = port;
    this.Socket = this._socket = null;
    this.onConnect = function() {};
    this.onReconnect = function() {};
    this.onReconnecting = function() {};
    if ((ref = !port) != null ? ref : this.port = 8080) {

    } else {
      this.port = port;
    }
  }

  Network.prototype.connect = function(callback) {
    var that;
    that = this;
    this.Socket = this._socket = io.connect(this.host + ":" + this.port);
    this._socket.on('connect', function() {
      that.onConnect(this);
      return that.onConnect = function() {};
    });
    this._socket.on('reconnect', function() {
      return that.onReconnect(this);
    });
    return this._socket.on('reconnecting', function() {
      return that.onReconnecting(this);
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
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

View = (function(superClass) {
  extend(View, superClass);

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
#
 * @class Preload
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @example
 *     Gotham.Preload.image("/assets/img/settings_close.png", "settings_close", "image")
 *     Gotham.Preload.json("/assets/json/json.json", "map")
#
 * @example
 *   Gotham.Preload.fetch("map", "json")
 *   Gotham.Preload.fetch("settings_close", "image")
#
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
    var db, dbs, i, len, total;
    dbs = [this.db_audio, this.db_image, this.db_data];
    total = this._numNetworkLoaded;
    for (i = 0, len = dbs.length; i < len; i++) {
      db = dbs[i];
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
#
 * Stages are now Scenes which is now in a {http://en.wikipedia.org/wiki/Scene_graph Scene Graph} Structure
#
 * See {http://www.goodboydigital.com/pixijs/docs/classes/Stage.html PIXI.Stage} for properties
 * @class Scene
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @constructor
 * @extends PIXI.Container
 */
var Scene,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Scene = (function(superClass) {
  extend(Scene, superClass);

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
#
 * Is protects Howl Object so that its not accessible from this class.
#
 * Sound class is generated when preloading the audio file {Preload}
#
 * @class Sound
 * @module Framework
 * @submodule Framework
 * @namespace Gotham
 * @constructor
 * @param
 * @example Creating a sound object
 *   # Preload the audio file
 *   Gotham.Preload.mp3("./assets/audio/menu.mp3", "boud", volume: 0.2)
#
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
  modulo = function(a, b) { return (+a % (b = +b) + b) % b; };

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
    var j, len1, ref, results, tween;
    ref = Tween._tweens;
    results = [];
    for (j = 0, len1 = ref.length; j < len1; j++) {
      tween = ref[j];
      results.push(tween._complete = true);
    }
    return results;
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
    chainItem = this._chain[modulo(this._runCounter, this._chain.length)];
    elapsedTime = (chainItem.endTime - chainItem.startTime) * chainItem.elapsed;
    timeLeft = chainItem.duration - elapsedTime;
    chainItem.endTime = time + timeLeft;
    return chainItem.startTime = chainItem.endTime - chainItem.duration;
  };

  Tween.prototype.easing = function(easing) {
    return this._easing = easing;
  };

  Tween.prototype.to = function(property, duration) {
    var j, len1, newPath, prop, properties, ref, shallow;
    properties = [];
    shallow = false;
    ref = Tween.flattenKeys(property);
    for (j = 0, len1 = ref.length; j < len1; j++) {
      prop = ref[j];
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
    return this.addToChain(newPath);
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
    var j, len1, property, results;
    results = [];
    for (j = 0, len1 = properties.length; j < len1; j++) {
      property = properties[j];
      results.push(this.addProperty(property));
    }
    return results;
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
    var chainItem, elapsed, end, j, key, l, len1, len2, len3, nextPos, o, prop, property, ref, ref1, ref2, results, start, startTime, tween, value;
    Tween._currentTime = time;
    if (Tween._tweens.length <= 0) {
      return;
    }
    ref = Tween._tweens;
    results = [];
    for (j = 0, len1 = ref.length; j < len1; j++) {
      tween = ref[j];
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
      chainItem = tween._chain[modulo(tween._runCounter, tween._chain.length)];
      if (!chainItem.inited) {
        chainItem.startTime = performance.now();
        chainItem.endTime = chainItem.startTime + chainItem.duration;
        chainItem.inited = true;
        if (chainItem.type === "delay") {
          break;
        }
        chainItem.startPos = {};
        ref1 = tween._properties;
        for (l = 0, len2 = ref1.length; l < len2; l++) {
          property = ref1[l];
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
        if (modulo(tween._runCounter, tween._chain.length) === 0) {
          tween._remainingRuns -= 1;
        }
        continue;
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
      ref2 = chainItem.properties;
      for (o = 0, len3 = ref2.length; o < len3; o++) {
        prop = ref2[o];
        if (chainItem.shallow) {
          tween._object[prop] = start[prop] + (end[prop] - start[prop]) * value;
        } else {
          nextPos = Tween.resolve(start, prop) + (Tween.resolve(end, prop) - Tween.resolve(start, prop)) * value;
          Tween.resolve(tween._object, prop, null, nextPos);
        }
      }
      continue;
    }
    return results;
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
    var _key, depth, found, item, queue;
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
},{}]},{},[7]);
