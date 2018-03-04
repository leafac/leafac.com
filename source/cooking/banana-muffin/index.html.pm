#lang pollen

◊define-meta[title]{Banana Muffin}

◊section['ingredients]{Ingredients}

◊ingredients{
 ◊ingredients/section['flax-egg]{
  ◊ingredient{
   ◊ingredient/name{Golden flaxseed meal}
   ◊ingredient/quantity{2 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Water}
   ◊ingredient/quantity{5 tablespoons}
  }
 }
 ◊ingredients/section['banana]{
  ◊ingredient{
   ◊ingredient/name{Ripe bananas}
   ◊ingredient/quantity{4}
  }
 }
 ◊ingredients/section['dough]{
  ◊ingredient{
   ◊ingredient/name{Light brown sugar}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Coconut oil}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Vanilla extract}
   ◊ingredient/quantity{2 teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Baking soda}
   ◊ingredient/quantity{2 teaspoons}
  }
  ◊ingredient{
   ◊ingredient/name{Salt}
   ◊ingredient/quantity{◊fraction[1 8] teaspoon}
  }
  ◊ingredient{
   ◊ingredient/name{Oats}
   ◊ingredient/quantity{◊fraction[1 2] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Bleached all-purpose flour}
   ◊ingredient/quantity{1 ◊fraction[1 2] cup}
  }
 }
 ◊ingredients/section['crumbs]{
  ◊ingredient{
   ◊ingredient/name{Light brown sugar}
   ◊ingredient/quantity{◊fraction[1 4] cup}
  }
  ◊ingredient{
   ◊ingredient/name{Bleached all-purpose flour}
   ◊ingredient/quantity{5 tablespoons}
  }
  ◊ingredient{
   ◊ingredient/name{Coconut oil}
   ◊ingredient/quantity{4 tablespoons}
  }
 }
}

◊section['baking]{Baking}

◊baking{
 ◊baking-step{
  ◊baking-step/temperature{375 °F}
  ◊baking-step/duration{20 minutes}
  ◊baking-step/details{Big muffin}
 }
 ◊baking-step{
  ◊baking-step/temperature{}
  ◊baking-step/duration{16 minutes}
  ◊baking-step/details{Small muffin}
 }
}

◊section['directions]{Directions}

◊directions{
 ◊direction{On a bowl, mix ingredients for ◊informal{flax egg}: ◊ingredients/repeat['flax-egg]}
 ◊direction{Wait for 5 minutes.}
 ◊direction{Add the bananas and smash them with a fork until only small chunks remain: ◊ingredients/repeat['banana]}
 ◊direction{Mix in the rest of the ingredients for the dough one by one: ◊ingredients/repeat['dough]}
 ◊direction{On a separate bowl, mix the ingredients for the crumbs: ◊ingredients/repeat['crumbs]}
 ◊direction{Pour the dough into a muffin pan.}
 ◊direction{Add the crumbs to the top.}
 ◊direction{Bake: ◊baking/repeat[]}
 ◊direction{Let it rest on a cooling rack.}
}

◊section['serving]{Serving}

8 muffins.

◊section['sources]{Sources}

◊sources{
 ◊source{◊reference["http://minimalistbaker.com/vegan-banana-crumb-muffins/"]}
}
