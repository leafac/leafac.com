#lang pollen

◊define-meta[title]{Medium Pizza Crust}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['dry]{
  ◊ingredient{
   ◊ingredient/name{Unbleached all-purpose flour}
   ◊ingredient/quantity{3 cups}
  }
  ◊ingredient{
   ◊ingredient/name{Instant yeast}
   ◊ingredient/quantity{◊fraction[1 2] teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{1 ◊fraction[3 4] teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Seeds ◊emphasis{(optional)}}
   ◊ingredient/quantity{To taste}
  }
 }
 ◊ingredients/section['wet]{
  ◊ingredient{
   ◊ingredient/name{Water at 110 °F}
   ◊ingredient/quantity{From 1 ◊fraction[1 4] to 1 ◊fraction[1 2] cups}
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
 ◊direction{On a bowl, mix the dry ingredients: ◊ingredients/repeat['dry]}
 ◊direction{
  ◊margin-note{The amount of water depends on the weather. The result must be wet-to-the-hand.}
   
  Mix in the wet ingredients:
  
  ◊ingredients/repeat['wet]
 }
 ◊direction{Cover the bowl.}
 ◊direction{Let the dough rise on a warm place for 12–18 hours, until it doubles in size.}
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
 ◊source{◊link{http://www.simplysogood.com/2013/03/artisan-no-knead-bread.html}}
 ◊source{◊link{http://www.thefreshloaf.com}}
}
