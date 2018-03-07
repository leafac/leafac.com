#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}
◊define-meta[date]{2017-04-05}

◊margin-note{This article assumes prior knowledge in programming. Experience with functional programming languages in general and ◊reference["https://racket-lang.org/"]{Racket} in particular are helpful, but not required. Refer to Racket’s ◊reference["https://docs.racket-lang.org/quick/index.html"]{quick introduction} for more.}

Programming languages come in many sizes and flavors. Working programmers have been exposed to a few of them and might wonder: What is the essence of programming languages? In this article, we explore this question, but, unlike most presentations on the topic, we avoid mathematical notation and jargon. We start with a small program and remove one abstraction at a time, until we reach the core of what make programming languages work. The whole discussion is driven by executable code, making it approachable to all programmers.

Besides satisfying curiosity, this article introduces programming techniques that are generally applicable in everyday programming. And, for people starting in programming-language design and analysis, this article introduces a minimal programming language core from which to build.

◊section['starting-point]{Starting Point}

Consider the following program:

◊margin-note{The same program is given in three popular programming languages to help people who can read them get started. But, from now on, we proceed only in Racket. Racket is a convenient language for this article, because it allows us to redefine even core constructs like operators (for example, ◊code{+}) and control-flow primitives (for example, ◊code{if}). But, convenience aside, there is nothing special about Racket. Any dynamically typed language in which functions are values would work as well. This includes Ruby, Python, JavaScript, and many more. This does not include C, for example, in which pointers to functions are values, but functions themselves are not. It also does not include OCaml or Haskell, because while functions are values in these languages, their static type systems are not expressive enough for some of the programs in this article. There are static type systems with the necessary expressiveness, but they are rare.}

◊code/block[#:language 'racket #:caption "Racket"]{
(define (sum-up-to number)
  (if (zero? number)
      0
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to 5)
}

◊code/block[#:language 'ruby #:caption "Ruby"]{
def sum_up_to number
  if number.zero?
    0
  else
    number + sum_up_to(number - 1)
  end
end

sum_up_to 5
}

◊code/block[#:language 'java #:caption "Java"]{
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

◊margin-note{◊code{0 + 1 + 2 + 3 + 4 + 5 = 15}}

This program defines a function that sums integers from zero up to a given number, then calls this function with ◊code{5}, outputting ◊code{15}. What are the essential features in programming languages that allow this program to be written? To address this question, we first have to consider what ◊emphasis{is} an essential feature.

Suppose one wants to write an application that tracks information about bicycle trips. If one could find a programming language that comes with native constructs for distances, weather conditions and so on, then that would be a perfect fit. But programming languages generally do not have these features, so one has to use numbers, functions, lists, records, objects and other simpler features to ◊emphasis{encode} the necessary functionality.

◊margin-note{Encoding abstractions in simpler terms is the job of most compilers. They receive as input a program in a language with more features than the machine code they output. So the techniques we introduce are related to the transformations a compiler would apply to a source program. But we are looking for the essence of programming languages, therefore the language we are targeting is even simpler than machine code.}

◊margin-note{◊figure/svg{images/convenience-vs-simplicity.svg}}

Bicycle-trip information is not an essential feature of programming languages, that is why they do not have it. But that is not a problem, because the key observation is that ◊emphasis{any feature a language does not have, we can encode in terms of simpler features}. Most features included in most programming languages are non-essential—like bicycle-trip tracking would be—they exist solely for convenience. Not having a feature makes the language simpler, having it makes it more convenient. Our goal in this article is to explore this simplicity–convenience spectrum, removing one feature at a time, in the direction of simplicity. When we can no longer ◊informal{encode features away} without breaking the program, what remain are the ◊emphasis{essential features}—we will then have reached the essence of programming languages.

It is important to note that simplicity is not the same as easiness. As we advance, programs get simpler, because they use fewer features, but they also become more difficult to understand. Think of the difference between programs in Ruby and C that perform the same task: while C is a simpler language, programs in it tend to be more difficult to read.

◊section['numbers]{Numbers}

For convenience, here is the initial program again:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (if (zero? number)
      0
      (+ number (sum-up-to (sub1 number)))))

(sum-up-to 5) ;; => 15
}

The first features we remove via encoding are numbers and operations on them. There many different ways to rewrite the program above without numbers. For example, one could use strings to represent numbers, redefining the operations on them accordingly:

◊margin-note{The ◊code{___} in the code represent code omitted for simplicity.}

◊code/block[#:language 'racket]{
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

Alternatively, we could encode numbers with strings not using their string representation, but the string length. In this encoding, the contents of the strings representing numbers would be irrelevant, only their length would be meaningful. For example, ◊code{0} would become ◊code{""}, ◊code{1} would become ◊code{"☺"}, ◊code{5} would become ◊code{"☺☺☺☺☺"}, and so on. The running example would look like the following in this encoding:

◊code/block[#:language 'racket]{
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

◊margin-note{This encoding for numbers using the lengths of lists is called ◊technical-term{Peano numbers}.}

On a related idea, we could encode numbers as list lengths. Again, the contents of the lists would be irrelevant, only their length would be meaningful:

◊code/block[#:language 'racket]{
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

Some encodings are more convenient than others. For example, it is more difficult to implement addition in the first encoding presented above than in the other two. The first encoding uses the string representation of numbers, so implementing addition in it amounts to recreating the addition algorithm taught in elementary school, including addition tables, carries and so on. But in the other two encodings, addition is just appending (either strings or lists), which is easy to implement.

◊margin-note{The name of this encoding of numbers using functions is ◊technical-term{Church Encoding}.}

◊margin-note{Numbers are values. Our decision to encode them as functions is the reason why the base programming language for this article had to treat functions as values.}

We are not seeking easiness, though. So, from all the possible encodings, we choose one that is unnatural and inconvenient, but interesting: we encode numbers using ◊emphasis{functions}. Each number is a function of two arguments: the first, another arbitrary function; and the second, an arbitrary argument. These functions representing numbers repeatedly apply the first argument to the second, and the amount of applications represents the number being encoded:

◊margin-note{Another interpretation for this encoding is that ◊code{zero} means “do not do anything to the argument,” ◊code{one} means “do something to the argument once,” ◊code{five} means “do something to the argument five times,” and so on.}

◊margin-note{◊emphasis{Everyday programming takeaway}: Our encoding for numbers is based on ◊emphasis{what they do} (to count), instead of ◊emphasis{what they are} (data). When designing a system, consider what the entities in it do, besides what they are. This might lead to a better overall design. For example, instead of modeling ◊emphasis{student} and ◊emphasis{staff} as data types, consider modeling ◊emphasis{enroll in classes} and ◊emphasis{budget planning} as actions. This fits better a case in which a person is part of the staff and wants to take classes at the same institution, for example.}

◊code/block[#:language 'racket]{
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

◊margin-note{The encoding only supports non-negative integers. This is fine for our purposes in ◊code{sum-up-to}, which only works over non-negative integers.}

For ◊code{zero}, the given function is not applied, the argument is returned unaltered. For ◊code{one}, the given function is applied once. For ◊code{five}, the given function is applied five times. And so on.

When we print these numbers to inspect them, this is what Racket outputs:

◊code/block[#:language 'racket]{
> five
#<procedure:five>
}

As the listing above illustrates, functions are opaque, so we introduce extra machinery. This is a non-essential feature of programming languages and is not part of our program, but it helps us read the program’s output:

◊code/block[#:language 'racket]{
(define (pretty-print number)
  (number add1 0))
}

The function ◊code{pretty-print} is not part of our main program, it only exists as a helper. That is why it is allowed to contain regular Racket numbers and operations on them—namely, ◊code{0} and ◊code{add1}. It receives as argument a number encoded in terms of functions and transforms it back into a regular number, so that we can read it:

◊code/block[#:language 'racket]{
> (pretty-print zero)
0
> (pretty-print one)
1
> (pretty-print five)
5
}

The way ◊code{pretty-print} works reveals how this encoding of numbers using functions works. Numbers are functions, so ◊code{pretty-print} ◊emphasis{applies that function}. As arguments, numbers receive another function and an initial value. Then the number repeatedly applies that given function to the initial value; the amount of applications corresponds to the number we want to encode.

The function ◊code{pretty-print} makes a careful choice of arguments with which it calls the number. The initial value is ◊code{0}, and the function to be repeatedly applied is ◊code{add1}. So, ◊code{(pretty-print five)} evaluates as the following:

◊code/block[#:language 'racket]{
(add1
 (add1
  (add1
   (add1
    (add1 0))))) ;; => 5
}

◊new-thought[]

Now that we have an encoding for numbers, we need to adapt out program to use it. For the main function, ◊code{sum-up-to}, we just change the return from ◊code{0} (the native Racket number) to ◊code{zero} (our encoding as defined above):

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (if (zero? number)
      zero
      (+ number (sum-up-to (sub1 number)))))
}

The next step is to modify the functions that work on the numbers so that they are aware of the encoding we introduced. There are three of them: ◊code{zero?}, ◊code{sub1} and ◊code{+}.

◊margin-note{In Racket, ◊technical-term{true} is spelled ◊code{#t} and ◊technical-term{false} is spelled ◊code{#f}.}

To implement ◊code{zero?}, we can use an idea similar to ◊code{pretty-print}: call the number—which is a function—with carefully chosen arguments. For the initial value, we choose ◊code{#t}, and for the function we choose one that always returns ◊code{#f}:

◊code/block[#:language 'racket]{
(define (zero? number)
  (define (always-false ignored-argument)
    #f)
  (number always-false #t))
}

Remember that these are the encoded numbers:

◊code/block[#:language 'racket]{
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

So, if ◊code{zero?} is called with ◊code{zero}, then the initial value ◊code{#t} is returned unaltered. If ◊code{zero?} is called with ◊code{one}, then it becomes ◊code{(one always-false #t)}, which then becomes ◊code{(always-false #t)}, and evaluates to ◊code{#f}. The same happens to any number that is not ◊code{zero}:

◊code/block[#:language 'racket]{
> (zero? zero)
#t
> (zero? one)
#f
> (zero? five)
#f
}

◊new-thought[]

To implement addition (◊code{+}), we can use the following observation: if the number ◊code{number-left} means “do something to the argument ◊code{number-left} times,” and the number ◊code{number-right} means “do something to the argument ◊code{number-right} times,” then the number ◊code{number-left + number-right} means “do something to the argument ◊code{number-left + number-right} times.” In particular, we can ◊informal{do something} to the argument ◊code{number-right} times and use the result as the initial value to ◊informal{do something} to the argument ◊code{number-left} times:

◊margin-note{
 Addition is a commutative operation (◊code{number-left + number-right = number-right + number-left}). So inverting ◊code{number-left} and ◊code{number-right} does not change the meaning of ◊code{+}. The return value ◊code{result} could equivalently be defined as the following:

 ◊code/block[#:language 'racket]{
(number-left function
  (number-right function
                argument))
 }
}

◊code/block[#:language 'racket]{
(define (+ number-left number-right)
  (define (result function argument)
    (number-left function (number-right function argument)))
  result)
}

The following listing is an example of ◊code{+} in use:

◊code/block[#:language 'racket]{
> (pretty-print (+ five five))
10
}

◊new-thought[]

For the last operation on numbers, ◊code{sub1}, we start by simplifying the problem by reducing its scope. In ◊code{sum-up-to}, the function ◊code{sub1} is only called with positive numbers. Also, our encoding using functions can only represent non-negative numbers. So, we define ◊code{(sub1 zero)} to output ◊code{zero} instead of ◊code{-1} as it should according to mathematics.

◊margin-note{
 ◊figure/svg{images/sub1.svg}

  In the figure above there are ◊emphasis{five} blue arrows, representing the steps we take to calculate ◊code{sub1} of ◊code{five}.
}

With this restriction in place, we can define ◊code{sub1} for positive integers using a ◊technical-term{sliding window} over the number line. Starting with a pair ◊code{(zero, zero)}, for each step, the right element goes to the left, and the new right element is the current plus one. Another way of interpreting this is that the right element is traversing the number line and the left element is one behind it. We take that step ◊code{number} times and the predecessor of the given ◊code{number} is the element on the left of the pair:

◊margin-note{To represent pairs, we use ◊code{(struct pair (left right))}, instead of Racket’s native pairs, because the names ◊code{cons}, ◊code{car} and ◊code{cdr} are not intuitive.}

◊code/block[#:language 'racket]{
(struct pair (left right))

(define (sub1 number)
  (define initial-pair (pair zero zero))

  (define (slide-pair current-pair)
    (define current-number (pair-right current-pair))
    (pair current-number (+ current-number one)))

  (define final-pair
    (number slide-pair initial-pair))

  (pair-left final-pair))
}

We can test ◊code{sub1} and see the result using ◊code{pretty-print}:

◊code/block[#:language 'racket]{
> (pretty-print (sub1 five))
4
}

◊new-thought[]

At this point, we have all the numeric operations necessary for ◊code{sum-up-to} encoded in terms of functions. This means that numbers are not an essential feature of programming languages. On the next section, we address the only other primitive data type used in our program: booleans.

◊section['booleans]{Booleans}

There is only one place in which we use a boolean in our program: the conditional (◊code{if}) in ◊code{sum-up-to}’s body. Its condition depends on ◊code{zero?}, which is the only function generating booleans. For convenience, the following lists their current definitions again:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (if (zero? number)
      zero
      (+ number (sum-up-to (sub1 number)))))

(define (zero? number)
  (define (always-false ignored-argument)
    #f)
  (number always-false #t))
}

◊margin-note{We are considering ANSI C 89 in this discussion.}

Are booleans an essential feature of programming languages, or can we ◊informal{encode them away}? Programmers familiar with C know that the answer to this question is negative, because in C there are no booleans. They are encoded in terms of numbers: zero represents ◊technical-term{false} and any other number represents ◊technical-term{true}.

As was the case with numbers, different encodings are possible. For example, we could use the strings ◊code{"true"} and ◊code{"false"}; or an empty list could mean ◊technical-term{false} and lists with at least one element could represent ◊technical-term{true}. And, as before, some encodings are more convenient than others.

◊margin-note{This encoding of booleans using functions is also called ◊technical-term{Church Encoding}.}

A particularly interesting choice would be to follow C’s example and use numbers to encode booleans. But, since in the ◊reference["#numbers"]{previous section} we ◊informal{encoded numbers away} in terms of functions, we are consistent and use functions to encode booleans:

◊margin-note{There is nothing special about the names ◊code{true} and ◊code{false}. They are regular functions, like ◊code{sub1}, ◊code{pretty-print} and so on.}

◊code/block[#:language 'racket]{
(define (true first second)
  first)

(define (false first second)
  second)
}

◊margin-note{◊emphasis{Everyday programming takeaway}: Our encoding for booleans is another example of reasoning about ◊emphasis{what things do} (to select either ◊technical-term{true} or ◊technical-term{false}), instead of ◊emphasis{what they are} (data).}

In our encoding, booleans are functions that receive two arguments. The value ◊code{true} returns the first argument, and ◊code{false} returns the second argument.

We can now adapt ◊code{zero?} to use these values:

◊code/block[#:language 'racket]{
(define (zero? number)
  (define (always-false ignored-argument)
    false)
  (number always-false true))
}

Because we changed the representation of booleans, we need to modify the conditional (◊code{if}) accordingly. It receives as arguments a condition, a value (◊code{then}) to return in case the condition is ◊technical-term{true} and another value (◊code{else}) in case it is ◊technical-term{false}. The condition is a boolean which we encoded as a function, and this function is already capable of choosing which value to return:

◊margin-note{Again, there is nothing special about the names ◊code{if},  ◊code{then} and ◊code{else}. To this point, the name ◊code{if} was referring to Racket’s conditionals, but after this definition it became just another function. And ◊code{then} and ◊code{else} are regular variables, like ◊code{number-left}, ◊code{number-right} and so on.}

◊margin-note{Conditionals are so natural to encode because our choice of encoding for booleans was deliberate to make this happen.}

◊code/block[#:language 'racket]{
(define (if condition then else)
  (condition then else))
}

We introduced a problem in ◊code{sum-up-to}, though. Here is its current definition one more time:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (if (zero? number)
      zero
      (+ number (sum-up-to (sub1 number)))))
}

◊margin-note{This termination problem only occurs because of Racket’s evaluation order. Racket is a call-by-value language, which means function arguments are evaluated to values before the function starts to execute. There exists other languages with other evaluation orders, and in them this issue would not arise. For example, Haskell is a call-by-need language: arguments to a function are only evaluated when they are used. Arguments that are not used are never evaluated. So a program equivalent to ours written in Haskell would not run forever.}

Before we encoded ◊code{if}, this code was using Racket’s ◊code{if}. And Racket’s ◊code{if} only executes a branch if necessary. In particular, the part ◊code{(+ number (sum-up-to (sub1 number)))} only ran if ◊code{(zero? number)} was ◊technical-term{false}. But now, because ◊code{if} is a function call, by the time we check the condition to make a decision, this part already ran. And it contains a recursive call to ◊code{sum-up-to}, which leads to an infinite sequence of recursive calls. This program does not terminate.

To solve this issue, we ◊informal{wrap} the conditional branches in functions, so that they do not execute right away. We then use ◊code{if} to choose the right function to call:

◊margin-note{Another way of thinking about this step is that the functions in which we ◊informal{wrap} the conditional branches are ◊technical-term{delaying} the computation until it is necessary—at which point we call the function.}

◊margin-note{◊emphasis{Everyday programming takeaway}: Avoid unnecessary expensive computations by ◊technical-term{delaying} them with ◊informal{wrapper functions}. For example, a debug logging entry might involve expensive computations that can be avoided if the appropriate log level is not reached.}

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

◊margin-note{To define ◊code{then} and ◊code{else} as non-function values, one would write ◊code{(define then ___)}, without the parentheses around ◊code{then}.}

The key observation regarding the listing above is that ◊code{(define (then) ___)} and ◊code{(define (else) ___)} are defining two ◊emphasis{functions} called ◊code{then} and ◊code{else}. These functions receive no arguments, that is why we define them with ◊code{(define (then) ___)} and not ◊code{(define (then x y z) ___)}. Similarly, the code ◊code{(branch-to-take)} is calling the function ◊code{branch-to-take} without any arguments.

◊new-thought[]

Our work with booleans is complete. There are no longer any native Racket booleans in our program, they have been encoded into functions. Moreover, our program contains no primitive values (numbers, booleans, strings, and so on), and it continues to have the same meaning:

◊code/block[#:language 'racket]{
> (pretty-print (sum-up-to five))
15
}

So we can conclude that primitive values are not essential features to programming languages, which is a surprising result. Are compound data structures essential? On the next section we explore this question.

◊section['pairs]{Pairs}

The only instance of a data structure in our program is a ◊technical-term{pair}, used in ◊code{sub1}. There are three functions to interact with pairs: the function ◊code{(pair left right)}, which creates a pair with the elements ◊code{left} and ◊code{right}; the function ◊code{(pair-left pair)}, which receives a pair and returns the element on the left; and the function ◊code{(pair-right pair)}, which receives a pair and returns the element on the right.

◊margin-note{The compound of a function and the outer variable references whose value it ◊informal{remembers} is called a ◊technical-term{closure}.}

◊margin-note{◊emphasis{Everyday programming takeaway}: This ◊informal{memory} capability that inner functions have is necessary for some important features in popular programming languages. For example, Ruby blocks and JavaScript functions passed to (for example) ◊code{.forEach()} can refer to variables local to their definition site, not their calling site inside (for example) ◊code{.forEach()}’s implementation.}

Encodings for pairs are not as natural as, for example, the encoding for numbers in terms of strings. But can it be done at all? In particular, can we use functions for that purpose, since we have used them for primitive data types in the previous sections? It turns out that we can. And the crucial insight is that inner functions (functions defined within other functions) can refer to arguments of the outer function. They ◊informal{remember} those arguments even after the outer function has returned. The following listing illustrates this:

◊margin-note{Similar to ◊code{then} and ◊code{else} in ◊code{sum-up-to} (see ◊reference["#booleans"]{previous section}), ◊code{retriever} is a function that receives no arguments.}

◊code/block[#:language 'racket]{
(define (store value)
  (define (retriever)
    value)

  retriever)

(define stored-5 (store five))
(define stored-1 (store one))

(pretty-print (stored-5)) ;; => 5
(pretty-print (stored-1)) ;; => 1
}

In the code above, ◊code{store} is a function which receives a ◊code{value} and stores it for later. The way to retrieve the value is to apply the function returned by the call to ◊code{store}. It works by defining and returning an inner function, ◊code{retriever}, which has access to the outer ◊code{value} and ◊informal{remembers} it, even after ◊code{store} itself has returned.

To implement a pair, we can use the idea from ◊code{store}, but with two ◊code{value}s as arguments to ◊informal{remember}. The problem then becomes: when retrieving, which of the two values to return? This is not a decision we can make at the point of defining ◊code{retriever}, because information about which of the two values to return is only known when retrieving.

The solution is to modify ◊code{retriever} to receive an argument, a ◊code{selector} function. Then ◊code{retriever} calls ◊code{selector} with both values in the pair and let it decide which one to return. With that, the ◊code{pair} function is complete:

◊code/block[#:language 'racket]{
(define (pair left right)
  (define (retriever selector)
    (selector left right))
  retriever)
}

We can now create pairs, but to retrieve the values from it we still have to define the selectors. They receive ◊code{left} and ◊code{right} and return the correct element in the pair:

◊margin-note{Apart from identifiers, ◊code{selector-left} is the same function as ◊code{true} and ◊code{selector-right} is the same function as ◊code{false}. This is not a coincidence, but evidence of the duality between disjunction (a boolean is ◊emphasis{either} ◊code{true} ◊emphasis{or} ◊code{false}) and conjunction (a pair holds a ◊code{left} ◊emphasis{and} a ◊code{right} elements). They are two sides of the same coin. This is a fundamental result of ◊reference["https://www.infoq.com/presentations/category-theory-propositions-principle"]{category theory}.}

◊code/block[#:language 'racket]{
(define (selector-left left right)
  left)

(define (selector-right left right)
  right)
}

With the selectors defined above, pairs are functional, as the listing below exemplifies:

◊code/block[#:language 'racket]{
(define number-pair (pair five one))

> (pretty-print (number-pair selector-left))
5
> (pretty-print (number-pair selector-right))
1
}

We are now one step away from defining the accessor functions ◊code{pair-left} and ◊code{pair-right} used by ◊code{sub1}. We only need to wrap the usage pattern from the listing above:

◊margin-note{The technique to turn selectors (◊code{selector-left} and ◊code{selector-right}) into accessors (◊code{pair-left} and ◊code{pair-right}) is the same to turn booleans (◊code{true} and ◊code{false}) into conditionals (◊code{if}).}

◊margin-note{◊emphasis{Everyday programming takeaway}: When refactoring, do not change the interface to existing functionality.}

◊code/block[#:language 'racket]{
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

◊code/block[#:language 'racket]{
> (pretty-print (pair-left number-pair))
5
> (pretty-print (pair-right number-pair))
1
}

More importantly, our program is working with this encoding for pairs in terms of functions:

◊code/block[#:language 'racket]{
> (pretty-print (sum-up-to five))
15
}

◊new-thought[]

Before we move on to other programming-language features that we might question as either ◊technical-term{essential} or ◊informal{encodeable}, let us appreciate the importance of the result above. We used functions to encode pairs, but what about other data structures? They are not used ◊code{sum-up-to}, but, if they were, could we ◊informal{encode them away}? Or are there data structures which are ◊technical-term{essential} features in programming languages?

One more time, the answer is that data structures in general are ◊informal{encodeable} in terms of simpler features. And, once again, there are different encodings available. In particular, it is possible to encode all data structures in terms of pairs; and, ultimately, in terms functions, by the result of this section. The figure below illustrates examples of encodings:

◊margin-note{Encodings only depend on previously defined data structures, so the whole construction is well-founded.}

◊figure/svg{images/data-structures.svg}

In the figure above, lists (also known as arrays and vectors) are composed of pairs of pairs and a distinguished empty pair. This distinguished empty pair could be represented by, for example, ◊technical-term{false}—anything outside the range of possible list elements (integers, in the example) would work.

A list containing pairs of elements could be interpreted as a record (also known as dictionary, hash and associative array). The left element of the pair is the key and the right element is the value.

◊margin-note{How can we create a record including a reference to itself? We can start by adapting the techniques from the ◊reference["#recursion"]{next section} on recursion, but the details of this particular construction are beyond the scope of this article.}

Finally, with records it is possible to encode objects. Some fields are non-function values (for example, ◊code{name} and ◊code{birthdate}), and some are functions (for example, ◊code{age}), which can be interpreted as methods. One special record field (◊code{self}) contains a reference to the whole record itself. This self-awareness is necessary so that methods (for example, ◊code{age}) can refer to other object attributes (for example, ◊code{birthdate}).

Objects can get more complicated, with features such as inheritance and polymorphism. Also, there exists many other data structures: tuples, trees and more. But, with varying degrees of difficulty, they are all encodeable in terms of pairs, the simplest way to couple data together. So, ultimately, this section shows that all data structures can be defined in terms of functions.

◊new-thought[]

The next features we have to address are those in functions themselves, because they are the only kind of value left in our program. What aspects of functions are essential features of programming languages? What aspects can be ◊informal{encoded away}? In the next section, we address the most powerful feature of functions: ◊emphasis{recursion}.

◊section['recursion]{Recursion}

There is only one recursive function in our program: ◊code{sum-up-to}. The following is its current definition, for convenience:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

The particular point of recursion is the call to ◊code{sum-up-to} in the ◊code{else} branch. This works because, in Racket, when defining the function using ◊code{(define (sum-up-to number) ___)} the binding for ◊code{sum-up-to} is available in the body. Can we ◊informal{encode this feature away}?

Surprisingly, the answer to this question is positive. And there are multiple possible encodings; the simplest is known as ◊technical-term{tying the knot}. To ◊technical-term{tie the knot} in our program, we start by introducing an auxiliary function ◊code{sum-up-to/rest} which ◊code{sum-up-to} calls in place of the recursive call:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

The name ◊code{sum-up-to/rest} for this auxiliary function is appropriate because, as implemented, ◊code{sum-up-to} is only performing one step of the computation; it delegates the rest of the computation to ◊code{sum-up-to/rest}. The question then becomes: how do we implement ◊code{sum-up-to/rest}?

A first idea would be to copy and paste the implementation for ◊code{sum-up-to}:

◊code/block[#:language 'racket]{
(define (sum-up-to/rest number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))

  (branch-to-take))
}

But this idea is bad, because now ◊code{sum-up-to/rest} is using recursion, the exact feature we are trying to ◊informal{encode away}. Alternatively, we could reuse our previous idea and rewrite ◊code{sum-up-to/rest} to delegate to another auxiliary function ◊code{sum-up-to/rest2}. But this idea is also bad, because we would be just delaying the problem: how would we write ◊code{sum-up-to/rest2}?

Because we do not know how to implement ◊code{sum-up-to/rest}, we can leave it for later, defining just a placeholder:

◊margin-note{The implementation of ◊code{sum-up-to/rest} must appear before the one for ◊code{sum-up-to}, and it must not refer to ◊code{sum-up-to}. Otherwise it would again be (indirectly) relying on Racket’s support for recursion.}

◊code/block[#:language 'racket]{
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

Before we can use ◊code{sum-up-to}, we have to provide an implementation for ◊code{sum-up-to/rest}. But, once ◊code{sum-up-to} has been defined, we can use it to implement ◊code{sum-up-to/rest}. The resulting program is still non-recursive, because all variables are defined before they are used. We can use mutation (◊code{set!}) to ◊emphasis{change} the placeholder definition of ◊code{sum-up-to/rest} into ◊code{sum-up-to} itself:

◊code/block[#:language 'racket]{
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

After the ◊code{set!} operation, the name ◊code{sum-up-to/rest} refers to the function ◊code{sum-up-to}, instead of the placeholder implementation. So ◊code{sum-up-to} can call itself via ◊code{sum-up-to/rest}, restoring its original functionality. With this change, the program is no longer recursive, and it still outputs the same value:

◊code/block[#:language 'racket]{
> (pretty-print (sum-up-to five))
15
}

We have successfully encoded recursion, but the encoding relies on mutation of the program’s state (◊code{set!}). Can we then ◊informal{encode mutation away}? Yes, but it would be a pervasive change to the program—the encoding would require modifications to ◊emphasis{every} function definition and ◊emphasis{every} function application. In addition to their existing arguments, functions would receive a record representing the current global state of the program. This record would map the variable names to their current value. Also, in addition to their existing return value, functions would return a possibly modified record representing a possibly modified state of the program. Then, every function application would be changed to thread this global state throughout the program. And, finally, every variable reference would need to access the record, selecting the corresponding field. The following extract illustrates this idea:

◊code/block[#:language 'racket]{
(define initial-state (empty-record))

(define (sum-up-to/rest number program-state)
  (pair "TEMPORARY IMPLEMENTATION" program-state))

(define state-with-partial-sum-up-to/rest
  (record-set initial-state
              "sum-up-to/rest" sum-up-to/rest))

(define (sum-up-to number program-state)
  ___ (record-lookup program-state "sum-up-to/rest") ___)

(define state-with-complete-sum-up-to/rest
  (record-set state-with-partial-sum-up-to/rest
              "sum-up-to/rest" sum-up-to))
}

In the listing above, the placeholder implementation of ◊code{sum-up-to/rest} and ◊code{sum-up-to} were modified to receive an extra argument representing the ◊code{program-state}. Also, they return pairs of their output value and a possibly modified ◊code{program-state}. Then, when using ◊code{sum-up-to/rest} in ◊code{sum-up-to}, it is necessary to lookup its definition in the given ◊code{program-state}. Finally, we have to manage the global ◊code{program-state}, first creating it as an ◊code{empty-record}, then adding ◊code{sum-up-to/rest} as it is implemented and overwriting its value when ◊code{sum-up-to} is available.

While feasible, this solution is not elegant. It affects even the functions that do not need to change the global state of the program, because they need to thread it appropriately.

So we backtrack and reconsider our encoding for recursion, avoiding mutation. This is ◊code{sum-up-to} before we ◊technical-term{tied the knot}:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))
}

It still depends on ◊code{sum-up-to/rest}, which we do not know how to implement. But, this time, instead of coming up with a placeholder implementation for it, we change ◊code{sum-up-to} so that it receives ◊code{sum-up-to/rest} as an argument:

◊code/block[#:language 'racket]{
(define (sum-up-to sum-up-to/rest number)
  (define (then)
    zero)

  (define (else)
    (+ number (sum-up-to/rest (sub1 number))))

  (define branch-to-take
    (if (zero? number) then else))
}

Now it is the job of ◊code{sum-up-to}’s callers to provide a suitable ◊code{sum-up-to/rest}:

◊code/block[#:language 'racket]{
(pretty-print (sum-up-to ___ five))
}

What can we use to fill in the ◊code{___} above? A good candidate is ◊code{sum-up-to} itself:

◊code/block[#:language 'racket]{
(pretty-print (sum-up-to sum-up-to five))
}

This choice is similar to the one in the line ◊code{(set! sum-up-to/rest sum-up-to)} when ◊technical-term{tying the knot}. But this time there is a problem. We passed ◊code{sum-up-to} as the ◊code{sum-up-to/rest} argument when calling ◊code{sum-up-to} itself. So, in ◊code{sum-up-to}’s body, when ◊code{sum-up-to/rest} is called, this is actually a call to ◊code{sum-up-to}. And ◊code{sum-up-to} requires a ◊code{sum-up-to/rest} as its first argument:

◊figure/image["images/incomplete-self-passing.png"]{The code above, failing to execute because of the missing argument.}

Again, we can use the same idea as before to solve this issue. We can pass ◊code{sum-up-to/rest} itself as the argument:

◊margin-note{The name of this technique is ◊emphasis{self-passing}. Unsurprisingly.}

◊margin-note{The effect of self-passing is similar to the hierarchy of ◊code{sum-up-to/rest}, ◊code{sum-up-to/rest2} and so on that we proposed above. But, as we already noted, explicitly creating this unbounded sequence of functions is not possible. Instead, in the self-passing encoding, each call of the form ◊code{(sum-up-to/rest sum-up-to/rest ___)} is creating the next ◊code{sum-up-to/rest} in the chain. It is taking one step and carrying along another copy of itself as the function capable of taking the next steps.}

◊margin-note{Most static type systems are not capable of typing programs using self-passing. This is reason why OCaml, Haskell and similar languages could not be base languages for this article.}

◊margin-note{◊emphasis{Everyday programming takeaway}: When a function does not have enough information to implement part of its functionality, it can delegate to a helper function, which it receives as argument.}

◊code/block[#:language 'racket]{
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

◊code/block[#:language 'racket]{
> (pretty-print (sum-up-to sum-up-to five))
15
}

Unfortunately, we changed the interface to ◊code{sum-up-to} in this process. Now callers need to be aware of the recursion encoding, and call the function with ◊code{(sum-up-to sum-up-to number)}, which is inconvenient. We can make this better by introducing an auxiliary function ◊code{sum-up-to/partial}:

◊code/block[#:language 'racket]{
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

◊margin-note{The ◊code{sum-up-to} façade is not specific to the job of adding numbers, all the actual computation is defined in ◊code{sum-up-to/partial}. So ◊code{sum-up-to} can be abstracted to work as a façade for any recursive function encoded via self-passing. This abstract façade is called ◊technical-term{Y-combinator}.}

The algorithm for adding numbers is in ◊code{sum-up-to/partial}, and ◊code{sum-up-to} is only a façade to fix ◊code{sum-up-to/partial}’s interface. This brings us back to the original:

◊code/block[#:language 'racket]{
> (pretty-print (sum-up-to five))
15
}

◊new-thought[]

The result of this section is the most important in this article to this point. We encoded recursion in terms of non-recursive functions, using self-passing. And recursion was the ingredient that allowed ◊code{sum-up-to} to calculate sums up to arbitrarily large numbers. There is no upper bound to its argument, so it works for infinitely many inputs. If we think of a function as a lookup table from inputs to outputs, then ◊code{sum-up-to} is a table with infinitely many rows. But its definition is still finite, taking fewer than ten lines. What allows us to compact the definition this way is recursion.

◊margin-note{In other words, non-recursive functions are ◊technical-term{Turing complete}.}

The observation that recursion can be encoded in terms of non-recursive functions leads to the conclusion that non-recursive functions alone are capable of performing arbitrary computations. Anything a computer can do is expressible in terms of non-recursive functions.

There are few features left in our program. It is composed solely of (non-recursive) function definitions and applications. Can we make it even simpler? On the next section, we address functions with multiple arguments.

◊section['functions-with-multiple-arguments]{Functions with Multiple Arguments}

Almost all functions in our program receive multiple arguments. In some of them, for example, ◊code{(pair left right)}, it seems like the ability to receive multiple arguments is essential to their functionality. After all, the purpose of ◊code{pair} is exactly to couple the arguments ◊code{left} and ◊code{right} together. But is this an essential feature of programming languages, or can functions with multiple arguments be ◊informal{encoded away}, so that only functions with a single argument remain?

If we allow the encoding to include data structures, then we can find an intuitive encoding. For example, instead of ◊code{(+ number-left number-right)} receiving two arguments, it could receive a pair containing the operands: ◊code{(+ number-pair)}. Then, in its body, ◊code{+} would extract the operands from the pair and proceed as before.

We ◊reference["#pairs"]{already established} an encoding for pairs and discussed how to use it to encode lists of arbitrary size, so the reasoning above would apply to functions with arbitrary number of arguments. But then how could we implement the encoding for pairs? Remember that ◊code{(pair left right)} is itself a function with multiple arguments. To solve this impossible situation in which each encoding depends on one other, we need a new idea.

This new idea stems from two observations we have already explored: first, that functions can return functions as their return value; second, that inner functions (functions defined within other functions) have access to outer functions’ arguments. We used both of these features when defining our encoding for ◊code{pair}s, for example. The following is its implementation one more time:

◊code/block[#:language 'racket]{
(define (pair left right)
  (define (retriever selector)
    (selector left right))
  retriever)
}

In the listing above, the inner function ◊code{retriever} has access to the arguments of the outer function ◊code{pair}. Also, ◊code{pair} outputs the function ◊code{retriever} as its return value.

◊margin-note{The name of this idea of ◊informal{cascading functions} is ◊technical-term{currying}. In the intermediary stages, when some arguments are still missing, the function is said to be ◊technical-term{partially applied}.}

◊margin-note{
 ◊emphasis{Everyday programming takeaway}: Partial application generally results in concise code. For example, consider the following two equivalent function definitions:

◊code/block[#:language 'racket]{
(define (wheatley? x)
  (equal? 'wheatley x))

(define wheatley?
  (curry equal? 'wheatley))
 }

 The ◊code{curry} Racket function takes a function and some arguments for it, resulting in a partially applied function. This conciseness is welcome in small functions, for example those passed into ◊code{map} or ◊code{filter}. Bigger programs using this technique frequently tend to be difficult to read.
}

We can extend this idea to ◊informal{break apart} ◊code{pair} into a ◊informal{cascade of functions}, each receiving a single argument and returning an intermediary function:

◊code/block[#:language 'racket]{
(define (pair left)
  (define (pair/intermediary right)
    (define (retriever selector)
      (selector left right))
    retriever)
  pair/intermediary)
}

The implementation above works the same as before, but the way to call it has changed. Every invocation of ◊code{pair} has to go through the cascade. Instead of writing, for example, ◊code{(define number-pair (pair five one))}, the following is necessary:

◊code/block[#:language 'racket]{
(define number-pair/intermediary (pair five))
(define number-pair (number-pair/intermediary one))
}

More compactly, we can skip giving a name to the intermediary function and call it immediately:

◊code/block[#:language 'racket]{
(define number-pair ((pair five) one))
}

Cascades of this form extend to functions with arbitrarily many parameters. But what about functions with zero parameters? Our program includes a few of them, for example ◊code{else} in ◊code{sum-up-to}, which ◊informal{guards} the computation of the recursive call. In these cases, the encoding is to add a ◊informal{dummy} argument, which the function does not use. Also, we change the places that call such functions to pass a ◊informal{dummy} argument in. The following is an extract of ◊code{sum-up-to} including this treatment:

◊margin-note{It is important that the omitted part ◊code{___} does not refer to ◊code{dummy}, otherwise we would have changed the meaning of the program.}

◊code/block[#:language 'racket]{
(define (else dummy)
  ___)

(define (dummy ignore-me)
  ignore-me)

(else dummy)
}

◊new-thought[]

The change described in this section is pervasive. It affects most defined functions and their invocations:

◊margin-note{In this listing, we used Racket’s syntax sugar for defining ◊informal{cascades of functions}. For example, ◊code{(define ((pair left) right) ___)} is equivalent to the construction above including ◊code{pair/intermediary}, but it saves us from having to name each intermediary function in the ◊informal{cascade}. As a result, the transformation to the program consists of adding parentheses and ◊informal{dummy} arguments.}

◊code/block[#:language 'racket]{
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

◊new-thought[]

The program above is difficult to read. The only way to understand it is to retrace the steps we have took so far. Despite this difficulty, it is very ◊emphasis{simple}. It uses almost no features from Racket, which means that we are near the essence of programming languages. The next section is about the last transformation we apply to our program.

◊section['named-definitions]{Named Definitions}

We defined functions and intermediary values using the ◊code{(define ___ ___)} form all over our program. This form is convenient because it allows us to give names to concepts and computations. And this form is powerful. For example, using it we can define functions in any order, regardless of how they depend on each other. Consider the following excerpt:

◊code/block[#:language 'racket]{
(define (sum-up-to number)
  ___ (sub1 number) ___)

(define (sub1 number)
  ___)
}

◊margin-note{In C, for example, a direct translation of this listing would not be valid. The C compiler insists on knowing at least the function name and the types of its arguments and return—if not its implementation—before allowing other functions to use it.}

When programming, it is often better to represent the high-level constructs (for example, ◊code{sum-up-to}) first, and the details (for example, ◊code{sub1}) later. That is why ◊code{(define ___ ___)} form allows ◊code{sum-up-to} to refer to ◊code{sub1} even though it is only defined later. Is this an essential feature of programming languages?

◊margin-note{We have managed to discuss theory with only a single Greek letter (◊code{λ}), and it is only introduced in the last encoding. Success.}

◊margin-note{Racket’s ◊technical-term{anonymous functions} can receive multiple arguments and include multiple internal definitions and expressions. So the full form is more complex than ◊code{(λ (argument) body)}, but these extra features are not necessary for our purposes.}

The answer one more time is negative. Named definitions are not an essential feature and we can ◊informal{encode them away}, in terms of simpler features. What can be simpler than a function with a name? A function with no name (◊technical-term{anonymous function}). In Racket, ◊technical-term{anonymous functions} are spelled ◊code{(λ (argument) body)}, in which ◊code{argument} is an identifier naming the argument that the function receives, and ◊code{body} is the expression representing the computation of its return value. For example, the following two definitions are equivalent:

◊code/block[#:language 'racket]{
(define (sub1 number)
  ___)

(define sub1
  (λ (number)
    ___))
}

To ◊informal{encode away} named definitions, we first reorder them so that they can only refer to previously defined names:

◊margin-note{This step is only possible because we ◊informal{encoded recursion away} on a ◊reference["#recursion"]{previous section}.}

◊code/block[#:language 'racket]{
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

Now, we can ◊emphasis{inline} the definitions where they are used. For example, ◊code{zero?}’s current definition is:

◊code/block[#:language 'racket]{
(define (always-false ignored-argument)
  false)
((number always-false) true)
}

We can rewrite the above such that each reference to the ◊code{always-false} function is replaced with ◊code{always-false}’s implementation, using anonymous functions:

◊margin-note{
 While performing this rewrite, it is important that we avoid accidentally changing the meanings of the identifiers. For example, the following rewrite would be invalid:

 ◊code/block[#:language 'racket]{
(define (always-false
         ignored-argument)
  false)
(λ (false)
  ((number always-false) true))

;; ⇓

(λ (false)
  ((number
    (λ (ignored-argument) false))
   true))
 }

 The reason is the difference between the meanings of ◊code{false} in ◊code{always-false}’s definition and in ◊code{(λ (false) ___)}. The solution is to rename the identifier ◊code{false} in ◊code{(λ (false) ___)} to, for example, ◊code{(λ (false2) ___)}. And rename all uses of ◊code{false} in the anonymous function accordingly. Fortunately, this issue does not occur in our program.
}

◊code/block[#:language 'racket]{
((number (λ (ignored-argument) false)) true)
}

We are ready to see the final version of our program, in which all definitions are inlined:

◊margin-note{We did not inline ◊code{pretty-print} because it is external to our program. It only exists for us to inspect the result of the computation, which is a number encoded in terms of functions.}

◊margin-note{◊emphasis{Everyday programming takeaway}: One of the most important skills when designing systems is naming the concepts appropriately. The lack of good names is what makes this final version of our program unintelligible. In particular, only use anonymous functions for small functions whose meaning is evident.}

◊code/block[#:language 'racket]{
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

◊code/block[#:language 'racket]{
15
}

◊new-thought[]

◊margin-note{The set of features that are left in the program goes by the name of Lambda calculus, which explains the use of the lambda (λ) in the anonymous-function notation in Racket.}

This version of the program is remarkably difficult to read. Only a few parts are familiar and most concepts that previously were abstracted and named are now obfuscated and intertwined. No programmer would write code this way. But, despite being ◊emphasis{difficult} to understand, the final version of our program is ◊emphasis{simple}. It uses almost no features from the underlying programming language (Racket). Namely, it uses only three features: (1) definitions of anonymous functions of a single argument and a single return value; (2) applications of those functions; and (3) references to variables.

It would not be possible to ◊informal{encode away} any of these three features and still preserve the meaning of our program. Does this mean we reached the essence of programming languages? That is the subject of the next section.

◊section['the-essence]{The Essence}

In this article, we started with a short program that was easy to understand, but which used many features of the underlying programming language: numbers, booleans, conditionals, recursion, and more. To look for the essence of programming languages, we ◊informal{encoded features away}. We rewrote the program many times, preserving its meaning but encoding features in terms of other, simpler, features.

We iterated until we reached a minimal, irreducible set of features: definition and application of anonymous functions of a single argument and a single return value; and variable references. The result was an unrecognizable program, albeit a very ◊emphasis{simple} one. Do these features represent the essence of programming languages?

Not quite. One evidence is that we had to choose our base programming language (Racket) based on certain criteria. For example, it had to a language in which functions were values. If our resulting program represented the essence of programming languages, then C—a language in which functions are not values—would not qualify as a programming language. And it does.

◊margin-note{Explaining the inner workings of Turing Machines, SKI combinator calculus and tag systems is beyond the scope of this article. The only aspect relevant to this discussion is that each of these system constitutes minimal, irreducible sets of features for programming languages.}

◊margin-note{A counterintuitive and interesting observation is that minimal, irreducible sets of features suitable for programming languages are remarkably common in systems with very simple rules. They occur frequently in nature, even in systems not commonly associated with computation. We reason about the Lambda calculus, Turing Machines and similar systems because they have features which make them convenient to analyze, not because their computational power is particularly special or rare.}

Moreover, had we taken a different turn on the road, we would have reached a different set of essential features. For example, we could have arrived at a machine with an infinite tape of cells, a moving head that reads and writes to the tape and a set of rules to follow for reading, writing and moving through the tape. This machine is known as Turing Machine. Or we could have arrived at something more esoteric, like the SKI combinator calculus or a tag system.

◊margin-note{The process of encoding anonymous inner functions in terms of regular C functions is called ◊technical-term{closure conversion}. It is a technique commonly used in compilers for functional programming languages.}

As a consequence, if we had decided for a different approach, we could have encoded the features from our final program in terms of other features. For example, we could have encoded anonymous inner functions in terms of regular C functions, which cannot be nested and must have names.

So we are still one step away from the essence. The essence must be what all these different minimal sets of features have in common. Thus, the essence of programming languages must be the essence of computation itself. Because the ability to perform arbitrary computations is the only similarity between the systems mentioned above.

This brings us to the most important result of this article: What is the essence of programming languages? What is the essence of computing? What is the common aspect of the different systems capable of performing computations? ◊emphasis{Communication}.

The essence of programming languages is that they allow for arbitrary ◊emphasis{communication} of data across the program. In our final program, communication is the only important feature that remained, and it manifested itself in terms of function application. We ◊informal{encoded away} the numbers, booleans and more, and the only values left were functions.

Functions served two purposes in our program. First, functions served as ◊emphasis{data}. This is why we had to choose a base language in which functions were values. The second purpose for functions was to work as a mechanism to ◊emphasis{communicate} data. Data flowed from calling site to function body in the form of arguments, and flowed back from function body to calling site in the form of the returned value.

◊margin-note{◊emphasis{Everyday programming takeaway}: Code can be data. Data can be code.}

◊margin-note{The observation that all these different minimal sets of features are equivalent in computational power is an important result of computer science theory. It is called Church–Turing thesis.}

The minimal set of features at which we arrived after our rewrites is particularly elegant because of this dual nature of functions. It is simple to describe—if difficult to understand—because it is compact. And the compactness stems from the property that functions are simultaneously data and a means to ◊emphasis{communicate} data.

◊margin-note{Another conclusion from our journey is that, apart from matters of convenience and taste, all general-purpose programming languages are equivalent in computational power. In other words, any existing program could be translated to any existing language. It might not be practical to pursue this task for some programs, but it is at least theoretically possible.}

But, in one way or another, with more or less elegance, all the minimal sets of features at which we could have arrived—for example, Turing Machines and the SKI combinator calculus—have the same essential capacity of enabling arbitrary ◊emphasis{communication} of data across the system.

◊new-thought[]

◊emphasis{Communication is the essence of programming languages and of computation.}

◊section['conclusion]{Conclusion}

Our journey to the essence of programming languages is complete. We started with a regular program and transformed it several times to make it simpler, until we could finally observe that ◊emphasis{communication} is the essence of programming languages. This is an important result by itself, but it is far from being the only interesting takeaway from this article. The encodings are based on techniques that are generally applicable in real-world programs.

◊margin-note{In general, a programmer’s job is to identify abstractions and encode them in terms of existing programming languages features.}

The first and most important lesson regarding encodings is that whenever a language does not have a feature, we can encode it using the existing features. Depending on the case, it may not be convenient or practical, but theoretically it is always an option. Ultimately, any task in programming can be framed as encoding constructs that do not exist in the base language—or in any language. These constructs may be the ones that we ◊informal{encoded away} in this article, or they may be constructs related to tracking bicycle trips, for example.

When encoding numbers, we chose to use functions. With this choice, we encoded numbers not by what ◊emphasis{they are}, but by what ◊emphasis{they do}. The primary utility of numbers is to count, so our encoding for them was to repeatedly apply a function, which effectively is performing a count. This shows that data (what numbers ◊emphasis{are}) and computation (what they do ◊emphasis{do}, in our encoding) are two sides of the same coin. Our final conclusion about the dual nature of functions manifested from the start.

The most complicated operation to implement in our encoded numbers was ◊code{sub1}. We did it using a ◊technical-term{sliding window} over the number line. This technique is applicable to all sorts of search in series in which each element depends on the previous ones. For example, calculating the Fibonacci numbers, in which each element is the sum of the previous two.

For the encoding of booleans, we again used an encoding in terms of what ◊emphasis{they do}, instead of what ◊emphasis{they are}. The purpose of booleans in to choose between two options—◊technical-term{true} and ◊technical-term{false}—so our encoding for them were functions that received two arguments and chose one of them.

While encoding conditionals (◊code{if}), we had a problem due to the order in which Racket evaluates programs. Function arguments are evaluated to values before the function starts to execute. In the case of our program, this led to infinite recursion and a non-terminating program. The solution was to ◊informal{wrap} the computations in functions to ◊informal{delay} them. This technique is useful in situations when a computation does not need to happen immediately. For example, calls to a logger might include an expensive computation that should only occur in ◊technical-term{debug} mode. In this case, the call might be ◊informal{delayed} by ◊informal{wrapping} it in a function, which the logger only calls if its log-level is ◊technical-term{debug}.

◊margin-note{This capability to ◊informal{remember} that functions have is related to ◊technical-term{lexical scoping}. Languages with ◊technical-term{dynamic scoping} (for example, Emacs Lisp) behave differently and the result would not be the same in them.}

The encoding of pairs used an important capability of functions: they ◊informal{remember} the values they had in scope when defined. A fundamental part of this encoding were the inner functions that ◊informal{remembered} the arguments of the outer functions even after the outer functions had returned.

Another interesting technique we introduced in the encoding for pairs is that, when a function does not have enough information to act, it can delegate to a helper function, which it receives as an argument. In the particular case of pairs, the ◊code{retriever} did not know which element of the pair (◊code{left} or ◊code{right}) to retrieve. So it received a ◊code{selector} function as an argument, transferring the responsibility of deciding which element to retrieve to the calling site. The calling site knows which element of the pair it needs, and that is why this technique works.

The final lesson from the encoding of pairs is that any data structure is, in its essence, just a construct to couple data together. There is a wide variety of data structures to solve particular issues, for example, optimizing access time for certain elements. But their fundamental purpose is still simple: couple data together. Moreover, it is possible to construct sophisticated data structures from simpler ones—for example, construct lists out of pairs. To solve a complex problem, in many cases it is better to build more sophisticated data structures in which the problem can be phrased more naturally than to try to solve the problem directly. This was precisely the approach we took when introducing pairs in ◊code{sub1}.

The encoding for recursion was another instance of the technique “if a function does not have enough information to act, it should receive another function that does as an argument.” In this case, the function that needs more information and the function that has the information happen to be the same. Even the ◊technical-term{tying the knot} technique is an example of this. It relies on mutation of the program state (◊code{set!}), and mutation can be interpreted as an extra argument to every function, carrying the global program state. When using the ◊technical-term{tying the knot} technique, the global program state includes the ◊informal{function that has the necessary information to act}.

◊margin-note{Functional programming languages are increasingly popular, and some of their features appear in traditionally non-functional languages—for example, Java 8 includes closures. This contributes to blur the line between paradigms, rendering obsolete distinctions such as ◊technical-term{object-oriented} and ◊technical-term{functional}.}

When encoding functions with multiple arguments, we took to an extreme the ◊informal{memory} features of inner function definitions, which we had already explored in the encoding for pairs. We created cascades of functions that received a single argument and returned an intermediary function. In everyday programming, the ability to create inner functions is one of the most useful, and is a significant reason for the recent popularity of functional programming languages.

◊margin-note{◊emphasis{Communication} is so important that it was the primary motivation for writing this article: to ◊emphasis{communicate} the important ideas of computer science to practitioners.}

◊margin-note{◊emphasis{Everyday programming takeaway}: When writing programs, consider the two audiences that will read them: other programmers first, machines second.}

The final practical lesson for working programmers in this article comes from the encoding of named definitions. After the transformation, the program becomes unintelligible. This highlights the importance of giving good names to concepts in programming. Working programmers are not only writing programs that run correctly—computers interpret our unintelligible final version of the program without problems—but, more importantly, they are ◊emphasis{communicating} ideas to other people. Programmers ideally write code that others can understand and improve in the future.

Again, coming from a different direction, we acknowledge the importance of ◊emphasis{communication}. We have now come full circle:

◊new-thought[]

◊emphasis{The essence of programming languages is communication.}

◊section['references]{References}

The main inspiration for this article were the talks by Jim Weirich on the Y-combinator: the Ruby version, in ◊reference["https://www.youtube.com/watch?v=FITJMJjASUs"]{Ruby Conf 12, ◊citation{Y Not- Adventures in Functional Programming}}; and the JavaScript version, in ◊reference["https://vimeo.com/45140590"]{ScotlandJS 2012, ◊citation{Adventures in Functional Programming}}. Also, Tom Stuart’s talk and article ◊reference["https://codon.com/programming-with-nothing"]{Programming with Nothing}; and his book ◊reference["http://computationbook.com/"]{Understanding Computation} were major influences. Together, Weirich and Stuart not only inspired this article, but motivated me to pursue a Ph.D. in programming-language theory.

Another talk that was hugely influential to me is ◊reference["https://www.youtube.com/watch?v=_ahvzDzKdB0"]{◊citation{Growing a Language}}, by Guy Steele in OOPSLA 1998. His presentation skills are remarkable.

But none of these sources touch on the essence of programming languages that we uncovered in this article: ◊emphasis{communication}. For more on the relation between communication and computation, refer to ◊reference["https://wolframscience.com/"]{A New Kind of Science}, by Stephen Wolfram.

Finally, people interested in the academic side of programming-language theory can read the book ◊reference["https://pl.cs.jhu.edu/pl/book/dist/"]{Principles of Programming Languages}, by Dr. Scott F. Smith, my advisor. It includes an introduction to the notation and jargon used in research and is essential to reach the level of understanding necessary to read conference and journal articles.

◊section['acknowledgments]{Acknowledgments}

Thank you David Storrs for the comments on this article.

◊appendix['full-listing]{Full Listing}

◊full-width{◊code/block[#:language 'racket]{◊(file->string "programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages.rkt")}}
