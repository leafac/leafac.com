#lang pollen

◊define-meta[title]{Chocolate Chia Seed Pudding}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['chia]{
  ◊ingredient{
   ◊ingredient/name{Chia seeds}
   ◊ingredient/quantity{◊fraction[1 3] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Water}
   ◊ingredient/quantity{◊fraction[1 3] cup}
  }
 }
 ◊ingredients/section['base]{
  ◊ingredient{
   ◊ingredient/name{Almond milk}
   ◊ingredient/quantity{1 ◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Cocoa powder}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
 }
 ◊ingredients/section['dates]{
  ◊ingredient{
   ◊ingredient/name{Dates}
   ◊ingredient/quantity{9}
  }
 }
 ◊ingredients/section['rest]{
  ◊ingredient{
   ◊ingredient/name{Cinnamon}
   ◊ingredient/quantity{◊fraction[1 2] teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{◊fraction[1 4] teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{◊fraction[1 2] teaspoon}
  }
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{In a measuring cup, mix the chia seeds with water for 5 minutes: ◊ingredients/repeat['chia]}
 ◊direction{In a blender, mix the resulting paste with the following ingredients: ◊ingredients/repeat['base]}
 ◊direction{Mix the dates in: ◊ingredients/repeat['dates]}
 ◊direction{Mix the rest of the ingredients in: ◊ingredients/repeat['rest]}
 ◊direction{Let it rest in the fridge.}
}

◊section['serving]{Serving}

2 cups.

◊section['sources]{Sources}

◊sources{
 ◊source{◊reference["http://minimalistbaker.com/overnight-chocolate-chia-seed-pudding/"]}
}
