#lang pollen

◊define-meta[title]{Thin Pizza Crust}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['dry]{
  ◊ingredient{
   ◊ingredient/name{Unbleached all-purpose flour}
   ◊ingredient/quantity{1 ◊fraction[3 4] cups}
  }
  ◊ingredient{
   ◊ingredient/name{Semolina flour}
   ◊ingredient/quantity{1 ◊fraction[1 4] cups}
  }
  ◊ingredient{
   ◊ingredient/name{Instant yeast}
   ◊ingredient/quantity{1 teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{1 teaspoon}
  }
 }
 ◊ingredients/section['wet]{
  ◊ingredient{
   ◊ingredient/name{Water at 110 °F}
   ◊ingredient/quantity{From 1 to 1 ◊fraction[1 4] cups}
  }
  ◊ingredient{
   ◊ingredient/name{Olive oil}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
 }
}

◊section['baking]{Baking}

◊baking{
 ◊baking-step{
  ◊baking-step/temperature{450 °F}
  ◊baking-step/duration{15 minutes}
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a bowl, mix the dry ingredients: ◊ingredients/repeat['dry]}
 ◊direction{On a measuring cup, mix the wet ingredients: ◊ingredients/repeat['wet]}
 ◊direction{Mix the dry and the wet ingredients together.}
 ◊direction{Coat the dough and the bowl in olive oil.}
 ◊direction{Cover the bowl.}
 ◊direction{Let the dough rise on a warm place for 2–4 hours.}
 ◊direction{Split the dough in two equal parts.}
 ◊direction{Shape each part into a ball.}
 ◊direction{On a pizza pan, roll each ball into a thin crust.}
 ◊direction{With a fork, pinch holes all over the crusts.}
 ◊direction{Coat the crusts in olive oil.}
 ◊direction{Add tomato sauce and toppings.}
 ◊direction{Bake: ◊baking/repeat[]}
}

◊section['serving]{Serving}

2 pizza crusts.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link["http://www.kingarthurflour.com/recipes/ultra-thin-durum-semolina-pizza-crust-recipe"]}
}
