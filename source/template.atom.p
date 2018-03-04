<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>◊|settings/name|</title>
  <subtitle>◊|settings/description|</subtitle>
  <link href="◊|settings/url|/|"/>
  <link rel="self" href="◊|settings/url|/|◊|here|"/>
  <updated>◊(first (sort (select-from-doc 'updated doc) string>?))</updated>
  <author>
    <name>◊|settings/author|</name>
  </author>
  <icon>◊|settings/url|/|avatar.png</icon>
  <id>urn:uuid:0d99d85a-bb09-45a9-8735-3344f8a105e6</id>
  ◊(map xexpr->string (select-from-doc 'root doc))
</feed>
