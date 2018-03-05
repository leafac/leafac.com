#lang pollen

◊define-meta[title]{Beer Bread}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊ingredients/section['dry
  ◊ingredient[
   ◊ingredient/name{Sifted unbleached flour}
   ◊ingredient/quantity{3 cups}
  ]
  ◊ingredient[
   ◊ingredient/name{Baking powder}
   ◊ingredient/quantity{3 teaspoons}
  ]
  ◊ingredient[
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{1 teaspoon}
  ]
  ◊ingredient[
   ◊ingredient/name{Sugar}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  ]
 ]
 ◊ingredients/section['wet
  ◊ingredient[
   ◊ingredient/name{Beer}
   ◊ingredient/quantity{1 bottle}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊baking-step[
  ◊baking-step/temperature{375 °F}
  ◊baking-step/duration{50 minutes–1 hour}
 ]
]

◊section['directions]{Directions}

◊directions[
 ◊direction{On a bowl, mix the dry ingredients: ◊ingredients/repeat['dry]}
 ◊direction{Mix in the beer: ◊ingredients/repeat['wet]}
 ◊direction{Pour dough into a greased loaf or muffin pan.}
 ◊direction{Brush olive oil on dough.}
 ◊direction{Bake: ◊baking/repeat[]}
]

◊section['serving]{Serving}

1 beer bread loaf.

◊section['sources]{Sources}

◊sources[
 ◊source{◊reference["http://www.food.com/recipe/beer-bread-73440"]}
]
