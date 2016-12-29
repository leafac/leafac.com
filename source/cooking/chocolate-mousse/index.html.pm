#lang pollen

◊define-meta[document-class recipe]

◊define-meta[title]{Chocolate Mousse}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['avocado]{
  ◊ingredient{
   ◊ingredient/name{Avocado}
   ◊ingredient/quantity{2}
  }
 }
 ◊ingredients/section['rest]{
  ◊ingredient{
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{1 teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Maple syrup}
   ◊ingredient/quantity{3 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Melted chocolate}
   ◊ingredient/quantity{150 grams}
  }
  ◊ingredient{
   ◊ingredient/name{Coconut cream}
   ◊ingredient/quantity{160 grams}
  }
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a food processor, process the avocados: ◊ingredients/repeat['avocado]}
 ◊direction{Add to the processor the rest of the ingredients: ◊ingredients/repeat['rest]}
}

◊section['serving]{Serving}

5 bowls of chocolate mousse.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link["http://www.jamieoliver.com/recipes/chocolate-recipes/dairy-free-chocolate-mousse/"]}
}
