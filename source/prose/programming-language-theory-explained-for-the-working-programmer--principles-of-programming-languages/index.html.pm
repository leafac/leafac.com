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

This program defines a function that sums integers from zero up to a given number, then calls this function with ◊code/inline{5}, outputting ◊code/inline{15}. What features are essential in programming languages that allow this program to be written? To address this question, we first have to consider what ◊emphasis{is} an essential feature.

Suppose one has to write an application that plays music. If one could find a programming language that comes with features for notes, melodies, harmony and rhythm, that work would be a lot simpler. But most programming languages do not have these features, and still it is possible to write applications that play music in them. One does that by ◊emphasis{encoding} the desired features. For example, notes could become numbers—1 for C, 2 for D, and so on—and chords could become tuples of notes.

◊margin-note{Encoding abstractions in simpler terms is job of most compilers, which start with a language with more abstract features and output machine code. What we are targeting in this discussion is the essence of programming languages, so, in some ways, it is even more bare-bones than machine code.}

◊margin-note{◊(string->xexpr (file->string "convenience-vs-simplicity.svg"))}

So the capacity to play music is not an essential feature of a programming language, that is why most languages does not have it. Not having a feature makes the language simpler, having it makes it more convenient. The interesting observation is that most features included in most programming languages are also non-essential, but exist solely for convenience and can be encoded in terms of other, simpler, features. We are going to explore this simplicity–convenience spectrum, moving one feature at a time in the direction of simplicity.