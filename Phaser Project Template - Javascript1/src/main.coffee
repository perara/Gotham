

Gotham = require './GOTHAM/Gotham.coffee'


console.log Gotham.Preload.add
Gotham.Preload.image("http://blog.jimdo.com/wp-content/uploads/2014/01/tree-247122.jpg", "item", "jpg")
Gotham.Preload.image("http://www.joomlaworks.net/images/demos/galleries/abstract/7.jpg", "item", "jpg")
Gotham.Preload.image("http://blog.queensland.com/wp-content/uploads/2013/08/damien-leze_wide_angle_1.jpg", "item", "jpg")
Gotham.Preload.image("http://static3.businessinsider.com/image/52cddfb169beddee2a6c2246/the-29-coolest-us-air-force-images-of-the-year.jpg", "item", "jpg")
Gotham.Preload.mp3("./assets/audio/menu.mp3", "boud")

# OnLoad Callback
Gotham.Preload.onLoad (source, name, percent) ->
  console.log(percent)
