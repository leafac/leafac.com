#lang pollen

◊define-meta[title]{No-Knead Bread}

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
   ◊ingredient/name{Seeds or sun-dried tomatoes ◊emphasis{(optional)}}
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
  ◊baking-step/duration{30 minutes}
  ◊baking-step/details{Empty covered pot}
 }
 ◊baking-step{
  ◊baking-step/temperature[]
  ◊baking-step/duration{30 minutes}
  ◊baking-step/details{Bread in covered pot}
 }
 ◊baking-step{
  ◊baking-step/temperature[]
  ◊baking-step/duration{15 minutes}
  ◊baking-step/details{Bread in uncovered pot}
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
 ◊direction{On a heavily floured surface, fold dough into a ball.}
 ◊direction{Transfer the ball of dough to a piece of parchment paper. Cover it with the upside down bowl.}
 ◊direction{
  ◊margin-note{Use the parchment paper to transfer the dough into the hot pot and let the bread bake on it.}
   
  Bake the dough:
  
  ◊baking/repeat[]
 }
 ◊direction{Let it rest on a cooling rack.}
}

◊section['serving]{Serving}

1 loaf.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link{http://www.simplysogood.com/2013/03/artisan-no-knead-bread.html}}
 ◊source{◊link{http://www.thefreshloaf.com}}
}
