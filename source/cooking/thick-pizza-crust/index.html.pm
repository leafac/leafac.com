#lang pollen

◊define-meta[title]{Thick Pizza Crust}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['yeast]{
  ◊ingredient{
   ◊ingredient/name{Active dry yeast}
   ◊ingredient/quantity{1 package}
  }
  ◊ingredient{
   ◊ingredient/name{Sugar}
   ◊ingredient/quantity{1 teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Water at 110 °F}
   ◊ingredient/quantity{1 cup}
  }
 }
 ◊ingredients/section['wet]{
  ◊ingredient{
   ◊ingredient/name{Water at 110 °F}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Olive oil}
   ◊ingredient/quantity{3 tablepoons}
  }
 }
 ◊ingredients/section['dry]{
  ◊ingredient{
   ◊ingredient/name{Bread flour}
   ◊ingredient/quantity{3 ◊fraction[1 2] cups}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{2 teaspoons}
  }
 }
}

◊section['baking]{Baking}

◊baking{
 ◊baking-step{
  ◊baking-step/temperature{450 °F}
  ◊baking-step/duration{20 minutes}
 }
}

◊section['directions]{Directions}

◊directions{
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
}

◊section['serving]{Serving}

2 pizza crusts.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link{http://allrecipes.com/recipe/20171/quick-and-easy-pizza-crust/}}
 ◊source{◊link{http://allrecipes.com/video/1075/quick-and-easy-pizza-crust/}}
}
