#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}
◊define-meta[date]{2017-03-24}

◊margin-note{This article assumes prior knowledge in programming. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊link["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages.rkt"]{Here} is the code for this entire article.}

◊new-thought{Programming languages come} in many sizes and flavors. Working programmers have been exposed to a few of them and might question: What is the essence of programming languages? In this article, we are going to explore this question, but, unlike most presentations on the topic, we are going to avoid mathematical notation and jargon. We are going to start with a small program and remove one abstraction at a time, until we reach the core of what make programming languages tick. The whole discussion is driven by executable code, making it approachable to all programmers.

Besides satisfying the curiosity, this article introduces programming techniques that are generally applicable in every day programming. And, for people venturing into programming-language design and analysis, it is helpful to identify the essential features and start working from this core. It is often clearer and easier to consider a small language first, and then add features as extensions. In this article we are going to identify what is the minimal core possible in existence.

◊section['starting-point]{Starting Point}

◊new-thought{Consider} the following program:

◊margin-note{The same program is given in three popular programming languages to help users of these languages get started. From now on, we are going to proceed in Racket, but there is nothing special about this choice. Any dynamically typed language in which functions are values would work. This includes Ruby, Python, JavaScript, and many more. This does not include C, for example, in which pointers to functions are values, but functions themselves are not. It also does not include OCaml or Haskell, because while functions are values in these languages, their static type systems are not expressive enough for some of the programs we are going to write. There are static type systems with the necessary expressiveness, but they are rare.}

◊code/block/highlighted['racket]{
;; Racket
(define (sum-up-to number)
  (if (zero? number)
      0
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to 5)
}

◊code/block/highlighted['ruby]{
# Ruby
def sum_up_to number
  if number.zero?
    0
  else
    number + sum_up_to(number - 1)
  end
end

sum_up_to 5
}

◊code/block/highlighted['java]{
// Java
public class Main {
  public static int sumUpTo(int number) {
    if (number == 0) {
      return 0;
    } else {
      return number + sumUpTo(number - 1);
    }
  }

  public static void main(String[] args) {
    System.out.println(sumUpTo(5));
  }
}
}

This program defines a function that sums integers from zero up to a given number, then calls this function with ◊code/inline{5}, outputting ◊code/inline{15}. What are the essential features in programming languages that allow this program to be written? To address this question, we first have to consider what ◊emphasis{is} an essential feature.

Suppose one wants to write an application that tracks information about bicycle trips. If one could find a programming language that comes with native constructs for distances, weather conditions and so on, then that would be a perfect fit. But programming languages generally do not have these features, so one has to use numbers, functions, lists, records, objects and other simpler features to ◊emphasis{encode} the necessary functionality.

◊margin-note{Encoding abstractions in simpler terms is the job of most compilers. They receive as input a program in language with more features and output machine code. What we are targeting in this discussion is the essence of programming languages, so, in a way, it is even more bare-bones than machine code.}

◊margin-note{◊svg{convenience-vs-simplicity.svg}}

Bicycle-trip information is not an essential feature of programming languages, that is why they do not have it. But that is not a problem, because the key observation is that ◊emphasis{any feature a language does not have, we can encode in terms of simpler features}. Most features included in most programming languages are non-essential—like bicycle-trip tracking—they exist solely for convenience. Not having a feature makes the language simpler, having it makes it more convenient. Our goal in this article is to explore this simplicity–convenience spectrum, removing one feature at a time, in the direction of simplicity. When we can no longer ◊informal{encode features away} without breaking the program, what remain are the ◊emphasis{essential features}—we will then have reached the essence of programming languages.

It is important to note that simplicity is not the same as easiness. As we advance, programs get simpler, because they use less features, but they also become harder to understand. Think of the difference between programs in Ruby and C that perform the same task. While C is a simpler language, programs in it tend to be harder to read.

◊section['numbers]{Numbers}

◊new-thought{For convenience}, here is the initial program again:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (if (zero? number)
      0
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to 5) ;; => 15
}

The first feature we are going to remove via encoding are the numbers. There many different ways to write the same program above without numbers. For example, one could use strings to represent numbers, redefining the operations on them accordingly:

◊margin-note{The ◊code/inline{___} in the code represent omitted code for the sake of simplicity.}

◊code/block/highlighted['racket]{
(define (zero? number)
  (equal? "0" number))

(define (sub1 number)
  ___)

(define (+ operand-left operand-right)
  ___)

(define (sum-up-to number)
  (if (zero? number)
      "0"
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to "5")
}

Alternatively, we could encode numbers with strings not using their string representation, but the string length. Then contents of the string would be irrelevant, only its length would be meaningful. For example, ◊code/inline{0} could become ◊code/inline{""}, ◊code/inline{1} could become ◊code/inline{"☺"}, ◊code/inline{5} could become ◊code/inline{"☺☺☺☺☺"}, and so on. The running example would look like the following with this encoding:

◊code/block/highlighted['racket]{
(define (zero? number)
  (equal? "" number))

(define (sub1 number)
  ___)

(define (+ operand-left operand-right)
  (string-append operand-left operand-right))

(define (sum-up-to number)
  (if (zero? number)
      ""
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to "☺☺☺☺☺")
}

On a related idea, we could encode numbers as list lengths. Again, the contents of the lists would be irrelevant, only their length would matter:

◊code/block/highlighted['racket]{
(define (zero? number)
  (equal? '() number))

(define (sub1 number)
  (if (zero? number)
      '()
      (rest number)))

(define (+ operand-left operand-right)
  (append operand-left operand-right))

(define (sum-up-to number)
  (if (zero? number)
      '()
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to '(☺ ☺ ☺ ☺ ☺))
;; => '(☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺ ☺)
}

Some encodings are more convenient than others. For example, it is harder to implement addition in the first string encoding presented above. It amounts to recreating the addition algorithm that we learned in elementary school, with addition tables, carries and so on. But in the list-length encoding, addition is just list append.

◊margin-note{The name of this encoding of numbers using functions is ◊technical-term{Church Encoding}.}

We are not seeking easiness, so from all the possible encodings, we are going to choose one that is unnatural and inconvenient, but interesting: we are going to encode numbers using ◊emphasis{functions}. Each number is going to be a function of two arguments: the first is a function and the second is an arbitrary argument. It repeatedly applies the first argument to the second, the amount of applications represents the number:

◊margin-note{Another interpretation is that ◊code/inline{zero} means “do not do anything to the argument,” ◊code/inline{one} means “do something to the argument once,” ◊code/inline{five} means “do something to the argument five times,” and so on.}

◊code/block/highlighted['racket]{
(define (zero function argument)
  argument)

(define (one function argument)
  (function argument))

(define (five function argument)
  (function
   (function
    (function
     (function
      (function argument))))))
}

◊margin-note{The encoding only supports non-negative integers. This is fine for our purposes in ◊code/inline{sum-up-to}, which only handles non-negative integers.}

For ◊code/inline{zero}, the given function is not applied, the argument is returned unaltered. For ◊code/inline{one}, the given function is applied once. For ◊code/inline{five}, the given function is applied five times. And so on.

When we print these numbers to inspect them, this is what Racket outputs:

◊code/block/highlighted['racket]{
> five
#<procedure:five>
}

So we are going to introduce extra machinery, which is a non-essential feature of programming languages, but is going to help us read the output:

◊code/block/highlighted['racket]{
(define (pretty-print number)
  (number add1 0))
}

The function ◊code/inline{pretty-print} is not going to be part of our main program, it only exists as a helper. That is why it is allowed to contain regular numbers—namely, ◊code/inline{0}. It receives as argument a number encoded in terms of functions and transforms it back into a regular number, so that we can read it:

◊code/block/highlighted['racket]{
> (pretty-print zero)
0
> (pretty-print one)
1
> (pretty-print five)
5
}

The way ◊code/inline{pretty-print} works reveals how this encoding of numbers using function works. Numbers are functions, so ◊code/inline{pretty-print} ◊emphasis{applies that function}. As arguments, numbers receive another function and an initial value. Then the number repeatedly applies that given function to the initial value; the amount of applications corresponds to the number we want to encode.

The function ◊code/inline{pretty-print} makes a careful choice of arguments with which it calls the number. The initial value is ◊code/inline{0}, and the function to be repeatedly applied is ◊code/inline{add1}. So, ◊code/inline{(pretty-print five)} turns into the following:

◊code/block/highlighted['racket]{
(add1
 (add1
  (add1
   (add1
    (add1 0))))) ;; => 5
}

◊paragraph-separation[]

◊new-thought{Now that we have} an encoding for numbers, we need to adapt out program to use it. For the main function, ◊code/inline{sum-up-to}, we just change the return from ◊code/inline{0} (the native integer) to ◊code/inline{zero} (our encoding as defined above):

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (if (zero? number)
      zero
      (+ number (sum-up-to (sub1 number)))))
}

The next step is to modify the functions that work on the numbers so that they are aware of the encoding we introduced. There are three of them: ◊code/inline{zero?}, ◊code/inline{sub1} and ◊code/inline{+}.

◊margin-note{In Racket, ◊technical-term{true} is spelled ◊code/inline{#t} and ◊technical-term{false} is spelled ◊code/inline{#f}.}

To implement ◊code/inline{zero?}, we can use an idea similar to ◊code/inline{pretty-print}: call the number—which is a function—with carefully chosen arguments. For the initial value, we choose ◊code/inline{#t}, and for the function we choose one that always returns ◊code/inline{#f}:

◊code/block/highlighted['racket]{
(define (zero? number)
  (define (always-false ignored-argument)
    #f)
  (number always-false #t))
}

Remember that these are the encoded numbers:

◊code/block/highlighted['racket]{
(define (zero function argument)
  argument)

(define (one function argument)
  (function argument))

(define (five function argument)
  (function
   (function
    (function
     (function
      (function argument))))))
}

So, if ◊code/inline{zero?} is called with ◊code/inline{zero}, then the initial value ◊code/inline{#t} is returned. If ◊code/inline{zero?} is called with ◊code/inline{one}, then it becomes ◊code/inline{(one always-false #t)}, which turns into ◊code/inline{(always-false #t)}, and outputs ◊code/inline{#f}. The same happens to any number that is not ◊code/inline{zero}:

◊code/block/highlighted['racket]{
> (zero? zero)
#t
> (zero? one)
#f
> (zero? five)
#f
}

◊paragraph-separation[]

◊new-thought{To implement addition} (◊code/inline{+}), we can use the following observation: if the number ◊code/inline{number-left} means “do something to the argument ◊code/inline{number-left} times,” and the number ◊code/inline{number-right} means “do something to the argument ◊code/inline{number-right} times,” then the number ◊code/inline{number-left + number-right} means “do something to the argument ◊code/inline{number-left + number-right} times.” In particular, we can ◊informal{do something} to the argument ◊code/inline{number-right} times and use the result as the initial value to ◊informal{do something} to the argument ◊code/inline{number-left} times:

◊margin-note{
 Addition is a commutative operation (◊code/inline{number-left + number-right = number-right + number-left}). So inverting ◊code/inline{number-left} and ◊code/inline{number-right} does not change the meaning of ◊code/inline{+}. It could equivalently be written as the following:

 ◊code/block/highlighted['racket]{
(number-left function
  (number-right function
                argument))
 }
}

◊code/block/highlighted['racket]{
(define (+ number-left number-right)
  (define (result function argument)
    (number-left function (number-right function argument)))
  result)
}

The following snippet is an example of ◊code/inline{+} in use:

◊code/block/highlighted['racket]{
> (pretty-print (+ five five))
10
}

◊paragraph-separation[]

◊new-thought{For the last operation} on numbers, ◊code/inline{sub1}, we are going to start by simplifying the problem by reducing its scope. In ◊code/inline{sum-up-to}, the function ◊code/inline{sub1} is only called with positive numbers. Also, our encoding using functions can only represent non-negative numbers. So, we are going to define ◊code/inline{(sub1 zero)} to output ◊code/inline{zero}.

◊margin-note{
 ◊svg{sub1.svg}

  ◊no-indent[] Note that in the figure above there are ◊emphasis{five} blue arrows, representing the steps we take to calculate ◊code/inline{sub1} of ◊code/inline{five}.
}

With that out of the way, we are going to use an ◊technical-term{sliding window} over the number line. Starting with a pair ◊code/inline{(zero, zero)}, for each step, the right element goes to the left, and the new right element is the current plus one. Another way of interpreting this is that the right element is traversing the number line and the left element is right behind it. We take that step ◊code/inline{number} times and the predecessor of the given ◊code/inline{number} is the element on the left of the pair:

◊margin-note{To represent pairs, we use ◊code/inline{(struct pair (left right))}, instead of Racket’s native pairs, because the names ◊code/inline{cons}, ◊code/inline{car} and ◊code/inline{cdr} are not intuitive.}

◊code/block/highlighted['racket]{
(define (sub1 number)
  (define initial-pair (pair zero zero))

  (define (slide-pair current-pair)
    (define current-number (pair-right current-pair))
    (pair current-number (+ current-number one)))

  (define final-pair
    (number slide-pair initial-pair))

  (pair-left final-pair))
}

We can test ◊code/inline{sub1} and see the result using ◊code/inline{pretty-print}:

◊code/block/highlighted['racket]{
> (pretty-print (sub1 five))
4
}

◊paragraph-separation[]

◊new-thought{At this point}, we have all the numeric operations necessary for ◊code/inline{sum-up-to} encoded in terms of functions. This means that numbers are not an essential feature of programming languages. On the next section, we are going to address the only other primitive data type used in our program: booleans.

◊section['booleans]{Booleans}

◊new-thought{There is only one} place in which we use a boolean in our program: the conditional (◊code/inline{if}) in ◊code/inline{sum-up-to}’s body. Its condition depends on ◊code/inline{zero?}, which is the only function generating booleans. For convenience, here are their current definitions again:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (if (zero? number)
      zero
      (+ number (sum-up-to (sub1 number)))))

(define (zero? number)
  (define (always-false ignored-argument)
    #f)
  (number always-false #t))
}

Are booleans an essential feature of programming languages, or can we ◊informal{encode them away}? Programmers familiar with C know that the answer to this question is negative, because in C there are no booleans. They are encoded in terms of numbers: zero represents ◊technical-term{false} and any other number represents ◊technical-term{true}.

As was the case before with numbers, different encodings are possible. For example, we could use the strings ◊code/inline{"true"} and ◊code/inline{"false"}; or an empty list could mean ◊technical-term{false} and lists with at least one element could represent ◊technical-term{true}. Some encodings are more convenient than others.

◊margin-note{This encoding of booleans using functions is also called ◊technical-term{Church Encoding}.}

A particularly interesting choice is to follow C’s lead and use numbers to encode booleans. But, since in the ◊reference['numbers]{previous section} we already ◊informal{encoded numbers away} in terms of functions, we are going to be consistent and use functions to encode booleans:

◊margin-note{There is nothing special about the names ◊code/inline{true} and ◊code/inline{false}. They are regular functions, like ◊code/inline{sub1}, ◊code/inline{pretty-print} and so on.}

◊code/block/highlighted['racket]{
(define (true first second)
  first)

(define (false first second)
  second)
}

In our encoding, booleans are functions that receive two arguments. The value ◊code/inline{true} returns the first argument, and ◊code/inline{false} returns the second argument.

We can now adapt ◊code/inline{zero?} to use these values:

◊code/block/highlighted['racket]{
(define (zero? number)
  (define (always-false ignored-argument)
    false)
  (number always-false true))
}

Because we changed the representation of booleans, we need to modify the conditional (◊code/inline{if}) accordingly. It receives as arguments a condition, which is boolean encoded as a function, and this function is capable of choosing which branch (◊code/inline{then} or ◊code/inline{else}) to follow:

◊margin-note{Again, there is nothing special about the names ◊code/inline{if},  ◊code/inline{then} and ◊code/inline{else}. The name ◊code/inline{if} became just another function. And ◊code/inline{then} and ◊code/inline{else} are regular variables, like ◊code/inline{number-left}, ◊code/inline{number-right} and so on.}

◊margin-note{Conditionals are so natural to encode because our choice of encoding for booleans was deliberate to make this happen.}

◊code/block/highlighted['racket]{
(define (if condition then else)
  (condition then else))
}

We introduced a problem in ◊code/inline{sum-up-to}, though. Here is its current definition one more time:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (if (zero? number)
      zero
      (+ number (sum-up-to (sub1 number)))))
}

Before we encoded ◊code/inline{if}, this code was using Racket’s ◊code/inline{if}. And Racket’s ◊code/inline{if} only executes a branch if necessary. In particular, the part ◊code/inline{(+ number (sum-up-to (sub1 number)))} only ran if ◊code/inline{(zero? number)} was ◊technical-term{false}. But now, because ◊code/inline{if} is a function call, by the time we check the condition to make a decision, this part already ran. And it contains a recursive call to ◊code/inline{sum-up-to}, which leads to an infinite sequence of recursive calls. This program does not terminate.

To solve this issue, we ◊informal{wrap} the conditional branches in functions, so that they do not execute right away. We then use ◊code/inline{if} to choose the right function to call:

◊margin-note{Another way of thinking about this step is that the functions in which we ◊informal{wrap} the conditional branches are ◊technical-term{delaying} the computation until it is necessary—at which point we call the function.}

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

The most important part of the snippet above is that ◊code/inline{(define (then) ___)} and ◊code/inline{(define (else) ___)} are defining two ◊emphasis{functions} called ◊code/inline{then} and ◊code/inline{else}. These functions receive no arguments, that is why we define them with ◊code/inline{(define (then) ___)} and not ◊code/inline{(define (then x y z) ___)}. Similarly, ◊code/inline{(branch-to-take)} is calling the function ◊code/inline{branch-to-take} without any arguments.

◊paragraph-separation[]

◊new-thought{Our work with booleans} is complete. There are no longer any native Racket booleans in our program, they have been encoded into functions. Moreover, our program contains no primitive values (numbers, booleans, strings, and so on) at all, and it continues to have the same meaning:

◊code/block/highlighted['racket]{
> (pretty-print (sum-up-to five))
15
}

So we can conclude that primitive values are not essential features to programming languages. Could it be that compound data structures are? On the next section we are going to explore this question.

◊section['pairs]{Pairs}

◊new-thought{The only instance} of a data structure in our program is a ◊technical-term{pair}, used in ◊code/inline{sub1}. There are three functions to interact with pairs: the function ◊code/inline{(pair left right)} returns a pair with elements ◊code/inline{left} and ◊code/inline{right}; the function ◊code/inline{(pair-left pair)} receives a pair and returns the element on the left; the function ◊code/inline{(pair-right pair)} receives a pair and returns the element on the right.

◊margin-note{The compound of a function and the outer variable references whose value it ◊informal{remembers} is called a ◊technical-term{closure}.}

Encodings for pairs are not as natural as, for example, the one for numbers using strings. Can it be done at all? In particular, can we use functions for that purpose, since we have used them for primitive data types in the previous sections? It turns out that we can. And the crucial insight is that inner functions (functions defined within other functions) can refer to arguments of the outer function. They ◊informal{remember} those arguments even after the outer function has returned. The following snippet illustrates this:

◊code/block/highlighted['racket]{
(define (store value)
  (define (retriever)
    value)

  retriever)

(define stored-5 (store 5))
(define stored-3 (store 3))

(stored-5) ;; => 5
(stored-3) ;; => 3
}

In the code above, ◊code/inline{store} is a function which receives a ◊code/inline{value} and stores it for later. The way to retrieve the value is to apply the return of the call to ◊code/inline{store}. It works defining and returning an inner function, ◊code/inline{retriever}, which has access to and ◊informal{remembers} the outer ◊code/inline{value}.

To implement a pair, we can use the idea from ◊code/inline{store}, but with two ◊code/inline{value}s as arguments to ◊informal{remember}. The problem then becomes: when retrieving, which of the two values to return? This is not a decision we can make at the point of defining ◊code/inline{retriever}, because information about which of the two values to return is only known when retrieving.

The solution is to modify ◊code/inline{retriever} such that it receives an argument, a ◊code/inline{selector} function. Then ◊code/inline{retriever} calls ◊code/inline{selector} with both values in the pair and let it decide which one to return. With that, the ◊code/inline{pair} function is complete:

◊code/block/highlighted['racket]{
(define (pair left right)
  (define (retriever selector)
    (selector left right))
  retriever)
}

We can then define the selectors, which receive ◊code/inline{left} and ◊code/inline{right} and return the correct element in the pair:

◊margin-note{Apart from identifiers, ◊code/inline{selector-left} is the same function as ◊code/inline{true} and ◊code/inline{selector-right} is the same function as ◊code/inline{false}. This is not a coincidence, but evidence of the duality between disjunction (a boolean is ◊emphasis{either} ◊code/inline{true} ◊emphasis{or} ◊code/inline{false}) and conjunction (a pair holds a ◊code/inline{left} ◊emphasis{and} a ◊code/inline{right} elements). They are two sides of the same coin. This is a fundamental result of ◊link["https://www.infoq.com/presentations/category-theory-propositions-principle"]{category theory}.}

◊code/block/highlighted['racket]{
(define (selector-left left right)
  left)

(define (selector-right left right)
  right)
}

Pairs now work, as the snippet below exemplifies:

◊code/block/highlighted['racket]{
(define number-pair (pair 2 3))

> (number-pair selector-left)
2
> (number-pair selector-right)
3
}

We can wrap this pattern of usage for pairs in the convenient accessor functions ◊code/inline{pair-left} and ◊code/inline{pair-right}, which ◊code/inline{sub1} uses:

◊margin-note{The technique to turn selectors (◊code/inline{selector-left} and ◊code/inline{selector-right}) into accessors (◊code/inline{pair-left} and ◊code/inline{pair-right}) is the same to turn booleans (◊code/inline{true} and ◊code/inline{false}) into conditionals (◊code/inline{if}).}

◊code/block/highlighted['racket]{
(define (pair-left pair)
  (define (selector-left left right)
    left)

  (pair selector-left))

(define (pair-right pair)
  (define (selector-right left right)
    right)

  (pair selector-right))
}

The following is an example of these accessor functions in use:

◊code/block/highlighted['racket]{
> (pair-left number-pair)
2
> (pair-right number-pair)
3
}

More importantly, our program is working with this encoding for pairs in terms of functions:

◊code/block/highlighted['racket]{
> (pretty-print (sum-up-to five))
15
}

◊paragraph-separation[]

◊new-thought{Before we move on} to other programming-language features that we might question as ◊technical-term{essential} or ◊informal{encodeable}, let us appreciate the importance of the result above. We used functions to encode pairs, but what about other data structures? They are not used ◊code/inline{sum-up-to}, but, if they were, could we ◊informal{encode them away}? Or are there data structures that ◊technical-term{essential} features in programming languages?

One more time, the answer is that data structures in general are ◊informal{encodeable} in terms of simpler features. And, once again, there are different encodings available. In particular, it is possible to encode all data structures in terms of pairs; and, ultimately, in terms functions, by the result of this section. The figure below illustrates examples of encodings:

◊paragraph-separation[]

◊margin-note{Encodings only depend on previously defined data structures, so the whole construction is well-founded.}

◊figure{
 ◊svg{data-structures.svg}
}

In the figure above, lists (also known as arrays) are composed of pairs of pairs and a distinguished empty pair. This distinguished empty pair could be represented by, for example, ◊technical-term{false}—anything outside the range of possible list elements (integer in the example) would work.

A list containing pairs of elements could be interpreted as a record (also known as dictionary, hash, associative array). The left element of the pair is the key and the right element is the value.

Finally, with records it is possible to encode objects. Some fields are values (for example, ◊code/inline{name} and ◊code/inline{birthdate}), and some are functions (for example, ◊code/inline{age}), which can be interpreted as methods. One special record field (◊code/inline{self}) contains a reference to the whole record itself. This self-awareness is necessary so that methods (for example, ◊code/inline{age}) can refer to other object attributes (for example, ◊code/inline{birthdate}).

Objects can get more complicated, with features such as inheritance and polymorphism; also many other data structures exist: tuples, trees and more. And, with varying degrees of difficulty, they are all encodeable in terms of pairs, the simplest way to couple data together. So, ultimately, this section shows that all data structures can be defined in terms of functions.

◊paragraph-separation[]

◊new-thought{The next feature} we have to address is functions themselves, because they are the only kind of value left in ◊code/inline{sum-up-to}. What parts of functions are essential features of programming languages? What parts can be ◊informal{encoded away}? In the next section, we are going to address the most powerful aspect of functions: ◊emphasis{recursion}.

◊section['recursion]{Recursion}

◊new-thought{There is only one} recursive function in our program. It is ◊code/inline{sum-up-to} itself. The following is its current definition, for convenience:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

The particular point of recursion is the call to ◊code/inline{sum-up-to} in the ◊code/inline{else} branch. This works because, in Racket, when defining the function using ◊code/inline{(define (sum-up-to number) ___)} the binding for ◊code/inline{sum-up-to} is available in the body. Can we ◊informal{encode this feature away}?

Surprisingly, the answer to this question is positive. And there are multiple possible encodings. The simplest is known as ◊technical-term{tying the knot}. Start with an implementation of ◊code/inline{sum-up-to} that is not recursive, when it needs to call itself, it instead calls an auxiliary function (named, for example, ◊code/inline{sum-up-to/rest}):

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

The name ◊code/inline{sum-up-to/rest} for this auxiliary function is appropriate because, as implemented, ◊code/inline{sum-up-to} is only performing one step of the computation; it is delegating the ◊emphasis{rest} to ◊code/inline{sum-up-to/rest}. The question then becomes: how do we implement ◊code/inline{sum-up-to/rest}?

A first idea could be to copy and paste the implementation for ◊code/inline{sum-up-to}:

◊code/block/highlighted['racket]{
(define (sum-up-to/rest number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

But this idea is bad, because now ◊code/inline{sum-up-to/rest} is using recursion, the exact feature we are trying to ◊informal{encode away}. Alternatively, we could rewrite ◊code/inline{sum-up-to/rest} so that it delegates to another auxiliary function ◊code/inline{sum-up-to/rest2}. But this idea is also bad, because we would be just delaying the problem: how would we write ◊code/inline{sum-up-to/rest2}?

Because we do not know how to implement ◊code/inline{sum-up-to/rest}, we can start with a placeholder:

◊margin-note{The implementation of ◊code/inline{sum-up-to/rest} must appear before the one for ◊code/inline{sum-up-to}, and it must not refer to ◊code/inline{sum-up-to}. Otherwise it would again be (indirectly) relying on Racket’s support for recursion.}

◊code/block/highlighted['racket]{
(define (sum-up-to/rest number)
  "TEMPORARY IMPLEMENTATION")

(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

Once ◊code/inline{sum-up-to} has been implemented, though, we can use it to implement ◊code/inline{sum-up-to/rest}. This relies on the ability to ◊emphasis{change} the definition ◊code/inline{sum-up-to/rest} after the fact, using mutation (◊code/inline{set!}):

◊code/block/highlighted['racket]{
(define (sum-up-to/rest number)
  "TEMPORARY IMPLEMENTATION")

(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))

(set! sum-up-to/rest sum-up-to)
}

With this change, the program is no longer recursive, and it still outputs the same value:

◊code/block/highlighted['racket]{
> (pretty-print (sum-up-to five))
15
}

We have successfully encoded recursion, but the encoding relies on mutation of the program’s state (◊code/inline{set!}). Can we then ◊informal{encode mutation away}? Yes, but it is a pervasive change to the program. The idea is to modify ◊emphasis{every} function definition and ◊emphasis{every} function application. Functions would receive a ◊reference['pairs]{pair} of their arguments along with the current global state of the program, and return a pair of their return value along with a possibly modified global state of the program. While feasible, this solution is not elegant. It requires changing even the functions that do not need to change the global state of the program, so that they thread the state along.

So we are going to take a step back and reconsider our encoding for recursion, so that it does not depend on mutation. This is ◊code/inline{sum-up-to} before ◊technical-term{tying the knot}:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))
}

It still depends on ◊code/inline{sum-up-to/rest}, which we do not know how to implement. But, this time, instead of coming up with a placeholder implementation for it, we are going to change ◊code/inline{sum-up-to} so that it receives ◊code/inline{sum-up-to/rest} as an argument:

◊code/block/highlighted['racket]{
(define (sum-up-to sum-up-to/rest number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))
}

Now it is the job of ◊code/inline{sum-up-to}’s callers to provide a suitable ◊code/inline{sum-up-to/rest}:

◊code/block/highlighted['racket]{
(pretty-print (sum-up-to ___ five))
}

What can we use to fill in the ◊code/inline{___} above? A good candidate is ◊code/inline{sum-up-to} itself:

◊code/block/highlighted['racket]{
(pretty-print (sum-up-to sum-up-to five))
}

This choice is similar to the line ◊code/inline{(set! sum-up-to/rest sum-up-to)} when ◊technical-term{tying the knot}. But this time there is a problem. We passed ◊code/inline{sum-up-to} as ◊code/inline{sum-up-to/rest} when calling ◊code/inline{sum-up-to} itself. So, in ◊code/inline{sum-up-to}’s body, when ◊code/inline{sum-up-to/rest} is called, this is actually a call to ◊code/inline{sum-up-to}. And ◊code/inline{sum-up-to} requires a ◊code/inline{sum-up-to/rest} as its first argument:

◊image["incomplete-self-passing.png"]{The code above, failing to execute because of the missing argument.}

Again, we can use the same idea as before to solve this issue. We can pass ◊code/inline{sum-up-to/rest} itself as the argument:

◊margin-note{The name of this technique is ◊emphasis{self-passing}. Unsurprisingly.}

◊margin-note{The effect of self-passing is similar to the hierarchy of ◊code/inline{sum-up-to/rest}, ◊code/inline{sum-up-to/rest2} and so on that we proposed above. But, as we already noted, explicitly creating that unbounded sequence of functions is not possible; instead, each call of the form ◊code/inline{(sum-up-to/rest sum-up-to/rest ___)} is taking one step and carrying along another copy of the function capable of the taking the next steps, if necessary.}

◊code/block/highlighted['racket]{
(define (sum-up-to sum-up-to/rest number)
  (define (then)
    zero)

  (define (else)
    (+ number
       (sum-up-to/rest sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

With this change, we successfully encoded recursion in terms of non-recursive functions:

◊code/block/highlighted['racket]{
> (pretty-print (sum-up-to sum-up-to 5))
15
}

Unfortunately, we changed the interface to ◊code/inline{sum-up-to}. Now callers need to be aware of the recursion encoding, and call it with ◊code/inline{(sum-up-to sum-up-to number)}, which is inconvenient. We can make this better by introducing an auxiliary function ◊code/inline{sum-up-to/partial}:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (define (sum-up-to/partial sum-up-to/rest number)
    (define (then)
      zero)

    (define (else)
      (+ number
         (sum-up-to/rest sum-up-to/rest (sub1 number))))

    (define branch-to-take
      (if (zero? number) then else))

    (branch-to-take))

  (sum-up-to/partial sum-up-to/partial number))
}

◊margin-note{The ◊code/inline{sum-up-to} façade is not specific to the job of adding numbers, because ◊code/inline{sum-up-to/partial} is taking care of this. So ◊code/inline{sum-up-to} can be abstracted to work as a façade for any recursive function encoded via self-passing. This abstracted façade has the name ◊technical-term{Y-combinator}.}

The bulk of the work is in ◊code/inline{sum-up-to/partial}, and ◊code/inline{sum-up-to} is a façade. This brings us back to the original:

◊code/block/highlighted['racket]{
> (pretty-print (sum-up-to 5))
15
}

◊paragraph-separation[]

◊new-thought{The result of this section} is the most important in this article. We encoded recursion in terms of non-recursive functions, using self-passing. And recursion was the ingredient that allowed ◊code/inline{sum-up-to} to calculate sums up to arbitrarily large numbers. There is no upper bound to the argument, so the function works for infinitely many inputs. If we think of a function as a lookup table from inputs to outputs, ◊code/inline{sum-up-to} is a table with infinitely many rows. But its definition is still finite, taking less than ten lines. What allows us to compact the definition this way is recursion.

The observation that recursion can be encoded in terms of non-recursive functions leads to the conclusion that they alone are capable of performing arbitrary computations. Anything a computer can do is expressible in terms of non-recursive functions.

There are few features left in our program. It is composed solely of (non-recursive) function definitions and applications. Can we make it even simpler? On the next section, we address functions with multiple arguments.

◊section['functions-with-multiple-arguments]{Functions with Multiple Arguments}

◊new-thought{Almost all functions} in our program receive multiple arguments. In some of them, for example, ◊code/inline{(pair left right)}, it seems like the ability to receive multiple arguments is essential to their functionality. After all, the purpose of ◊code/inline{pair} is exactly to couple the arguments ◊code/inline{left} and ◊code/inline{right} together. But is this an essential feature of programming languages, or can functions with multiple arguments be ◊informal{encoded away}, so that only functions with a single argument remain?

The answer to this question is trivially positive if we allowed the encoding to include data structures. For example, instead of ◊code/inline{(+ number-left number-right)} receiving two arguments, it could receive a pair containing the operands: ◊code/inline{(+ number-pair)}. Then, in its definition, ◊code/inline{+} would extract the operands from the pair and proceed as before.

We ◊reference['pairs]{already established} an encoding for pairs and extended it for lists of arbitrary size, so the reasoning above would apply to functions with arbitrary number of arguments. But then how could we implement the encoding for pairs? Remember that ◊code/inline{(pair left right)} is itself a function with multiple arguments. To solve this impossible situation in which each encoding depends on one other, we need a new idea.

This new idea comes from two observations: first, functions can return functions as their return value; second, inner functions (functions defined within other functions) have access to the outer functions arguments. We already used both of these properties when defining ◊code/inline{pair}, for example. The following is its implementation one more time:

◊code/block/highlighted['racket]{
(define (pair left right)
  (define (retriever selector)
    (selector left right))
  retriever)
}

In the snippet above, the inner function ◊code/inline{retriever} has access to the arguments of the outer function ◊code/inline{pair}. Also, ◊code/inline{pair} returns the function ◊code/inline{retriever} as its return value.

◊margin-note{The name of this idea of ◊informal{cascading functions} is ◊technical-term{currying}. In the intermediary stages, when not all the arguments have been provided, the function is said to be ◊technical-term{partially applied}.}

We can extend this idea to ◊informal{break apart} ◊code/inline{pair} into a ◊informal{cascade of functions}, each receiving a single argument and returning an intermediary function:

◊code/block/highlighted['racket]{
(define (pair left)
  (define (pair/intermediary right)
    (define (retriever selector)
      (selector left right))
    retriever)
  pair/intermediary)
}

The implementation above works the same as before, but the way to call it has changed. Every invocation of ◊code/inline{pair} has to go through the cascade. Instead of writing ◊code/inline{(define number-pair (pair 2 3))}, the following is necessary:

◊code/block/highlighted['racket]{
(define number-pair/intermediary (pair 2))
(define number-pair (number-pair/intermediary 3))
}

More compactly, we can skip giving a name to the intermediary function and call it immediately:

◊code/block/highlighted['racket]{
(define number-pair ((pair 2) 3))
}

Cascades of this form extend to functions with arbitrarily large number of parameters. But what about functions with zero parameters? Our program includes few of them, for example ◊code/inline{else} in ◊code/inline{sum-up-to}, which serves to ◊informal{delay} the computation of the recursive call. In these cases, the encoding is to add a ◊informal{dummy} argument, to which the function body does not refer. Also, we change the places that call such functions to include a ◊informal{dummy} argument. The following is an extract of ◊code/inline{sum-up-to} including this treatment:

◊margin-note{It is important that the omitted part ◊code/inline{___} does not refer to ◊code/inline{dummy}, otherwise we would have changed the meaning of the program.}

◊code/block/highlighted['racket]{
(define (else dummy)
  ___)

(define (dummy ignore-me)
  ignore-me)

(else dummy)
}

◊paragraph-separation[]

◊new-thought{The change described} in this section is pervasive. It affects most defined functions and their invocations:

◊margin-note{In this listing, we used Racket’s syntax sugar for defining ◊informal{cascades of functions}. For example, ◊code/inline{(define ((pair left) right) ___)} is equivalent to the construction above including ◊code/inline{pair/intermediary}, but it saves us from having to name each intermediary function in the ◊informal{cascade}. As a result, the transformation to the program boiled down to adding many parenthesis and a few ◊informal{dummy} arguments.}

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  (define ((sum-up-to/partial sum-up-to/rest) number)
    (define (then dummy)
      zero)

    (define (else dummy)
      ((+ number)
       ((sum-up-to/rest sum-up-to/rest) (sub1 number))))

    (define branch-to-take
      (((if (zero? number)) then) else))

    (define (dummy ignore-me)
      ignore-me)

    (branch-to-take dummy))

  ((sum-up-to/partial sum-up-to/partial) number))

(define ((zero function) argument)
  argument)

(define ((one function) argument)
  (function argument))

(define ((five function) argument)
  (function
   (function
    (function
     (function
      (function argument))))))

(define (zero? number)
  (define (always-false ignored-argument)
    false)
  ((number always-false) true))

(define ((+ number-left) number-right)
  (define ((result function) argument)
    ((number-left function)
     ((number-right function) argument)))
  result)

(define (sub1 number)
  (define initial-pair ((pair zero) zero))

  (define (slide-pair current-pair)
    (define current-number (pair-right current-pair))
    ((pair current-number) ((+ current-number) one)))

  (define final-pair
    ((number slide-pair) initial-pair))

  (pair-left final-pair))

(define ((true first) second)
  first)

(define ((false first) second)
  second)

(define (((if condition) then) else)
  ((condition then) else))

(define ((pair left) right)
  (define (retriever selector)
    ((selector left) right))
  retriever)

(define (pair-left pair)
  (define ((selector-left left) right)
    left)

  (pair selector-left))

(define (pair-right pair)
  (define ((selector-right left) right)
    right)

  (pair selector-right))

(define (pretty-print number)
  ((number add1) 0))

(pretty-print (sum-up-to five)) ;; => 15
}

◊paragraph-separation[]

◊new-thought{The program above} is difficult to read. The only way to understand it is to retrace the steps we have took so far. Despite this difficulty, it is very ◊emphasis{simple}. It uses almost no features from Racket, which means we are near the essence of programming languages. The next section is about the last transformation we are going to apply to our program.

◊section['named-definitions]{Named Definitions}

◊new-thought{We defined functions and intermediary values} using the ◊code/inline{(define ___ ___)} form all over our program. This is convenient because it allows us to give names to the concepts and parts of the computation. And this form is powerful. For example, using it we can define functions in any order, regardless of how they depend on each other:

◊code/block/highlighted['racket]{
(define (sum-up-to number)
  ___ (sub1 number) ___)

(define (sub1 number)
  ___)
}

◊margin-note{In C, for example, the equivalent of this snippet would not be valid. The C compiler insists on knowing at least the function name and the types of its arguments and return—if not its implementation—before allowing other functions to use it.}

It is often better to present the high-level picture (◊code/inline{sum-up-to}) first, and the details (◊code/inline{sub1}) later. That is why ◊code/inline{(define ___ ___)} form allows ◊code/inline{sum-up-to} to refer to ◊code/inline{sub1} even though it is only going to be defined later. Is this an essential feature of programming languages?

◊margin-note{We have managed to discuss theory with only a single Greek letter (◊code/inline{λ}), and it is only introduced in the last encoding. Success.}

◊margin-note{Racket’s ◊technical-term{anonymous functions} can receive multiple arguments and include multiple internal definitions and expressions. So the full form is more complex than ◊code/inline{(λ (argument) body)}, but these extra features are not necessary for our purposes.}

The answer one more time is negative. Named definitions are not an essential feature and we can ◊informal{encode them away}, in terms of simpler features. What can be simpler than a function with a name? A function with no name (◊technical-term{anonymous function}). In Racket, ◊technical-term{anonymous functions} are spelled ◊code/inline{(λ (argument) body)}, in which ◊code/inline{argument} is an identifier naming the argument the function receives, and ◊code/inline{body} is the expression of what the function performs. For example, the following two definitions are equivalent:

◊code/block/highlighted['racket]{
(define (sub1 number)
  ___)

(define sub1
  (λ (number)
    ___))
}

To ◊informal{encode away} named definitions, we are first going to reorder them so that they can only refer to previously defined names:

◊margin-note{This step is only possible because we ◊informal{encoded ◊reference['recursion]{recursion} away}.}

◊code/block/highlighted['racket]{
(define ((true first) second)
  first)

(define ((false first) second)
  second)

(define (((if condition) then) else)
  ((condition then) else))

(define ((pair left) right)
  (define (retriever selector)
    ((selector left) right))
  retriever)

(define (pair-left pair)
  (define ((selector-left left) right)
    left)

  (pair selector-left))

(define (pair-right pair)
  (define ((selector-right left) right)
    right)

  (pair selector-right))

(define ((zero function) argument)
  argument)

(define ((one function) argument)
  (function argument))

(define ((five function) argument)
  (function
   (function
    (function
     (function
      (function argument))))))

(define (zero? number)
  (define (always-false ignored-argument)
    false)
  ((number always-false) true))

(define ((+ number-left) number-right)
  (define ((result function) argument)
    ((number-left function)
     ((number-right function) argument)))
  result)

(define (sub1 number)
  (define initial-pair ((pair zero) zero))

  (define (slide-pair current-pair)
    (define current-number (pair-right current-pair))
    ((pair current-number) ((+ current-number) one)))

  (define final-pair
    ((number slide-pair) initial-pair))

  (pair-left final-pair))

(define (sum-up-to number)
  (define ((sum-up-to/partial sum-up-to/rest) number)
    (define (then dummy)
      zero)

    (define (else dummy)
      ((+ number)
       ((sum-up-to/rest sum-up-to/rest) (sub1 number))))

    (define branch-to-take
      (((if (zero? number)) then) else))

    (define (dummy ignore-me)
      ignore-me)

    (branch-to-take dummy))

  ((sum-up-to/partial sum-up-to/partial) number))

(define (pretty-print number)
  ((number add1) 0))

(pretty-print (sum-up-to five)) ;; => 15
}

Now, we can ◊emphasis{inline} the definitions where they are used. For example, ◊code/inline{zero?}’s current definition is:

◊code/block/highlighted['racket]{
(define (always-false ignored-argument)
  false)
((number always-false) true)
}

We can rewrite the above such that all references to the ◊code/inline{always-false} function are replaced with ◊code/inline{always-false}’s implementation, using anonymous functions:

◊margin-note{
 While performing this rewrite, it is important that we avoid accidentally changing the meanings of the identifiers. For example, the following rewrite would be invalid:

 ◊code/block/highlighted['racket]{
;; From

(define (always-false
         ignored-argument)
  false)
(λ (false)
  ((number always-false) true))

;; To

(λ (false)
  ((number
    (λ (ignored-argument) false))
   true))
 }

 The reason is the difference between the meanings of ◊code/inline{false} in ◊code/inline{always-false}’s definition and in ◊code/inline{(λ (false) ___)}. The solution is to rename the identifier ◊code/inline{false} in ◊code/inline{(λ (false) ___)} to (for example) ◊code/inline{(λ (false2) ___)}—along with all its uses. Fortunately, this issue does not occur in our program.
}

◊code/block/highlighted['racket]{
((number (λ (ignored-argument) false)) true)
}

We are finally ready to see the final version of our program, in which all definitions are inlined:

◊margin-note{We did not inline ◊code/inline{pretty-print} because it is external to our program. It only exists for us to inspect the result of the computation, which is a number encoded in terms of functions.}

◊code/block/highlighted['racket]{
(define (pretty-print number)
  ((number add1) 0))

(pretty-print
 ((λ (number)
    (((λ (sum-up-to/rest)
        (λ (number)
          (((((λ (condition)
                (λ (then)
                  (λ (else)
                    ((condition then)
                     else))))
              ((λ (number)
                 ((number
                   (λ (ignored-argument)
                     (λ (first)
                       (λ (second)
                         second))))
                  (λ (first)
                    (λ (second) first))))
               number))
             (λ (dummy)
               (λ (function)
                 (λ (argument) argument))))
            (λ (dummy)
              (((λ (number-left)
                  (λ (number-right)
                    (λ (function)
                      (λ (argument)
                        ((number-left
                          function)
                         ((number-right
                           function)
                          argument))))))
                number)
               ((sum-up-to/rest
                 sum-up-to/rest)
                ((λ (number)
                   ((λ (pair)
                      (pair
                       (λ (left)
                         (λ (right) left))))
                    ((number
                      (λ (current-pair)
                        (((λ (left)
                            (λ (right)
                              (λ (selector)
                                ((selector
                                  left)
                                 right))))
                          ((λ (pair)
                             (pair
                              (λ (left)
                                (λ (right)
                                  right))))
                           current-pair))
                         (((λ (number-left)
                             (λ (number-right)
                               (λ (function)
                                 (λ (argument)
                                   ((number-left
                                     function)
                                    ((number-right
                                      function)
                                     argument))))))
                           ((λ (pair)
                              (pair
                               (λ (left)
                                 (λ (right)
                                   right))))
                            current-pair))
                          (λ (function)
                            (λ (argument)
                              (function
                               argument)))))))
                     (((λ (left)
                         (λ (right)
                           (λ (selector)
                             ((selector
                               left)
                              right))))
                       (λ (function)
                         (λ (argument)
                           argument)))
                      (λ (function)
                        (λ (argument)
                          argument))))))
                 number)))))
           (λ (ignore-me) ignore-me))))
      (λ (sum-up-to/rest)
        (λ (number)
          (((((λ (condition)
                (λ (then)
                  (λ (else)
                    ((condition then)
                     else))))
              ((λ (number)
                 ((number
                   (λ (ignored-argument)
                     (λ (first)
                       (λ (second)
                         second))))
                  (λ (first)
                    (λ (second) first))))
               number))
             (λ (dummy)
               (λ (function)
                 (λ (argument) argument))))
            (λ (dummy)
              (((λ (number-left)
                  (λ (number-right)
                    (λ (function)
                      (λ (argument)
                        ((number-left
                          function)
                         ((number-right
                           function)
                          argument))))))
                number)
               ((sum-up-to/rest
                 sum-up-to/rest)
                ((λ (number)
                   ((λ (pair)
                      (pair
                       (λ (left)
                         (λ (right) left))))
                    ((number
                      (λ (current-pair)
                        (((λ (left)
                            (λ (right)
                              (λ (selector)
                                ((selector
                                  left)
                                 right))))
                          ((λ (pair)
                             (pair
                              (λ (left)
                                (λ (right)
                                  right))))
                           current-pair))
                         (((λ (number-left)
                             (λ (number-right)
                               (λ (function)
                                 (λ (argument)
                                   ((number-left
                                     function)
                                    ((number-right
                                      function)
                                     argument))))))
                           ((λ (pair)
                              (pair
                               (λ (left)
                                 (λ (right)
                                   right))))
                            current-pair))
                          (λ (function)
                            (λ (argument)
                              (function
                               argument)))))))
                     (((λ (left)
                         (λ (right)
                           (λ (selector)
                             ((selector
                               left)
                              right))))
                       (λ (function)
                         (λ (argument)
                           argument)))
                      (λ (function)
                        (λ (argument)
                          argument))))))
                 number)))))
           (λ (ignore-me) ignore-me)))))
     number))
  (λ (function)
    (λ (argument)
      (function
       (function
        (function
         (function
          (function argument)))))))))
}

The output of this program is still the same as when we started:

◊code/block/highlighted['racket]{
15
}

◊paragraph-separation[]

◊margin-note{The set of features that are left in the program goes by the name of Lambda calculus, which explains the use of the λ in the anonymous-function notation in Racket.}

◊new-thought{This version of the program} is remarkably difficult to read. Only a few parts are familiar and most concepts that previously were abstracted and named are now intertwined. No programmer would write code this way. But, despite being ◊emphasis{difficult} to understand, the final version of our program is ◊emphasis{simple}. It uses almost no features from the underlying programming language (Racket). Namely, it uses only three features: (1) definitions of anonymous functions of a single argument and a single return value; (2) applications of those functions; and (3) references to variables.

It would not be possible to ◊informal{encode away} any of these three features and still preserve the meaning of our program. Does this mean we reached the essence of programming languages? That is the subject of the next section.

◊section['the-essence]{The Essence}

◊new-thought{In this article}, we started with a short program that was easy to understand, but which used many features of the underlying programming language: numbers, booleans, conditionals, recursion, and more. To look for the essence of programming languages, we ◊informal{encoded features away}. We rewrote the program many times, preserving its meaning but encoding features in terms of other, simpler, features.

We iterated until we reached a minimal, irreducible set of features: definition and application of anonymous functions of single argument and return value; and variable references. The result was an unrecognizable program, albeit a very ◊emphasis{simple} one. Do these features represent the essence of programming languages?

Not quite. One evidence is that we had to choose our base programming language (Racket) based on certain criteria. For example, it had to a language in which functions were values. If our resulting program represented the essence of programming languages, then C—a language in which functions are not values—would not qualify as a programming language. And it does.

◊margin-note{Explaining the inner workings of Turing Machines, ◊acronym{SKI} combinator calculus and tag systems is beyond the scope of this article. The relevant aspect is that each of these constitutes minimal, irreducible sets of features for programming languages.}

Moreover, had we taken a different turn on the road, we would have reached a different set of essential features. For example, we could have arrived at a machine with an infinite tape of cells, a head that reads and write to the tape and a set of rules to follow for reading, writing and moving the tape. This machine is known as Turing Machine. Or we could have arrived at something more esoteric, like the ◊acronym{SKI} combinator calculus or a tag system.

◊margin-note{The process of encoding anonymous inner functions in terms of regular C functions is called ◊technical-term{closure conversion}. It is a technique commonly used in compilers for functional programming languages.}

If we had decided for a different approach, we could have encoded the features from our final program in terms of other features. For example, we could have encoded anonymous inner functions in terms of regular C functions, which cannot be nested and must have names.

So we are still one step away from the essence. The essence must be what all these different minimal sets of features have in common. Thus, the essence of programming languages must be the essence of computation itself. Because the ability to perform arbitrary computations is the only similarity between the systems mentioned above.

This brings us to the most important result of this article: What is the essence of programming languages? What is the essence of computing? What is the common aspect of the different systems capable of computing? ◊emphasis{Communication}.

The essence of programming languages is that they allow arbitrary ◊emphasis{communication} of data across the program. In our final program, communication is the only feature that remained. We ◊informal{encoded away} the numbers, booleans and more, and the only thing left were functions. Functions served two purposes in our program. First, functions served as ◊emphasis{data}. This is why we had to choose a base language in which functions were values—functions were the only kind of data left in the program. The second purpose functions served in our program was as a mechanism to ◊emphasis{communicate} data from calling site to function body, in the form of passing arguments and receiving the return value back.

◊margin-note{The observation that all these different minimal sets of features are equivalent in computational power is an important result of computer science theory. It is called Church–Turing thesis.}

The minimal set of features at which we arrived after our rewrites is particularly elegant because of this dual nature of functions. It is simple to describe—if difficult to understand—because it is compact. And the compactness stems from the property that functions are simultaneously data and a means to ◊emphasis{communicate} data.

◊margin-note{Another conclusion from our journey is that, apart from matters of convenience and taste, all general-purpose programming languages are equivalent in computational power. In other words, any existing program could be translated to any existing language. It might not be practical, but it is at least theoretically possible.}

But, in one way or another, all the minimal sets of features at which we could have arrived—for example, Turing Machines and the ◊acronym{SKI} combinator calculus—have the same essential capacity of enabling arbitrary ◊emphasis{communication} of data across the system.

◊paragraph-separation[]

◊emphasis{Communication is the essence of programming languages and of computation.}

◊section['conclusion]{Conclusion}

◊new-thought{Our journey to the essence} of programming languages is complete. We started with a regular program and transformed it several times to make it simpler, until we could finally observe that ◊emphasis{communication} is the essence of programming languages. This is an important result on itself, but it is far from being the only interesting takeaway from this article. The encodings are based on techniques that are generally applicable in real-world programs. The following paragraphs summarize them.

The first and most important lesson regarding encodings is that whenever a language does not have a feature, we can encode it using the existing features. How convenient and practical it is to do so varies, but theoretically it is always an option. Ultimately, any task in programming can be framed as encoding constructs that do not exist in the base language—or in any language. These constructs may be the ones that we ◊informal{encoded away} in this article, or they may be constructs related to tracking bicycle trips, for example.

When encoding numbers, we chose to use functions. With this choice, we encoded numbers not by what ◊emphasis{they are}, but by what ◊emphasis{they do}. Simply put, what numbers do is to count, so our encoding for them was to repeatedly apply a function, which effectively is performing a count. This shows that data (what numbers ◊emphasis{are}) and computation (what they do ◊emphasis{do}, in our encoding) are two sides of the same coin. Our final conclusion about the nature of functions manifested from the start.

The most complicated operation to implement in our encoded numbers was ◊code/inline{sub1}. We did it using a ◊technical-term{sliding window} over the number line. This technique is applicable to all sorts of search in series in which each element depends on the previous ones. For example, calculating the Fibonacci numbers, in which each element is the sum of the previous two.

For the encoding of booleans, we again used an encoding in terms of what ◊emphasis{they do}, instead of what ◊emphasis{they are}. The purpose of booleans in to choose between two options—◊technical-term{true} and ◊technical-term{false}.

◊margin-note{This capability to ◊informal{remember} that functions have is related to ◊technical-term{lexical scoping}. Languages with ◊technical-term{dynamic scoping} (for example, Emacs Lisp) behave differently and the result would not be the same in them.}

The encoding of pairs uses an important capability of functions: they ◊informal{remember} the values they had in scope when defined. A fundamental part of this encoding were the inner functions that ◊informal{remembered} the arguments of the outer functions even after the outer functions had returned.

Another interesting technique we introduced in the encoding for pairs is that, when a function does not enough information to act, it can delegate to a helper function, which it receives as argument. In the particular case of pairs, the ◊code/inline{retriever} did not know which element of the pair (◊code/inline{left} or ◊code/inline{right}) to retrieve. So it received a ◊code/inline{selector} function as argument, transferring the responsibility of deciding which element to retrieve to the calling site. The calling site knows which element of the pair it needs, and that is why this technique works.

The final lesson from the encoding of pairs is that any data structure is, in its essence, just a construct to couple data together. There is a huge number of different data structures to solve particular issues, for example optimizing access time, but their fundamental purpose is still simple. Moreover, it is possible to construct sophisticated data structures from simpler ones—for example, construct lists out of pairs. To solve a complex problem, in many cases it is better to build more sophisticated data structures in which the problem can be phrased naturally than to try to solve the problem directly. This was precisely the approach we took when introducing pairs in ◊code/inline{sub1}.

The encoding for recursion was another instance of the technique “if a function does not have enough information to act, it should receive another function that does as argument.” In this case, the functions that need more information and that have the information happen to be the same. Even the ◊technical-term{tying the knot} technique is an example of this. It relies on mutation of the program state (◊code/inline{set!}), and mutation can be interpreted as an extra argument to every function, carrying the global program state. When using the ◊technical-term{tying the knot} technique, the global program state includes the ◊informal{function that has the information necessary to act}.

◊margin-note{Functional programming languages are increasingly popular, and some of their features appear in traditionally non-functional languages—for example, Java 8 includes closures. This contributes to blur the line between paradigms, rendering obsolete definitions such as ◊technical-term{object-oriented} and ◊technical-term{functional}.}

When encoding functions with multiple arguments, we took to an extreme the ◊informal{memory} features of inner function definitions, which we had already explored in the encoding for pairs. We created cascades of functions that received a single argument and returned intermediary functions. In every day programming, the ability to create inner functions is one of the most useful, and is a significant reason for the recent popularity of functional programming languages.

◊margin-note{◊emphasis{Communication} is so important that it was the primary motivation for writing this article: to ◊emphasis{communicate} the important ideas of computer science to practitioners.}

The final practical lesson for working programmers in this article comes from the encoding of named definitions. After the transformation, the program becomes unintelligible. This shows the importance of naming in programming. Not only we must identify abstractions, but we also must give them good names. Working programmers are not only writing programs that work—computers interpret our unintelligible final version of the program without problems—but, more importantly, ◊emphasis{communicating} ideas to other people, so that they can understand and improve them in the future.

Again, coming from a different direction, we acknowledge the importance of ◊emphasis{communication}. We have now come full circle:

◊paragraph-separation[]

◊emphasis{The essence of programming languages is communication.}

◊section['references]{References}

◊new-thought{The main inspiration} for this article were the talks by Jim Weirich on the Y-combinator: the Ruby version was in ◊link["https://www.youtube.com/watch?v=FITJMJjASUs"]{Ruby Conf 12, ◊publication{Y Not- Adventures in Functional Programming}}; and the JavaScript version was in ◊link["https://vimeo.com/45140590"]{ScotlandJS 2012, ◊publication{Adventures in Functional Programming}}. Also, Tom Stuart’s talk and article ◊link["https://codon.com/programming-with-nothing"]{Programming with Nothing}; and his book ◊link["http://computationbook.com/"]{Understanding Computation}. Together, they not only inspired this article, but motivated me to pursue a Ph.D. in programming-language theory.

Another talk that was hugely influential to me is ◊link["https://www.youtube.com/watch?v=_ahvzDzKdB0"]{◊publication{Growing a Language}}, by Guy Steele in OOPSLA 1998. His presentation skills are remarkable.

But none of these sources touch on the essence of programming languages that we uncovered in this article: ◊emphasis{communication}. For more on the relation between communication and computation, refer to ◊link["https://wolframscience.com/"]{A New Kind of Science}, by Stephen Wolfram.

Finally, people interested in the academic side of programming-language theory can read the book ◊link["https://pl.cs.jhu.edu/pl/book/dist/"]{Principles of Programming Languages}, by Dr. Scott F. Smith, my advisor. It includes an introduction to the notation and jargon used in research and is essential to be able to read conference articles.