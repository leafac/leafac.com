#lang pollen

◊define-meta[title]{Beer Bread}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊group['dry
  ◊ingredient[
   ◊name{Sifted unbleached flour}
   ◊quantity{3 cups}
  ]
  ◊ingredient[
   ◊name{Baking powder}
   ◊quantity{3 teaspoons}
  ]
  ◊ingredient[
   ◊name{Salt}
   ◊quantity{1 teaspoon}
  ]
  ◊ingredient[
   ◊name{Sugar}
   ◊quantity{◊fraction[1 4] cup}
  ]
 ]
 ◊group['wet
  ◊ingredient[
   ◊name{Beer}
   ◊quantity{1 bottle}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊step[
  ◊temperature{375 °F}
  ◊duration{50 minutes–1 hour}
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
