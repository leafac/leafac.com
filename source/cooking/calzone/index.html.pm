#lang pollen

◊define-meta[document-class recipe]

◊define-meta[title]{Calzone}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['yeast]{
  ◊ingredient{
   ◊ingredient/name{Active dry yeast}
   ◊ingredient/quantity{1 package}
  }
  ◊ingredient{
   ◊ingredient/name{Sugar}
   ◊ingredient/quantity{2 teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Water at 110 °F}
   ◊ingredient/quantity{1 ◊fraction[1 3] cups}
  }
 }
 ◊ingredients/section['wet]{
  ◊ingredient{
   ◊ingredient/name{Olive oil}
   ◊ingredient/quantity{2 teaspoons}
  }
 }
 ◊ingredients/section['dry]{
  ◊ingredient{
   ◊ingredient/name{Whole wheat flour}
   ◊ingredient/quantity{3 cups}
  }
  ◊ingredient{
   ◊ingredient/name{Golden flaxseed meal}
   ◊ingredient/quantity{3 tablespoons}
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
  ◊baking-step/temperature{400 °F}
  ◊baking-step/duration{20 minutes}
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a bowl, activate the yeast by mixing: ◊ingredients/repeat['yeast]}
 ◊direction{Wait for 5–10 minutes until foamy.}
 ◊direction{Mix in the wet ingredients: ◊ingredients/repeat['wet]}
 ◊direction{Mix in the dry ingredients: ◊ingredients/repeat['dry]}
 ◊direction{Knead the dough for 3–5 minutes.}
 ◊direction{Coat the dough and the bowl in olive oil.}
 ◊direction{Cover the bowl.}
 ◊direction{Let the dough rise on a warm place for 1–4 hours.}
 ◊direction{Split the dough in eight equal parts.}
 ◊direction{Shape each part into a ball.}
 ◊direction{On a pizza pan, roll each ball into a thin crust.}
 ◊direction{Add the fillings.}
 ◊direction{Close the calzones with a fork on the edges.}
 ◊direction{Coat the calzones in olive oil.}
 ◊direction{Bake: ◊baking/repeat[]}
}

◊section['serving]{Serving}

8 calzones.

◊section['sources]{Sources}

◊sources{
 ◊source{◊production{The High-Protein Vegetarian Cookbook}, by Katie Parker and Kristen Smith.}
}
