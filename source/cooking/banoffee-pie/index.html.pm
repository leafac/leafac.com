#lang pollen

◊define-meta[title]{Banoffee Pie}

◊section['ingredients]{Ingredients}

◊ingredients[
 ◊group['caramel/dates
  ◊ingredient[
   ◊name{Dates}
   ◊quantity{1 cup}
  ]
  ◊ingredient[
   ◊name{Water}
   ◊quantity{◊fraction[1 2] cup}
  ]
 ]
 ◊group['base
  ◊ingredient[
   ◊name{Water}
   ◊quantity{2 tablespoons}
  ]
  ◊ingredient[
   ◊name{Coconut oil}
   ◊quantity{4 tablespoons}
  ]
  ◊ingredient[
   ◊name{Dates}
   ◊quantity{4}
  ]
  ◊ingredient[
   ◊name{Almond meal}
   ◊quantity{1 cup}
  ]
  ◊ingredient[
   ◊name{Oats}
   ◊quantity{1 ◊fraction[1 2] cups}
  ]
 ]
 ◊group['caramel/rest
  ◊ingredient[
   ◊name{Vanilla extract}
   ◊quantity{1 teaspoon}
  ]
  ◊ingredient[
   ◊name{Maple syrup}
   ◊quantity{3 tablespoons}
  ]
  ◊ingredient[
   ◊name{Almond or peanut butter}
   ◊quantity{3 tablespoons}
  ]
  ◊ingredient[
   ◊name{Salt}
   ◊quantity{◊fraction[1 8] teaspoon}
  ]
 ]
 ◊group['cream
  ◊ingredient[
   ◊name{Refrigerated coconut cream}
   ◊quantity{1 can}
  ]
  ◊ingredient[
   ◊name{Powdered sugar}
   ◊quantity{2 teaspoons}
  ]
  ◊ingredient[
   ◊name{Vanilla extract}
   ◊quantity{1 teaspoon}
  ]
 ]
 ◊group['toppings
  ◊ingredient[
   ◊name{Banana}
   ◊quantity{1–2}
  ]
  ◊ingredient[
   ◊name{Chocolate sauce}
   ◊quantity{1 tablespoon}
  ]
 ]
]

◊section['baking]{Baking}

◊baking[
 ◊step[
  ◊temperature{355 °F}
  ◊duration{15 minutes}
 ]
]

◊section['directions]{Directions}

◊directions[
 ◊direction{On a bowl, add water to the dates: ◊ingredients/repeat['caramel/dates]}
 ◊direction{Let it rest for 5 minutes.}
 ◊direction{Meanwhile, in a food processor, process the ingredients for base: ◊ingredients/repeat['base]}
 ◊direction{Spread thin the resulting batter on a pie pan.}
 ◊direction{Bake batter: ◊baking/repeat[]}
 ◊direction{Process the soaked dates from before.}
 ◊direction{Mix into the food processor the rest of the ingredients for the caramel: ◊ingredients/repeat['caramel/rest]}
 ◊direction{With a hand mixer, mix ingredients for the cream: ◊ingredients/repeat['cream]}
 ◊direction{Add the caramel, toppings and cream to the crust that came out of the oven: ◊ingredients/repeat['toppings]}
]

◊section['serving]{Serving}

1 pie.

◊section['sources]{Sources}

◊sources[
 ◊source{◊reference["https://www.youtube.com/watch?v=EVTWGrzWM80"]}
]
