#lang pollen

◊define-meta[document-class recipe]

◊define-meta[title]{Strawberry Chocolate Mousse Pie}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['crust]{
  ◊ingredient{
   ◊ingredient/name{Dried mulberry}
   ◊ingredient/quantity{1 ◊fraction[1 2] cups}
  }
  ◊ingredient{
   ◊ingredient/name{Pecan}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Date}
   ◊ingredient/quantity{1 cup}
  }
  ◊ingredient{
   ◊ingredient/name{Cinnamon}
   ◊ingredient/quantity{1 teaspoon}
  }
 }
 ◊ingredients/section['mousse]{
  ◊ingredient{
   ◊ingredient/name{Banana}
   ◊ingredient/quantity{3}
  }
  ◊ingredient{
   ◊ingredient/name{Avocado}
   ◊ingredient/quantity{1}
  }
  ◊ingredient{
   ◊ingredient/name{Date}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Cocoa powder}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Maple syrup}
   ◊ingredient/quantity{2 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Cinnamon}
   ◊ingredient/quantity{1 tablespoon}
  }
  ◊ingredient{
   ◊ingredient/name{Water}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
 }
 ◊ingredients/section['topping]{
  ◊ingredient{
   ◊ingredient/name{Strawberry}
   ◊ingredient/quantity{3}
  }
  ◊ingredient{
   ◊ingredient/name{Shredded coconut}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a food processor, process the ingredients for the crust: ◊ingredients/repeat['crust]}
 ◊direction{Press crust into a pie pan.}
 ◊direction{On a food processor, process the ingredients for the mousse: ◊ingredients/repeat['mousse]}
 ◊direction{Pour mousse into crust.}
 ◊direction{Add toppings: ◊ingredients/repeat['topping]}
}

◊section['serving]{Serving}

1 strawberry chocolate mousse pie.

◊section['sources]{Sources}

◊sources{
 ◊source{◊link["https://www.youtube.com/watch?v=_Qg6YGRdTtc"]}
}
