#lang pollen

◊define-meta[title]{SVG for the Web with Inkscape}
◊define-meta[date]{2017-08-13}

- My technical writing includes a lot of visual components: images and diagrams.
- Mostly vector art, so SVG is the best format.
  - Scalable.
  - Lightweight.
  - Supported by all browsers.
  - Consistent formatting.
  - Scriptable.
- Inkscape is the best tool for creating SVG. I’ve tried plenty.
- According to the manual: “Web is an afterthought.”
- leaky abstraction. There’s no way around understanding the underlying principles.
  - Similar to creating HTML in WYSIWYG.
  - XML editor in Inkscape.
  - Not all browsers render the same, test!
- Won’t teach you the basics: see the good tutorials that come with Inkscape and some primer to SVG. This article addresses the gaps.

◊section['basics-to-learn]{Basics to Learn}

- Select and move.
  - Select in group.
  - Move one pixel.
- Pen (Bézier).
  - Types of nodes.
  - Combine & break apart.
- Edit nodes (V).
- Fill & Stroke.
- Align & Distribute.
- Snapping (turn off).
- Group & Layers.
  - Navigation.
- Objects attributes: ID & CLASS.
- Markers.
- Clones.
- XML (defs).

◊section['setup]{Setup}

- XQuartz.
  - Preferences.
  - Xmodmap.
- Inkscape configuration: Change unit for text?
- Install palettes & templates (use template “in px”, otherwise)

◊section['document-properties]{Document Properties}

- Size.
- Scale (viewBox).
- Interactive figure showing the size and scale parameters.
- Measurement unit for document.

◊section['control-the-size-of-arrowheads]{Control the Size of Arrowheads}

(Markers, in SVG lingo)

- Transform to path.
- Edit XML.

◊section['fix-misaligned-markers-in-middle-of-a-path]{Fix Misaligned Markers in the Middle of a Path}

◊section['arrows-poiting-the-wrong-way]{Arrows Pointing the Wrong Way}

- Solution: final nodes cannot be straight nodes. They have to be curvy (Bézier).

◊section['spaces-in-text]{Spaces in Text}

- Common when including code in figure.
- Solution: Use non-braking space “ ”.

◊section['clean-up-document]{Clean Up Document}

◊section['clones-instead-of-duplicates]{Clones Instead of Duplicates}

- More semantic: changes carry through.
- Save space (specially with image).
- Be careful with IDs, if multiple SVG in same page.

◊section['truncated-text]{Truncated Text}

- Solution: round up document size.

◊section['save-optimized-version]{Save Optimized Version}

- Save space.
- Remove quirks.

- Save “Plain SVG”
- Save “Optimized SVG”
  - Round measurements.
  - “Work around renderer bugs”
- https://github.com/svg/svgo

◊section['include-svg-in-page]{Include SVG in Page}

- Trick to make it scale.
- Embed in HTML, to reuse fonts.

◊section['avoid-reused-ids]{Avoid Reused IDs}

- Multiple SVG on the same page might result in ID clash. Particularly for markers. Solution: clone the arrow, so it gets a new marker with a new ID, then “clean the document.”

◊section['the-last-resorts]{The Last Resorts}

- If all fails:
  - Convert everything to path.
  - Export to PNG.

◊section['references]{References}

- http://slides.com/sdrasner/svg-can-do-that#/
- https://css-tricks.com/mega-list-svg-information/
- https://svgontheweb.com
- http://tavmjong.free.fr/INKSCAPE/MANUAL/html/Web-Inkscape.html