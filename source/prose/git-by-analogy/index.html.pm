#lang pollen

◊define-meta[title]{Git by Analogy}
◊define-meta[date]{2017-07-06}

◊margin-note{To follow the command-line snippets, this article assumes familiarity with basic command line skills: moving around, creating directories and so forth. But following the command-line snippets is optional, one can use a ◊acronym{GUI} instead.}

◊new-thought{What does} ◊link["https://git-scm.com/"]{Git} do? How to start with Git? Where to learn more about Git? This article addresses these three questions; after reading it, the reader will not be an specialist in the tool, and will not have memorized commands, but will know the basic underlying concepts and how to perform the most commonly used operations. The space of educational material about Git is enormous, this article distinguishes itself for being directed by analogies which make the ideas relatable, and for exploring some of the ◊emphasis{whys}, going beyond the ◊emphasis{hows}.

◊section['what-does-git-do]{What does Git do?}

◊margin-note{Some tools have simple, embedded version control systems, for example, Google Docs allows traversing the history and comparing different versions of a file. Git is a more sophisticated version of this, with more features and spanning a whole project, instead of a single file.}

◊new-thought{Git solves} the problem of ◊technical-term{version control}. The name might sound unfamiliar, but the problem is not: keeping track of the changes in a project as it evolves, and collaborating on it with other people. The version control problem occurs whenever someone copies a file to modify it and compare the versions, sends a project as email attachment, or loses work due to a corrupted or accidentally deleted file. Git is a ◊technical-term{version control system}, which solves the version control problem by tracking the project’s history.

◊margin-note{
 The author uses Git in almost everything he does on the computer: from keeping ◊link/internal["/cooking"]{vegan recipes} to the preparation of this article. The person below does not.

 ◊; TODO: «Image of filesystem with copied files and poop.»
}

Most companies use some version control system, among which Git is the most popular. Also, most free-software projects use version control systems and accept contributions through them. So knowing Git is a highly marketable skill. Moreover, version control can improve overall quality of digital life: version diary entries, recipes, lecture notes, and any other personal project. No work will be lost for technical issues, and there will be a rich history of the progress over time to compare, explore and experiment with different versions of the project.

◊section['how-to-start-with-git]{How to start with Git?}

◊margin-note{This article does not cover technical issues that are system-dependent and change often, for example, how to install Git and ◊acronym{GUI} front-ends. Refer to the ◊link["https://www.git-scm.com/"]{tool’s website} for more on these topics.}

◊new-thought{There are two} main ways to learn Git: through the Command-Line Interface (◊acronym{CLI}) and through the Graphical User Interface (◊acronym{GUI}). The ◊acronym{GUI} serves as a front-end for the tool, it is more friendly and, for some advanced operations, it is more convenient. In day-to-day use of Git, a ◊acronym{GUI} is usually a better choice. But the ◊acronym{GUI} may not support all operations available in Git, or may have issues with big repositories. In some cases, a graphical environment is not available at all, for example, when accessing a remote server machine. Also, the ◊acronym{GUI} makes it harder to automate some tasks and generally does not interact well with scripts. So there are reasons to learn both the ◊acronym{CLI} and the ◊acronym{GUI}, as they offer different advantages and disadvantages.

◊margin-note{There are stand-alone Git ◊acronym{GUI}s and there are Git ◊acronym{GUI}s inside text editors. The latter are preferred, particularly for the most frequent tasks.}

In this tutorial, we show how to perform operations both with the ◊acronym{CLI} and with the ◊acronym{GUI}. While there is only one ◊acronym{CLI}, there are many choices of ◊link["https://www.git-scm.com/downloads/guis"]{◊acronym{GUI}}. The purpose of this article is communicate basic principles, which are skills that transfer to different scenarios, so we use the ◊acronym{GUI} that comes with Git. It is not the most good-looking ◊acronym{GUI}, but it is fully functional, cross-platform and requires no extra setup.

For the rest of this article, we cover the most common use cases for Git, organized by three overarching goals: (1) using Git alone on a local computer; (2) using Git with remote computers; and (3) using Git with collaborators.

◊section['an-aside-about-github]{An Aside About GitHub}

◊margin-note{
 ◊; TODO: «Git ≠ GitHub ⇔ Email ≠ Gmail»

 GitHub is to Git as Gmail is to email. They are popular commercial tools which make the underlying technology easier to use and provide convenient extensions, but are not essential. One can use Git without GitHub the same way one can send emails from providers other than Gmail.
}

◊new-thought{It is a common} misconception among beginners that Git and ◊link["https://github.com"]{GitHub} are synonyms, or that Git is short for GitHub. They are not the same: Git is the tool, which is free software; and GitHub is a company and a commercial product built around Git which provides hosting and extended functionality. ◊reference['TODO]{In a later section}, when we discuss using Git with remote computers, we will use GitHub for the example because it is the most popular choice, but the distinction should be clear.

◊; TODO: ◊section['where-to-learn-more-about-git]{Where to Learn More About Git?}