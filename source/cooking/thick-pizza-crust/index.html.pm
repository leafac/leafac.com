#lang pollen

◊define-meta[title]{Thick Pizza Crust}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊group['yeast
  ◊ingredient[
   ◊name{Active dry yeast}
   ◊quantity{1 package}
  ]
  ◊ingredient[
   ◊name{Sugar}
   ◊quantity{1 teaspoons}
  ]
  ◊ingredient[
   ◊name{Water at 110 °F}
   ◊quantity{1 cup}
  ]
 ]
 ◊group['wet
  ◊ingredient[
   ◊name{Water at 110 °F}
   ◊quantity{◊fraction[1 2] cup}
  ]
  ◊ingredient[
   ◊name{Olive oil}
   ◊quantity{3 tablepoons}
  ]
 ]
 ◊group['dry
  ◊ingredient[
   ◊name{Bread flour}
   ◊quantity{3 ◊fraction[1 2] cups}
  ]
  ◊ingredient[
   ◊name{Salt}
   ◊quantity{2 teaspoons}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊step[
  ◊temperature{450 °F}
  ◊duration{20 minutes}
 ]
]

◊section['directions]{Directions}

◊directions[
 ◊direction{On a bowl, activate the yeast by mixing: ◊ingredients/repeat['yeast]}
 ◊direction{Wait for 5–10 minutes until foamy.}
 ◊direction{Mix in the wet ingredients: ◊ingredients/repeat['wet]}
 ◊direction{Mix in the dry ingredients: ◊ingredients/repeat['dry]}
 ◊direction{Cover the bowl.}
 ◊direction{Let the dough rise on a warm place for 1 hour.}
 ◊direction{Split the dough in two equal parts.}
 ◊direction{Shape each part into a ball.}
 ◊direction{On a pizza pan, roll each ball into a thin crust.}
 ◊direction{With a fork, pinch holes all over the crusts.}
 ◊direction{Coat the crusts in olive oil.}
 ◊direction{Add tomato sauce and toppings.}
 ◊direction{Bake: ◊baking/repeat[]}
]

◊section['serving]{Serving}

2 pizza crusts.

◊section['sources]{Sources}

◊sources[
 ◊source{◊reference{http://allrecipes.com/recipe/20171/quick-and-easy-pizza-crust/}}
 ◊source{◊reference{http://allrecipes.com/video/1075/quick-and-easy-pizza-crust/}}
]
