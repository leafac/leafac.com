<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>◊(select 'name personal-data)</title>
  <subtitle>◊(select 'description personal-data)</subtitle>
  <link href="◊|base-url|"/>
  <link rel="self" href="◊|base-url|◊|here|"/>
  <updated>◊(first (sort (select-from-doc 'updated doc) string>?))</updated>
  <author>
    <name>◊(select 'author personal-data)</name>
  </author>
  <icon>◊|base-url|avatar.png</icon>
  <id>urn:uuid:0d99d85a-bb09-45a9-8735-3344f8a105e6</id>
  ◊(map xexpr->string (select-from-doc 'root doc))
</feed>
