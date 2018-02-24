#lang pollen

◊define-meta[title]{Banoffee Pie}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['caramel/dates]{
  ◊ingredient{
   ◊ingredient/name{Dates}
   ◊ingredient/quantity{1 cup}
  }
  ◊ingredient{
   ◊ingredient/name{Water}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
 }
 ◊ingredients/section['base]{
  ◊ingredient{
   ◊ingredient/name{Water}
   ◊ingredient/quantity{2 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Coconut oil}
   ◊ingredient/quantity{4 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Dates}
   ◊ingredient/quantity{4}
  }
  ◊ingredient{
   ◊ingredient/name{Almond meal}
   ◊ingredient/quantity{1 cup}
  }
  ◊ingredient{
   ◊ingredient/name{Oats}
   ◊ingredient/quantity{1 ◊fraction[1 2] cups}
  }
 }
 ◊ingredients/section['caramel/rest]{
  ◊ingredient{
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{1 teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Maple syrup}
   ◊ingredient/quantity{3 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Almond or peanut butter}
   ◊ingredient/quantity{3 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{◊fraction[1 8] teaspoon}
  }
 }
 ◊ingredients/section['cream]{
  ◊ingredient{
   ◊ingredient/name{Refrigerated coconut cream}
   ◊ingredient/quantity{1 can}
  }
  ◊ingredient{
   ◊ingredient/name{Powdered sugar}
   ◊ingredient/quantity{2 teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{1 teaspoon}
  }
 }
 ◊ingredients/section['toppings]{
  ◊ingredient{
   ◊ingredient/name{Banana}
   ◊ingredient/quantity{1–2}
  }
  ◊ingredient{
   ◊ingredient/name{Chocolate sauce}
   ◊ingredient/quantity{1 tablespoon}
  }
 }
}

◊section['baking]{Baking}

◊baking{
 ◊baking-step{
  ◊baking-step/temperature{355 °F}
  ◊baking-step/duration{15 minutes}
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a bowl, add water to the dates: ◊ingredients/repeat['caramel/dates]}
 ◊direction{Let it rest for 5 minutes.}
 ◊direction{Meanwhile, in a food processor, process the ingredients for base: ◊ingredients/repeat['base]}
 ◊direction{Spread thin the resulting batter on a pie pan.}
 ◊direction{Bake batter: ◊baking/repeat[]}
 ◊direction{Process the soaked dates from before.}
 ◊direction{Mix into the food processor the rest of the ingredients for the caramel: ◊ingredients/repeat['caramel/rest]}
 ◊direction{With a hand mixer, mix ingredients for the cream: ◊ingredients/repeat['cream]}
 ◊direction{Add the caramel, toppings and cream to the crust that came out of the oven: ◊ingredients/repeat['toppings]}
}

◊section['serving]{Serving}

1 pie.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link["https://www.youtube.com/watch?v=EVTWGrzWM80"]}
}
