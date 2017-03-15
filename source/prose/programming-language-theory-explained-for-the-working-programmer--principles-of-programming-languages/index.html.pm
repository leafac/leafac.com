#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}
◊define-meta[date]{2017-03-13}

◊margin-note{This article assumes prior knowledge in programming. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required.}

◊margin-note{◊link["https://git.leafac.com/www.leafac.com/plain/source/prose/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages/programming-language-theory-explained-for-the-working-programmer--principles-of-programming-languages.rkt"]{Here} is the code for this entire article.}

◊new-thought{Programming languages come} in many sizes and flavors. Working programmers have been exposed to a few of them and might question: What is the essence of programming languages? In this article, we are going to explore this question, but, unlike most presentations on the topic, we are going to avoid mathematical notation and jargon. We are going to start with a small program and remove one abstraction at a time, until we reach the core of what make programming languages tick. The whole discussion is driven by executable code, making it approachable to all programmers.

◊section['starting-point]{Starting Point}

◊new-thought{Consider} the following program:

◊margin-note{The same program is given in three popular programming languages to help users of these languages get started. From now on, we are going to proceed in Racket, but there is nothing special about this choice. Any language in which functions are values would work. This includes Ruby, Python, JavaScript, Java since version 8, and many more. This does not include C, for example, in which pointers to functions are values, but functions themselves are not.}

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

◊margin-note{◊svg["convenience-vs-simplicity.svg"]}

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
(define (pretty-print/number number)
  (number add1 0))
}

The function ◊code/inline{pretty-print/number} is not going to be part of our main program, it only exists as a helper. That is why it is allowed to contain regular numbers—namely, ◊code/inline{0}. It receives as argument a number encoded in terms of functions and transforms it back into a regular number, so that we can read it:

◊code/block/highlighted['racket]{
> (pretty-print/number zero)
0
> (pretty-print/number one)
1
> (pretty-print/number five)
5
}

The way ◊code/inline{pretty-print/number} works reveals how this encoding of numbers using function works. Numbers are functions, so ◊code/inline{pretty-print/number} ◊emphasis{applies that function}. As arguments, numbers receive another function and an initial value. Then the number repeatedly applies that given function to the initial value; the amount of applications corresponds to the number we want to encode.

The function ◊code/inline{pretty-print/number} makes a careful choice of arguments with which it calls the number. The initial value is ◊code/inline{0}, and the function to be repeatedly applied is ◊code/inline{add1}. So, ◊code/inline{(pretty-print/number five)} turns into the following:

◊code/block/highlighted['racket]{
(add1
 (add1
  (add1
   (add1
    (add1 0))))) ;; => 5
}

◊paragraph-separation[]

◊new-thought{Now that we have} an encoding for numbers, we need to define the necessary operations on those encoded numbers. For our original program (◊code/inline{sum-up-to}) we need three operations: ◊code/inline{zero?}, ◊code/inline{sub1} and ◊code/inline{+}.

◊margin-note{In Racket, ◊technical-term{true} is spelled ◊code/inline{#t} and ◊technical-term{false} is spelled ◊code/inline{#f}.}

To implement ◊code/inline{zero?}, we can use an idea similar to ◊code/inline{pretty-print/number}: call the number—which is a function—with carefully chosen arguments. For the initial value, we choose ◊code/inline{#t}, and for the function we choose one that always returns ◊code/inline{#f}:

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
> (pretty-print/number (+ five five))
10
}