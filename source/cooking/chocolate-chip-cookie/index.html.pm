#lang pollen

◊define-meta[title]{Chocolate Chip Cookie}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['base]{
  ◊ingredient{
   ◊ingredient/name{Coconut oil}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Cocoa powder}
   ◊ingredient/quantity{2 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Granulated sugar}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Light brown sugar}
   ◊ingredient/quantity{◊fraction[1 3] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Almond milk}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Golden flaxseed meal}
   ◊ingredient/quantity{1 tablespoon}
  }
  ◊ingredient{
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{2 teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{◊fraction[1 8] teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Baking soda}
   ◊ingredient/quantity{◊fraction[1 2] teaspoon}
  }
 }
 ◊ingredients/section['flour]{
  ◊ingredient{
   ◊ingredient/name{Bleached all-purpose flour}
   ◊ingredient/quantity{1 ◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Chocolate chips}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
 }
}

◊section['baking]{Baking}

◊baking{
 ◊baking-step{
  ◊baking-step/temperature{350 °F}
  ◊baking-step/duration{12 minutes}
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a bowl, mix base ingredients one by one: ◊ingredients/repeat['base]}
 ◊direction{Mix in the flour and cholocate chips in two steps: ◊ingredients/repeat['flour]}
 ◊direction{Shape the dough into cookies on a parchment paper. The cookie size—and, thus, the quantity—varies to taste.}
 ◊direction{Bake: ◊baking/repeat[]}
 ◊direction{Let it rest on a cooling rack.}
}

◊section['serving]{Serving}

Around 12 cookies, depending on the size.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link["http://www.theppk.com/2013/10/rosemary-chocolate-chip-cookies-video/"]}
}
