#lang pollen

◊define-meta[title]{Pretzel}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊ingredients/section['dry
  ◊ingredient[
   ◊ingredient/name{Unbleached all-purpose flour}
   ◊ingredient/quantity{2 ◊fraction[1 2] cups}
  ]
  ◊ingredient[
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{1 ◊fraction[1 2] teaspoons}
  ]
  ◊ingredient[
   ◊ingredient/name{Granulated sugar}
   ◊ingredient/quantity{1 ◊fraction[1 2] teaspoons}
  ]
  ◊ingredient[
   ◊ingredient/name{Instant yeast}
   ◊ingredient/quantity{2 ◊fraction[1 4] teaspoons}
  ]
 ]
 ◊ingredients/section['wet
  ◊ingredient[
   ◊ingredient/name{Water}
   ◊ingredient/quantity{From ◊fraction[3 4] to 1 cup}
  ]
 ]
 ◊ingredients/section['bath
  ◊ingredient[
   ◊ingredient/name{Water}
   ◊ingredient/quantity{1 cup}
  ]
  ◊ingredient[
   ◊ingredient/name{Baking soda}
   ◊ingredient/quantity{2 tablespoons}
  ]
 ]
 ◊ingredients/section['topping
  ◊ingredient[
   ◊ingredient/name{Coarse salt}
   ◊ingredient/quantity{To taste}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊baking-step[
  ◊baking-step/temperature{475 °F}
  ◊baking-step/duration{12 minutes}
 ]
]

◊section['directions]{Directions}

◊directions[
 ◊direction{On a bowl, mix dry ingredients: ◊ingredients/repeat['dry]}
 ◊direction{Mix in the wet ingredients: ◊ingredients/repeat['wet]}
 ◊direction{Cover bowl.}
 ◊direction{Let it rest for 45 minutes.}
 ◊direction{Devide the dough in 10 equal parts.}
 ◊direction{Shape each part into a ball, and then into pretzel form.}
 ◊direction{On a pan, boil water and add the baking soda: ◊ingredients/repeat['bath]}
 ◊direction{Dip pretzels into boiling water for 20 seconds.}
 ◊direction{Add salt on top: ◊ingredients/repeat['topping]}
 ◊direction{Bake: ◊baking/repeat[]}
]

◊section['serving]{Serving}

10 pretzels.

◊section['sources]{Sources}

◊sources[
 ◊source{◊reference["http://www.kingarthurflour.com/recipes/hot-buttered-soft-pretzels-and-pretzel-bites-recipe"]}
]
