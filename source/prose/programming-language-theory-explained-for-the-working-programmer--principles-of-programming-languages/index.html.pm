#lang pollen

◊define-meta[title]{Programming-Language Theory Explained for the Working Programmer: Principles of Programming Languages}
◊define-meta[date]{2017-03-13}

◊margin-note{This article assumes prior knowledge in programming. Experience with functional programming languages in general and ◊link["https://racket-lang.org/"]{Racket} in particular are helpful, but not required.}

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

◊; TODO: Start with Booleans, instead.

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

Some encodings are more convenient than others. For example, implementing addition with the first string encoding is hard. It amounts to recreating the addition algorithm that we learn in elementary school, with addition tables, carries and so on. But in the list-length encoding, addition is just appending lists.