#lang pollen

◊define-meta[title]{Git by Analogy}
◊define-meta[date]{2017-07-06}

◊margin-note{To follow the command-line snippets, this article assumes familiarity with basic command line skills: moving around, creating directories and so forth. But following the command-line snippets is optional, one can use a ◊acronym{GUI} instead.}

◊new-thought{What does} ◊link["https://git-scm.com/"]{Git} do? How to start with Git? Where to learn more about Git? This article addresses these three questions; after reading it, the reader will not be an specialist in the tool, and will not have memorized commands, but will know the basic underlying concepts and how to perform the most commonly used operations. The space of educational material about Git is enormous, this article distinguishes itself for being directed by analogies which make the ideas relatable, and for exploring some of the ◊emphasis{whys}, going beyond the ◊emphasis{hows}.

◊section['what-does-git-do]{What does Git do?}

◊margin-note{Some tools have simple, embedded version control systems, for example, Google Docs allows traversing the history and comparing different versions of a file. Git is a more sophisticated version of this, with more features and spanning a whole project, instead of a single file.}

◊new-thought{Git solves} the problem of ◊technical-term{version control}. The name might sound unfamiliar, but the problem is not: keeping track of the changes in a project as it evolves, and collaborating on it with other people. The version control problem occurs whenever someone copies a file to modify it and compare the versions, sends a project as email attachment, or loses work due to a corrupted or accidentally deleted file. Git is a ◊technical-term{version control system}, which solves the version control problem by tracking the project’s history.

◊; TODO: ◊margin-note{I use Git with almost everything I do on the computer: from keeping my favorite vegan recipes to the preparation of this lecture. The person below does not. «Image of filesystem with repeated files and poop.»}

Most companies use some version control system, among which Git is the most popular. Also, most free-software projects use version control systems and accept contributions through them. So knowing Git is a highly marketable skill. Moreover, version control can improve overall quality of digital life: version diary entries, recipes, lecture notes, and any other personal project. No work will be lost for technical issues, and there will be a rich history of the progress over time to compare, explore and experiment with different versions of the project.

◊; TODO: ◊section['how-to-start-with-git]{How to start with Git?}

◊; TODO: ◊section['where-to-learn-more-about-git]{Where to Learn More About Git?}