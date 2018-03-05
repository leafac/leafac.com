#lang pollen

◊define-meta[title]{Brownie}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊ingredients/section['flax-egg
  ◊ingredient[
   ◊ingredient/name{Golden flaxseed meal}
   ◊ingredient/quantity{2 tablespoons}
  ]
  ◊ingredient[
   ◊ingredient/name{Water}
   ◊ingredient/quantity{5 tablespoons}
  ]
 ]
 ◊ingredients/section['base
  ◊ingredient[
   ◊ingredient/name{Coconut oil}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  ]
  ◊ingredient[
   ◊ingredient/name{Granulated sugar}
   ◊ingredient/quantity{◊fraction[3 4] cup}
  ]
  ◊ingredient[
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{2 teaspoons}
  ]
  ◊ingredient[
   ◊ingredient/name{Baking powder}
   ◊ingredient/quantity{◊fraction[3 4] teaspoon}
  ]
  ◊ingredient[
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{◊fraction[1 8] teaspoon}
  ]
  ◊ingredient[
   ◊ingredient/name{Cocoa powder}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  ]
 ]
 ◊ingredients/section['flour
  ◊ingredient[
   ◊ingredient/name{Bleached all-purpose flour}
   ◊ingredient/quantity{◊fraction[3 4] cup}
  ]
  ◊ingredient[
   ◊ingredient/name{Chocolate chips}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊baking-step[
  ◊baking-step/temperature{350 °F}
  ◊baking-step/duration{25 minutes}
 ]
]

◊section['directions]{Directions}

◊directions[
 ◊direction{On a bowl, mix ingredients for ◊informal{flax egg}: ◊ingredients/repeat['flax-egg]}
 ◊direction{Wait for 5 minutes.}
 ◊direction{Mix in the ingredients for the base one by one: ◊ingredients/repeat['base]}
 ◊direction{Mix in the flour and cholocate chips in two steps: ◊ingredients/repeat['flour]}
 ◊direction{Shape the dough into brownies on a muffin pan.}
 ◊direction{Bake: ◊baking/repeat[]}
 ◊direction{Let it rest on a cooling rack.}
]

◊section['serving]{Serving}

8 brownies.

◊section['sources]{Sources}

◊sources[
 ◊source{◊reference["http://minimalistbaker.com/simple-vegan-brownies/"]}
]
