#lang pollen

◊define-meta[title]{Pretzel}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊group['dry
  ◊ingredient[
   ◊name{Unbleached all-purpose flour}
   ◊quantity{2 ◊fraction[1 2] cups}
  ]
  ◊ingredient[
   ◊name{Salt}
   ◊quantity{1 ◊fraction[1 2] teaspoons}
  ]
  ◊ingredient[
   ◊name{Granulated sugar}
   ◊quantity{1 ◊fraction[1 2] teaspoons}
  ]
  ◊ingredient[
   ◊name{Instant yeast}
   ◊quantity{2 ◊fraction[1 4] teaspoons}
  ]
 ]
 ◊group['wet
  ◊ingredient[
   ◊name{Water}
   ◊quantity{From ◊fraction[3 4] to 1 cup}
  ]
 ]
 ◊group['bath
  ◊ingredient[
   ◊name{Water}
   ◊quantity{1 cup}
  ]
  ◊ingredient[
   ◊name{Baking soda}
   ◊quantity{2 tablespoons}
  ]
 ]
 ◊group['topping
  ◊ingredient[
   ◊name{Coarse salt}
   ◊quantity{To taste}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊step[
  ◊temperature{475 °F}
  ◊duration{12 minutes}
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
