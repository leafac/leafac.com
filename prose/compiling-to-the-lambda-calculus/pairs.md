---
layout: default
title: "Compiling to the Lambda Calculus"
draft: true
table-of-contents: true
---

Pairs are the basic building block for other [data structures](lists#other-data-structures). We already used pairs in our definition of [predecessor](#predecessor) to track the previous number on the number line. Pairs have two main uses: they couple two pieces of data together, and they allow us to transmit data between two points in the program (from the point where the pair is constructed to the point where we project an element out of it).

Values
======


- [ ] Note the similarity between numbers and pairs!
  ;;       • 0 ≈ null
  ;;       • number’s f ≈ pair’s s
  ;;       • number’s x ≈ pair’s a, b
  ;;       • The major difference is the order (f x), (a b s)
  ;;       • zero? ≠ null? because of this difference in order
