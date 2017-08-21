#lang pollen

◊define-meta[title]{Git by Analogy}
◊define-meta[date]{2017-08-21}

◊margin-note{◊figure{◊svg{images/alice.svg}}}

◊new-thought{Meet Alice}. Alice spends a lot of her free time in the kitchen, her specialty are vegan baked goods. The alchemy of flour and water turning into dough, its soft touch when shaping a loaf, the sweet smell of cookies in the oven, she loves it all. And her friends like it as well, because they often receive tasty gifts. Alice began to learn by following recipes she found on the Internet, but, as she gained experience, she started adapting them. Her friends say that her versions are better than the originals, and often ask her for recipes. But the development require a ton of experiments, and Alice is constantly tweaking the proportion of flour and water, finding better ways to replace eggs in vegan pastries, and so forth. Some of her friends even contribute back with tips they find when trying the recipes on their own. To keep everybody updated with the latest and greatest, Alice started writing her own vegan cookbook!

When she started baking, Alice used to be old-fashioned and write her recipes by hand. She was not fond of the idea of getting flour all over her computer. And she kept it simple: if she wanted to tweak the amount of sugar, for example, she would erase the old quantity and write in the new one. But the kitchen is about experimenting, and sometimes she discovered the change did not work well, the cookies came out too sweet. She wanted to revert to the old amount but, unfortunately, because had used an eraser, she depended on her memory. With so many recipes in her mind, that did not work because she had already forgotten the old version. Alice heard that many people using computers had the same issue when they modify files.

Soon Alice thought of a solution: she bought a copying machine and kept copies of her recipes before altering them. This way she had a history of her recipes over time, and could always recover previous revisions. But it did not take long before the sheer amount of slightly modified versions of the same recipe overwhelmed her. She would often find herself asking questions like “is this the version that was too sweet?” or “what did my friend Bob modify in this version that he sent me?” Alice heard that many people using computers had the same issues. They would keep many copies of slightly different versions of the same files, send them as email attachments to their friends, and then get lost trying to manage process. They had problems figuring what changed between versions, who contributed what, and some changes even get lost in this tedious and error-prone manual work.

The copying-machine approach was not working, so Alice developed a better system. It involves slips of paper, paper trays, boxes, cabinets and more. This new system has been working for a while, and, now that Alice is writing her cookbook, she decided it is time for her to use the same workflow in the computer. She learned that the process she developed is called a ◊technical-term{version control system}, and that ◊link["https://git-scm.com/"]{Git} is a computerized version of what she was doing on paper. Even better, Git automates many tasks that she had to do by hand. This article describes Alice’s workflow on paper and her transition to use Git.

----

◊margin-note{Sections about the ◊git/gui/inline{◊acronym{GUI} are outlined in violet}, and sections about the ◊git/cli/inline{◊acronym{CLI} are outlined in yellow}. The latter are optional and assume familiarity with the command line: navigating the filesystem, creating files and directories, and so forth.}

◊new-thought{What does} ◊link["https://git-scm.com/"]{Git} do? How to start with Git? Where to learn more about Git? There are ◊reference['where-to-learn-more-about-git]{innumerous articles, videos, courses, books and so forth} addressing these questions, but they tend to either be short introductions or in-depth explorations. A beginner does not learn enough to be effective in the former, and is overwhelmed by information in the latter. This article is the middle ground: it answers the questions that opened this paragraph, but does not try to be comprehensive. We only cover the most common operations and workflows, but we cover them in detail, going beyond a ◊emphasis{how-to} tutorial. The presentation is directed by analogies which make the core concepts more relatable and friendly, and the practical sections cover both a Graphical User Interface (◊acronym{GUI}) front-end and the Command-Line Interface (◊acronym{CLI}).

◊section['what-does-git-do]{What does Git do?}

◊margin-note{
 The author uses Git in almost everything he does on the computer: from keeping ◊link/internal["/cooking"]{vegan recipes} to the preparation of this article. The person below does not:

 ◊figure{◊svg{images/filesystem-without-version-control.svg}}
}

◊new-thought{Git solves} the problem of ◊technical-term{version control}. The name might sound unfamiliar, but the problem is not: tracking the evolution of a project, and collaborating with other people. Most people already use rudimentary version control systems, maintaining multiple slightly modified versions of the same files, and sending files to collaborators as email attachments. But this method has limitations, for example, it can be difficult to identify the differences between two versions and to associate the changes to their authors. In general, this is error-prone and involves a great deal of tedious work.

◊margin-note{Some tools include simple version control systems for their files that are not as rudimentary as the manual method described above and not as complete as Git. For example, ◊link["https://docs.google.com"]{Google Docs} tracks documents revisions. Git is a more sophisticated version of this, with more features and support for whole projects, instead of single documents.}

Git is a ◊technical-term{version control system}, which streamlines these processes. It tracks the history of a project, associating each line to its author, creation date, and so forth. Users can investigate and navigate on this history, retrieve changes arbitrarily in time, compare different versions and more. Finally, they can distribute all this information to collaborators and manage their contributions. Git is agnostic about the tools used to work on the project (for example, text editors) and is suitable for most kinds of projects and teams.

Because of this widespread applicability Git is increasingly popular, ◊link["https://rhodecode.com/insights/version-control-systems-2016"]{ranking first among version control systems by a large margin}. ◊emphasis{Git is a highly marketable skill}. Companies and free-software teams alike use Git in projects of all sizes, primarily for software development, but also for everything from making ◊link["https://www.wired.com/2012/08/bundestag/"]{laws} to ◊link["/cooking"]{cookbooks}.

◊section['how-to-start-with-git]{How to start with Git?}

◊new-thought{First}, ◊link["https://www.git-scm.com/"]{install Git}. It comes with a Graphical User Interface (◊acronym{GUI}) and a Command-Line Interface (◊acronym{CLI}). The ◊acronym{CLI} is more complete, it supports all Git operations and is more widely available, even in remote machines with only terminal access, for example. But it is less ergonomic and more difficult to learn. This article describes ◊git/cli/inline{how to use the ◊acronym{CLI} in sections outlined in yellow}, but they are optional and targeted at readers already familiar with the command line.

◊margin-note{The author uses the Git client in ◊link["https://atom.io/"]{Atom} and the ◊acronym{GUI} that comes with Git, rarely using the ◊acronym{CLI}.}

The ◊acronym{GUI}, on the other hand, is more ergonomic and easier to learn, but it does not support a few of the most advanced operations. Also, it might not be available in remote machines, for example, servers which do not have a graphical environment. This article ◊git/gui/inline{describes how to use the ◊acronym{GUI} in sections outlined in violet}. The ◊acronym{GUI} that comes with Git is functional, but it arguably is not aesthetically pleasing and does not offer the best user experience. We choose it for this article because it is the common denominator, available for all platforms and requiring no extra setup. But there is an assortment of ◊link["https://git-scm.com/downloads/guis"]{other ◊acronym{GUI}s}—also called ◊technical-term{clients}—investigate them after reading this article. In particular, try the Git clients available in development environments (text editors, ◊acronym{IDE}s and so forth), they might be the most familiar and better integrated with the rest of the workflow. More than showing which buttons to click, this article covers the underlying concepts, which should transport naturally to other Git clients.

For most of the rest of this article, we cover the common use cases for Git, organized by three overarching goals: (1) ◊reference['local-setup]{using Git alone on a local computer}; (2) ◊reference['remote-repositories]{using Git with remote computers}; and (3) ◊reference['workflow]{using Git for collaboration}:

◊full-width{
 ◊figure{◊svg{images/goals.svg}}
}

◊section['an-aside-about-github]{An Aside About GitHub}

◊margin-note{
 ◊figure{◊svg{images/git-vs-github.svg}}

 GitHub is to Git as ◊link["https://gmail.com"]{Gmail} is to email. GitHub and Gmail are popular commercial tools which make the corresponding underlying technologies more ergonomic and provide convenient extensions. But they are not the same as the underlying technologies: one can use Git without GitHub the same way one can send emails from providers other than Gmail.
}

◊new-thought{It is a common} misconception among beginners that Git and ◊link["https://github.com"]{GitHub} are synonyms, or that Git is short for GitHub. But they are not the same: Git is the tool; and GitHub is both a company and a product built around Git which provides hosting and extended functionality. When we discuss using Git with remote computers ◊reference['remote-repositories]{on a later section}, we use GitHub for the example because it is the prevalent hosting provider, and the distinction between Git and GitHub is important.

◊git/gui{
  ◊section['gui-structure]{◊acronym{GUI} Structure}

  ◊new-thought{The ◊acronym{GUI} we use} in this article comes bundled in the Git installation. Unfortunately, the installation process generally does not create launchers for the ◊acronym{GUI}, so even readers interested only in the ◊acronym{GUI} sections must launch it from the ◊acronym{CLI}. ◊emphasis{This is the only obligatory interaction with the command line}.

  The ◊acronym{GUI} comes in two parts. The main one is launched with the following command:

  ◊margin-note{The ◊code/inline{$} represents the prompt and should not be typed.}

  ◊code/block{
$ git ◊git/verb{gui}
  }

  The result from running the command above should be the following welcome screen:

  ◊image["images/welcome-screen.png"]{Welcome screen.}

  This is the main application to which we refer in most of the article. The second part of the ◊acronym{GUI} is specifically for visualizing the project history. It can be launched from the main window or directly with the following command:

  ◊code/block{
$ gitk
  }

  At the moment this terminates with an error, because there is no project, so there is no history to show yet:

  ◊image["images/cannot-find-git-repository.png"]{Error trying to visualize inexistent project history.}
}

◊git/cli{
  ◊section['cli-structure]{◊acronym{CLI} Structure}

  ◊new-thought{There is only one} Git executable: ◊code/inline{git}. It expects arguments that resemble natural language, for example:

  ◊figure{◊svg{images/grammar.svg}}

  In general, Git commands follow the pattern:

  ◊margin-note{By convention, command lines are prefixed with ◊code/inline{$} and comments with ◊code/inline{#}. Git ◊git/verb{verbs} and ◊git/object{objects-and-options} are color-coded.}

  ◊code/block{
$ git ◊git/verb{verb} ◊git/object{objects-and-options ...}
  }
}

◊section['local-setup]{Local Setup}

◊margin-note{Git configurations live in plain-text file at ◊path{~/.gitconfig}.}

◊margin-note{If one does not plan to use ◊reference['workflow]{Git for collaboration}, then always associating changes to the same author is an arguably useless feature. But it is not possible to turn it off, so the instructions in this section are mandatory.}

◊new-thought{Git associates ◊reference['changes]{changes}} in the project to their authors. For this to work, it is necessary to identify to Git, providing a name and an email address. ◊emphasis{Choose a permanent email address}. Institutional emails, for example, are bad choices because they might be reassigned to another person after the affiliation ends. Git would have trouble distinguishing contributions to the same project made by multiple people that shared an email address over time.

◊margin-note{Readers following both the ◊git/gui/inline{◊acronym{GUI}} and the ◊git/cli/inline{◊acronym{CLI}} sections must choose only one of these instructions, to configure the system only once.}

◊git/gui{
  One of the quirks of the ◊acronym{GUI} bundled with Git is that configurations are only accessible when there is a repository (which is a concept we cover in a ◊reference['repository]{later section}). For the moment, create a ◊informal{dummy} directory in the file system, and ◊menu-option{Create New Repository} there:

  ◊figure{◊svg{images/creating-dummy-repository.svg}}

  Then, go to ◊menu-option{Preferences} and fill ◊menu-option/path["Global (All Repositories)" "User Name"] and ◊menu-option{Email Address}:

  ◊full-width{◊figure{◊svg{images/setup.svg}}}
}

◊git/cli{
  Run the following commands:

  ◊code/block{
$ git ◊git/verb{config} ◊git/object{--global user.name "<name>"}
$ git ◊git/verb{config} ◊git/object{--global user.email "<email>"}
  }
}

◊paragraph-separation[]

◊new-thought{There are files} which would never belong to any kind of project. These files are generated by the operating system, text editors and so forth; they are related to the tools used to work on projects, not to the projects themselves. For example, macOS creates ◊path{.DS_Store} files in each directory visited with Finder to store custom folder attributes. It is best not to track these files with Git, because they would pollute the history and could cause problems for collaborators in different environments.

We configure Git to ignore these files by creating a file with one line for each path Git must ignore:

◊margin-note{The language to specify ignored files is sophisticated, see ◊link["https://git-scm.com/docs/gitignore"]{the manual for ◊code/inline{gitignore(5)}}.}

◊file-listing["~/.config/git/ignore"]{
.DS_Store
*.extension-of-temporary-file-created-by-text-editor
# ...
}

Git is ready to use.

◊git/cli{
  ◊section['the-most-important-command]{The Most Important Command}

  ◊new-thought{The most important} command in Git asks for the current status:

  ◊full-width{
    ◊code/block{
$ git ◊git/verb{status} 
fatal: Not a git repository (or any of the parent directories): .git
    }
  }

  We use this command frequently to check our progress. Currently, the result is a fatal error: Git cannot find a repository.

  The following sections explain what is a repository, and how to create one.
}

◊section['office]{Office}

◊margin-note{◊figure{◊svg{images/office.svg}}}

◊new-thought{Modern operating system ◊acronym{GUI}s} make an analogy to an office environment. There is a desktop with some files organized in folders, and tools to work on them: text editors are analogous to pens and pencils, for example. Let us then consider an office environment in which it is necessary to track the progress over time. One could use, for example, a copying machine and keep copies of the different revisions. Soon, this results in the situation mentioned ◊reference['what-does-git-do]{when introducing version control}: there are many different versions of any given file and it is difficult to tell which is the current, to inspect the differences, to associate the changes to authors, and so forth. These processes take a long time, are prone to error, and require tedious manual work. Unsurprisingly, these are the exact same issues that arise in the computer when creating copies of different project revisions.

To address this problem in an office, we could try a new system. To avoid confusion, we start by keeping only one copy of the project. After making a change, we take note of it in a slip of paper, mentioning what was the old content and what is the new content. If we are careful about managing these slips of paper, then we can recreate any point in time by following them in the appropriate direction: to go backward in time we replace the new content with the old content, and to go forward in time we replace the old content with the new content.

But how can we manage these slips of paper carefully? We start by writing them in our desktop, and moving them to a paper tray to organize them. Eventually, we make significant progress in the project. The size of what constitutes “significant progress” varies: it might be a single change to a single line, or it might involve dozens of files. Regardless, the slips of paper in the paper tray tell a cohesive story, for example, “fix the bug in thrust calculation,” or “add a button to escape battle.”

At this point, we move the contents of the paper tray into a box. We close the box and label it with some information: author, current date and time, a description of the story the box tells, and an unique identifier. We finally move the box into a cabinet for storage. Then we iterate: change the unique copy of the project; note the changes in slips of paper; organize them in a paper tray; when they tell a cohesive story, move them to a box; label the box; and move it to the cabinet.

As we stack boxes in the cabinet, they form a chain, from the newest on the top to the oldest on the bottom. This chain represents a timeline for the project. We can look at the boxes and recollect who changed what, when and why. We can even navigate in time by systematically opening the boxes in order and applying the changes they contain to the unique copy of the project.

But maintaining this system is a great deal of tedious work! We want a robot to manage these processes: storing boxes in the cabinet, finding them, systematically applying the changes to the project to navigate in time, and so forth. In an office, this robot would be expensive. In the computer, it is free: we call it Git.

Git extends the office analogy of files and folders in a desktop from the operating system ◊acronym{GUI}. This extended office includes metaphorical slips of paper, paper tray, labeled boxes, cabinet, and more. The following sections cover each of these components, their technical names in Git lexicon and how to give orders to the robot. We start with the part that is already familiar: the files and folders.

◊section['working-directory]{Working Directory}

◊margin-note{◊figure{◊svg{images/working-directory.svg}}}

◊new-thought{The first component} of the office analogy that we explore is the files and the folders, which come with the operating system. Git changes nothing about them, so that it does not interfere with other tools, for example, text editors. The only aspect particular to Git is terminology: Git calls the main project folder the ◊technical-term{working directory}.

For the rest of this article we use a simple project for the examples: the writing of a ◊link/internal["/cooking"]{vegan cookbook}. Create a working directory for the project. Readers following both the ◊git/gui/inline{◊acronym{GUI}} and the ◊git/cli/inline{◊acronym{CLI}} sections must create two independent working directories, and follow the instructions from the different sections in the respective working directories.

◊section['repository]{Repository}

◊margin-note{◊figure{◊svg{images/repository.svg}}}

◊new-thought{The first order} we give to our Git robot is to create the cabinet which will contain the project history. Git calls it the ◊technical-term{repository}.

◊git/gui{
  We had already created a repository ◊reference['local-setup]{during setup} to work around a quirk in the ◊acronym{GUI}. Repeat the process to ◊menu-option{Create New Repository} in the working directory:

  ◊figure{◊svg{images/create-repository.svg}}

  The screen above means the repository was successfully created. Each pane in this window corresponds to one part of our office metaphor, which we cover in the following sections:

  ◊figure{◊svg{images/gui-parts.svg}}

  Besides this main ◊acronym{GUI} window, there is another front-end window to show the project history. Open it with the ◊menu-option/path["Repository" "Visualise All Branch History"] menu option, or directly from the command line with ◊code/inline{gitk}. Currently there is no history to show, the cabinet is still empty, so this window shows an error:

  ◊image["images/no-history-yet.png"]{History visualization window with error due to empty repository.}

  The panes in this window also correspond to parts of our office metaphor:

  ◊figure{◊svg{images/gitk-parts.svg}}
}

◊git/cli{
  Run the following command:

  ◊full-width{
    ◊code/block{
$ git ◊git/verb{init}
Initialized empty Git repository in /Users/leafac/Downloads/git/recipes-cli/.git/
    }
  }

  The status has changed, Git no longer complaints about the lack of a repository:

  ◊full-width{
    ◊code/block{
$ git ◊git/verb{status} 
On branch master

  Initial commit  

nothing to commit (create/copy files and use "git add" to track)
    }
  }

  We still do not have enough information to understand this output. ◊technical-term{Branches}, ◊technical-term{commits} and ◊technical-term{tracking} files are subjects of the following sections.
}

Git created the cabinet in a folder called ◊path{.git/} under the project directory. This path starts with a dot (◊path{.}), which means it is ◊technical-term{hidden}: most file browsers will not show it by default. But, otherwise, there is nothing special about hidden files and folders, it is just a naming convention. The contents of the ◊path{.git/} directory are just files and folders which Git uses to represent the cabinet. Regardless, ◊emphasis{do not directly edit the contents of} ◊path{.git/}, instead, ask the robot to perform the operations.

◊paragraph-separation[]

◊margin-note{◊figure{◊svg{images/folders-vs-repositories.svg}}}

◊new-thought{What constitutes} a project, and, consequently, a repository? For example, consider a product composed of a front-end and a back-end. Are they separate projects, under two repositories? Or are they parts of the same project, under folders in the same repository? There is no definitive answer to these questions, because there are advantages and disadvantages to both approaches:

◊list/unordered{
  ◊list/unordered/item{
    Generally, it is monetarily inexpensive to create repositories. Most hosts, for example, GitHub, charge by the number of collaborators and the level of support, not by the number of repositories. But other tools, for example, continuous integration servers, might charge per repository.
  }
  ◊list/unordered/item{
    It is technically inexpensive to create repositories. Git has optimized data structures and avoids costly operations, for example, it avoids maintaining copies of files. If a single file makes sense on its own, there could be repository just for it.
  }
  ◊list/unordered/item{
    It is complicated to manage access control within a repository. A person that has access to the repository has access to all the files in it and their whole history. But it is easier to manage access control across different repositories.
  }
  ◊list/unordered/item{
    It is complicated to synchronize the changes across different repositories. But it is easier to synchronize the changes in different parts of a single repository.
  }
}

In general, the repository structure should reflect the organizational structure of the teams working on the product. If different people work in different parts, it might be better to have them as separate repositories. It is even possible to move from one approach to the other, as the organizational structure evolves. For example, ◊link["https://blog.racket-lang.org/2014/12/the-racket-package-system-and-planet.html"]{Racket} and ◊link["https://github.com/Homebrew/brew/pull/2"]{Homebrew} were single repositories containing the whole project in the past. Both projects transitioned to the other approach, separating components into collections of smaller repositories. But it was not easy, these were big undertakings which required the coordination of entire communities and took a long time to complete.

◊section['changes]{Changes}

◊margin-note{◊figure{◊svg{images/changes.svg}}}

◊new-thought{Git extends} the office metaphor of files and folders, but Git itself does not directly reason about them, it works over slips of paper which represent changes to the project. There is a difference between between nouns (for example, a file) and verbs (for example, creating a file), and Git reasons about the latter. Examples of changes that Git tracks are: creating files, removing files, moving (or renaming) files, adding lines to files, removing lines from files and modifying lines from files. The slips of paper containing changes include not only the new situation (for example, the line after modification), but also the old situation (for example, the line before modification). In the illustrations of the metaphor, changes are slips of paper with ◊code/inline{+} and ◊code/inline{-} marks, as opposed to full files.

The lifecycle of changes start in the working directory, when we make changes to the project. Create two files:

◊margin-note{See the ◊link/internal["/cooking/"]{Cooking} section for the actual recipes from this article.}

◊file-listing["cookies.txt"]{
Ingredients

...

Directions

...
}

◊file-listing["muffins.txt"]{
Ingredients

...

Directions

...
}

We can now check that Git detected the changes in the working directory.

◊git/gui{
  Click on ◊menu-option{Rescan} to see the new files listed on the ◊menu-option{Unstaged Changes} pane:

  ◊image["images/rescan.png"]{The changes in the working directory.}
}

◊git/cli{
  Run ◊code/inline{◊git/verb{status}}:

  ◊full-width{
    ◊code/block{
$ git ◊git/verb{status}
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	cookies.txt
	muffins.txt

nothing added to commit but untracked files present (use "git add" to track)
    }
  }
}

Thus far, Git only detected the changes in the working directory, but it has not registered them in the project history. The changes are not in a box in the cabinet, but only in the working directory.

◊section['staging-area]{Staging Area}

◊margin-note{◊figure{◊svg{images/staging-area.svg}}}

◊new-thought{We want to register} the creation of ◊path{cookies.txt} and ◊path{muffins.txt} into the project history. Currently, these changes are only slips of paper on the working directory. Before they go to a box and into the cabinet, they have to be organized in the paper tray. This intermediary step might seem trivial, because the changes ware small. But even in this simple case Git gives us flexibility, for example, we can choose to only register one of the recipes in the history, while we are still working on the other. We can be even more precise and choose line-by-line which parts of the recipes we want to record at the moment. This is possible because Git reasons about ◊reference['changes]{changes}, instead of files.

For simplicity, we follow the most common case and add all slips of paper from the working directory to the paper tray. Git has two names for the paper tray: ◊technical-term{staging area} and ◊technical-term{index}. The act of adding slips of paper from the working directory to the paper tray is called ◊technical-term{staging the changes} or ◊technical-term{adding the changes to the index}.

◊git/gui{
  Select a file on the ◊technical-term{Unstaged Changes} pane to see the corresponding changes on the upper-right pane. At the moment, the whole file is new, so its entire contents are displayed, later, this pane will show only the modified lines. Then, use the ◊menu-option/path["Commit" "Stage To Commit"] menu option to add the file creation to the index. It should move to the ◊menu-option{Staged Changes (Will Commit)} pane. Repeat the process for the other file. Alternatively, click on the ◊menu-option{Stage Changed} button to stage all the changes in one step:

  ◊figure{◊svg{images/staging.svg}}
}

◊git/cli{
  Run the following command:

  ◊code/block{
$ git ◊git/verb{add} ◊git/object{cookies.txt } ◊git/object{muffins.txt }
  }

  The ◊code/inline{◊git/verb{status}} has changed from “untracked files” to “changes to be committed:”

  ◊code/block{
$ git ◊git/verb{status}
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   cookies.txt
	new file:   muffins.txt
  }
}

The changes are now organized on the paper tray, the next step is to move them to a box and into the cabinet.

◊section['commits]{Commits}

◊margin-note{◊figure{◊svg{images/commit.svg}}}

◊new-thought{The last step} to register the changes in the project history is to move them from the paper tray to a box and into the cabinet. But, later, when inspecting the boxes, we do not always want to open each one of them and look at the paper slips inside. This would be tedious and uninformative. Instead, we label the boxes with high-level descriptions of their contents. These labels contain the following information:

◊margin-note{Git associates the boxes with their authors, which is why the ◊reference['local-setup]{setup} was necessary.}

◊list/unordered{
  ◊list/unordered/item{An unique identifier.}
  ◊list/unordered/item{The author name and email.}
  ◊list/unordered/item{The current date and time.}
  ◊list/unordered/item{A reference to the unique identifier of the previous box (or boxes) in the chain (except for this first box, which starts the chain).}
  ◊list/unordered/item{A high-level description of the contents.}
}

Git manages most of this information automatically. The only item requiring manual input is the last: the description of the box contents.

Once a box is closed, labeled, and goes into the cabinet, it becomes part of the project history and cannot be modified. It is possible to revert changes, for example, we could remove ◊path{cookies.txt}, but this removal is a new change, which exists on its own slip of paper, and goes into a separate box.

Git calls the boxes ◊technical-term{commits}, and the content descriptions in the labels are called ◊technical-term{commit messages}. The act of creating a ◊technical-term{commit} is called ◊technical-term{committing} the changes.

◊git/gui{
  Write a description of what is in the staging area on the ◊menu-option{Commit Message} pane, and click on the ◊menu-option{Commit} button:

  ◊figure{◊svg{images/create-commit.svg}}

  The status bar on the bottom confirms the commit creation, including a prefix of the unique identifier and the commit message. Go to the window showing the project history and to the ◊menu-option/path["File" "Update"] menu option to see the box in the cabinet:

  ◊image["images/history-first-commit.png"]{History with one commit.}
}

◊git/cli{
  Run the following command:

  ◊code/block{
$ git ◊git/verb{commit }
  }

  ◊margin-note{
    On most machines, the default text editor is ◊link["http://www.vim.org/"]{Vim}. Configure a different text editor with the following command:

    ◊code/block{
$ git ◊git/verb{config} \
  ◊git/object{--global core.editor "<EDITOR>"}
    }

    In many cases—particularly for ◊acronym{GUI} text editors—one has to provide extra options to the text editor for it to work with Git. For example, for ◊link["https://atom.io/"]{Atom}, one has to use ◊code/inline{◊git/object{"atom --wait"}}.
  }

  Git starts a text editor with a special file already open. To create the commit, write the commit message, save, and close that file:

  ◊code/block{
[master (root-commit) 464f886] Add first recipes
 2 files changed, 14 insertions(+)
 create mode 100644 cookies.txt
 create mode 100644 muffins.txt
  }

  The ◊code/inline{◊git/verb{status}} has changed, indicating that there are no longer any changes in the working directory with respect to the cabinet:

  ◊code/block{
$ git ◊git/verb{status}
On branch master
nothing to commit, working tree clean
  }
}

◊section['commits---revisited]{Commits—Revisited}

◊new-thought{These past few sections} were detailed and, therefore, slow. But going from a change in the working directory to a commit in the repository is a low overhead operation. Moreover, committing is the most common process in Git, so let us practice it one more time, on fast-forward. Create a new file:

◊file-listing["pancakes.txt"]{
Ingredients

...

Directions

...
}

◊git/gui{
  ◊list/ordered{
    ◊list/ordered/item{
      Click on ◊menu-option{Rescan} to see the file creation in the working directory:

      ◊image{images/create-commit-review-1.png}
    }
    ◊list/ordered/item{
      Click on ◊menu-option{Stage Changed} to add the file creation to the staging area:

      ◊image{images/create-commit-review-2.png}
    }
    ◊list/ordered/item{
      Write a commit message:

      ◊image{images/create-commit-review-3.png}
    }
    ◊list/ordered/item{
      Click on ◊menu-option{Commit} to create the commit:

      ◊image{images/create-commit-review-4.png}
    }
    ◊list/ordered/item{
      On the window showing the project history, go to the menu option ◊menu-option/path["File" "Update"] to see the new commit in the repository:

      ◊image{images/create-commit-review-5.png}
    }
  }
}

◊git/cli{
  ◊list/ordered{
    ◊list/ordered/item{
      Add the file creation to the staging area:

      ◊code/block{
$ git ◊git/verb{add} ◊git/object{pancakes.txt}
      }
    }
    ◊list/ordered/item{
      ◊margin-note{
        Alternatively, write the commit message as an argument:

        ◊code/block{
$ git ◊git/verb{commit} ◊git/object{-m "Add Pancakes"}
        }
      }

      Start the commit creation:

      ◊code/block{
$ git ◊git/verb{commit}
      }
    }
    ◊list/ordered/item{
      Write a commit message on the text editor that opens, save and close the file:

      ◊code/block{
[master 7ad6089] Add Pancakes
 1 file changed, 7 insertions(+)
 create mode 100644 pancakes.txt
      }
    }
  }
}

◊paragraph-separation[]

◊margin-note{◊figure{◊svg{images/commit-often.svg}}}

◊margin-note{
  See the ◊link["https://git.leafac.com/www.leafac.com/"]{source} for this article for an example of committing often, and the resulting polluted history. Most commit messages in this repository are just dots (◊code/inline{.}), to satisfy the requirement that every commit must include a message.

  See the source for ◊link["https://github.com/git/git/commits/master"]{Git itself} for an example of ◊reference['crafting-the-perfect-commit]{carefully crafted commits} which are often the result of rewriting the history.
}

◊new-thought{Creating a commit} is a straightforward process, and we should do it as often as possible. It is better to have an excess of commits than to wait for too long before committing. This avoids data loss and promotes early communication and review from collaborators. Some intermediary commits might not constitute meaningful contributions, and it is not important to write careful commit messages for them, simple reminders suffice. The writing of this article, for example, spans across hundreds of commits. Some of them include many changes, others just fix a single typo.

The disadvantage of this approach is that it pollutes the project history with unimportant commits. When comfortable with creating commits, read the appendix on ◊reference['crafting-the-perfect-commit]{◊emphasis{Crafting the Perfect Commit}} to learn how to fix this issue by rewriting the history.

◊section['read-history]{Read History}

◊margin-note{◊figure{◊svg{images/chain.svg}}}

◊new-thought{We created} two commits. The first includes the creation of the files ◊path{cookies.txt} and ◊path{muffins.txt}, and the second includes the creation of the file ◊path{pancakes.txt}. The second commit includes a reference to the first, but the first does not include a reference to the second. This happens because the second commit did not exist at the time we created the first, and once we added it to the repository, we cannot change it—commits are immutable. As we create more commits, each of them will include a reference to the immediate predecessor, forming an unidirectional chain. This chain of commits represents the project timeline, which we can read.

◊git/gui{
  Go to the window showing the project history:

  ◊figure{◊svg{images/history.svg}}

  ◊list/ordered{
    ◊list/ordered/item{The chain of commits.}
    ◊list/ordered/item{The first lines of the commit messages.}
    ◊list/ordered/item{The commit author and email.}
    ◊list/ordered/item{The date and time of the commit creation.}
    ◊list/ordered/item{
      ◊margin-note{Git calls the unique commit identifier ◊acronym{SHA1 ID}, after the hashing algorithm used to generate it.}

      The unique identifier of the currently selected commit. Use the panes above to switch to different commits.
    }
    ◊list/ordered/item{The whole commit label, including the entire commit message.}
    ◊list/ordered/item{A list of files changed by the currently selected commit.}
    ◊list/ordered/item{The changes in the commit.}
  }
}

◊git/cli{
  Run the following command to see the chain of commits:

  ◊code/block{
$ git ◊git/verb{log}
commit 7ad6089705d3dd0abdbde219274ae2c6e4631bef (HEAD -> master)
Author: Leandro Facchinetti <me@leafac.com>
Date:   Fri Aug 18 11:09:04 2017 -0400

    Add Pancakes

commit 464f886e53aa4475010e7569b9e9d8de14975969
Author: Leandro Facchinetti <me@leafac.com>
Date:   Fri Aug 18 10:24:41 2017 -0400

    Add first recipes
  }

  To see details about a particular commit, use ◊code/inline{◊git/verb{show}} with the commit identifier as argument:

  ◊margin-note{
    We can use the prefix of an unique identifier. For example, the following is equivalent to the other example:

  ◊code/block{
$ git ◊git/verb{show} ◊git/object{7ad60897}
    }
  }

  ◊code/block{
$ git ◊git/verb{show} ◊git/object{7ad6089705d3dd0abdbde219274ae2c6e4631bef}
commit 7ad6089705d3dd0abdbde219274ae2c6e4631bef (HEAD -> master)
Author: Leandro Facchinetti <me@leafac.com>
Date:   Fri Aug 18 11:09:04 2017 -0400

    Add Pancakes

diff --git a/pancakes.txt b/pancakes.txt
new file mode 100644
index 0000000..5bc1d5e
--- /dev/null
+++ b/pancakes.txt
@@ -0,0 +1,7 @@
+Ingredients
+
+...
+
+Directions
+
+...
  }
}

◊paragraph-separation[]

◊margin-note{◊figure{◊svg{images/blame.svg}}}

◊new-thought{Another point of view} for reading the project history is to start from a particular file and reconstruct its composition. We change files as the project evolves, so the current state of a file might be the result of several different commits. When looking for a bug, for example, it is helpful to find the commit that introduced a suspicious line, to read the commit message and understand the reason for its existence. Git calls this ◊technical-term{blaming} the file.

◊git/gui{
  On the main window, go to ◊menu-option/path["Repository" "Browse master's Files"]:

  ◊image{images/blame-1.png}

  In this file browser, select a file:

  ◊image{images/blame-2.png}

  The window above shows the file contents and, on the left, the commit that introduced the lines. It includes the commit identifier and the author’s initials. In our example, the whole file was introduced by a single commit, but this is generally not the case. Finally, click on the line of interest to see more details about the commit which introduced it:

  ◊image{images/blame-3.png}
}

◊git/cli{
  Use the ◊code/inline{◊git/verb{blame}} command with the file name as an argument:

  ◊full-width{
    ◊code/block{
$ git ◊git/verb{blame} ◊git/object{pancakes.txt}
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 1) Ingredients
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 2) 
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 3) ...
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 4) 
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 5) Directions
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 6) 
7ad60897 (Leandro Facchinetti 2017-08-18 11:09:04 -0400 7) ...
    }
  }

  To see the commit details, use ◊code/inline{◊git/verb{show}}, as above.
}

◊section['navigate-in-history]{Navigate in History}

◊new-thought{Once we find} a point of interest in history, we might want to navigate to it, having the working directory the same as it was then. For example, we might want to print a previous revision of our cookbook, before pancakes were introduced. One important precondition for navigating in history is to ◊emphasis{have no pending changes in the working directory}. If they exist, then commit them first.

Git calls this process of navigating in history ◊technical-term{checkout}.

◊git/gui{
  On the main ◊acronym{GUI} window, go to the ◊menu-option["Branch" "Checkout…"] menu option:

  ◊image{images/checkout.png}


  Fill in ◊menu-option{Revision Expression} input with the identifier for the first commit, which we collect by ◊reference['read-history]{reading the history}. Then click on the ◊menu-option{Checkout} button, Git shows a warning regarding a “detached checkout,” which is the subject of the following sections:

  ◊image{images/detached-checkout.png}

  Refresh the project history window using the ◊menu-option/path["File" "Update"] menu option and note that the yellow dot is at the first commit. The yellow dot marks the commit which the working directory currently represents:

  ◊image{images/history-after-checkout.png}
}

◊git/cli{
  Use the ◊code/inline{◊git/verb{checkout}} command with the identifier of the first commit, which we collect by ◊reference['read-history]{reading the history}:

  ◊full-width{
    ◊code/block{
$ git ◊git/verb{checkout} ◊git/object{464f886e53aa4475010e7569b9e9d8de14975969}
Note: checking out '464f886e53aa4475010e7569b9e9d8de14975969'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 464f886... Add first recipes
    }
  }

  The output warns about the unfortunately named “detached ◊code/inline{HEAD} state,” which is the subject of the following sections.
}

Inspect the contents of the working directory, the files ◊path{cookies.txt}	and ◊path{muffins.txt} should be there, but the file ◊path{pancakes.txt} should not. The working directory now reflects the point in time right after the first commit was created, when there was no pancakes recipe in the cookbook. But it is not lost, the repository still tracks the whole history, regardless of the situation of the working directory, and it contains the commit which introduced that recipe. We could navigate back to the second commit by checking it out.

◊paragraph-separation[]

◊margin-note{There is a reason to prefer the simpler version control systems embedded in other tools, in some situations. Binary files, for example, images and files created by word processors, are opaque to Git. This limits features like blaming files, because Git cannot specify which lines changed in the files. It records that the whole file changed, even if the modification was adding a single comma. Specialized version control systems embedded in the editing tools do not have this restriction.}

◊new-thought{The working directory}, the repository, changes, the staging area, commits, reading the history and navigating in it are the core concepts and operations in Git. This is the feature set generally supported by simple version control systems, for example, those embedded in word processors. But Git does much more than what we covered thus far. A hint is the warning Git issued when we checked out the first commit in our repository. The following sections address this issue.

◊section['references]{References}

◊margin-note{
  ◊figure{◊svg{images/references.svg}}

  The object on top of the cabinet is a rolodex with index cards.
}

◊new-thought{We ◊reference['navigate-in-history]{navigate in history}}, and the files and folders on our desktop reflect a point in the project timeline represented by a particular box in the cabinet. To orient ourselves, we need to know which box is currently checked out. So we keep an index card, which points to the appropriate box. We update this index card any time we checkout a different point in history, or when we create new boxes, for example.

◊margin-note{◊figure{◊svg{images/head.svg}}}

Git calls these index cards ◊technical-term{references}. There are different kinds of references, and the first we encounter is the special reference pointing to the currently checked out commit, which is called ◊code/inline{HEAD}. Git updates ◊code/inline{HEAD} automatically, for example, when committing and checking out.

◊git/gui{
  The ◊code/inline{HEAD} is represented by the yellow dot in the window showing the project history, as opposed to the blue dots:

  ◊figure{◊svg{images/gui-head.svg}}
}

◊git/cli{
  The position of ◊code/inline{HEAD} is the first line of output from ◊code/inline{◊git/verb{status}}:

  ◊code/block{
$ git ◊git/verb{status}
HEAD detached at 464f886
nothing to commit, working tree clean
  }
}

Understanding ◊code/inline{HEAD} is half of the way to solving the “detached checkout” or “detached ◊code/inline{HEAD}” mystery. The other half is the subject of the next section.

◊section['branches]{Branches}

◊margin-note{
  ◊figure{◊svg{images/branches.svg}}

  The first step in the figure above occurred when ◊reference['navigate-in-history]{navigating in history}, which resulted in the “detached ◊code/inline{HEAD}” state in the middle. The second step is the subject of this section, evading the “detached ◊code/inline{HEAD}” state.
}

◊new-thought{While we ◊reference['navigate-in-history]{navigate in history}}, ◊code/inline{HEAD} points at different commits, so how do we know which box in the cabinet represents the most recent point in our cookbook timeline? We need a second kind of index card, one that is not special in that it does not always point at the commit that the working directory represents. We need an index card that points at the end of the timeline, and only updates if we create new boxes.

Git includes this second kind of references, which it calls ◊technical-term{branches}, for reasons which will become evident ◊reference['tree]{later}. When we started committing to the repository, Git created a branch and it has been updating it automatically ever since, keeping the branch pointing at the most recent commit in the timeline. By convention, the name of this first branch created by Git is ◊code/inline{master}.

Branches complete the picture of the “detached checkout” or “detached ◊code/inline{HEAD}” mystery. The ◊code/inline{HEAD} reference can point to a commit directly or indirectly, via a branch. Initially, Git kept ◊code/inline{HEAD} pointing to the most recent commit in the timeline ◊emphasis{indirectly}, via the ◊code/inline{master} branch. Then, when ◊reference['navigate-in-history]{navigating in history}, we checked out a commit identifier, making ◊code/inline{HEAD} point to a commit directly. This state is called “detached checkout” or “detached ◊code/inline{HEAD}” by Git, because there is no branch associated with ◊code/inline{HEAD}.

◊margin-note{There is a method for potentially recovering inaccessible commits. Git comes with an advanced command called ◊code/inline{◊git/verb{reflog}}, which lists the commits at which ◊code/inline{HEAD} has recently pointed. If ◊code/inline{HEAD} has recently been pointing at the lost commit, then it is listed by ◊code/inline{◊git/verb{reflog}} and it is possible to recover it. If enough activity has happened in the repository, then the lost commit might have been purged from the ◊code/inline{◊git/verb{reflog}}. Moreover, Git might have run a garbage collection routine, which permanently removes inaccessible commits from the repository. In that case the commit is unrecoverable.}

Besides the disturbing name, there is nothing wrong with the “detached ◊code/inline{HEAD}” state. It can be useful for exploring the history, conducting quick experiments and so forth. We can even commit while in “detached ◊code/inline{HEAD}” state, and Git will update the ◊code/inline{HEAD} reference automatically. But, if we checkout another commit or branch after committing, then there will be no pointers to this new commit, and it becomes inaccessible.

There are few operations in Git which might result in data loss, and making a commit inaccessible is one of them. That is why Git issued an warning when we entered “detached ◊code/inline{HEAD}” state. But we can have more branches besides ◊code/inline{master}, pointing at arbitrary commits in the timeline. So let us can evade our currently potentially dangerous situation and avoid data loss by creating a new branch. Suppose that we want to create this branch because the changes we want to make to the cookbook are to start working on a brownies recipe.

◊git/gui{
  Go to the ◊menu-option/path["Branch" "Create…"] menu option:

  ◊image["images/branch-create.png"]

  Click on ◊menu-option{Create} and then use the ◊menu-option/path["File" "Update"] menu option on the window showing the project history:

  ◊image["images/history-after-branch-creation.png"]

  On the image above, green rectangles represent the ◊code/inline{master} and ◊code/inline{brownies} branches. Moreover, ◊code/inline{brownies} is bold, to demonstrate that ◊code/inline{HEAD} points at it. And ◊code/inline{HEAD} still indirectly points at the same commit, as indicated by the yellow dot.
}

◊git/cli{
  Run the following command:

  ◊code/block{
$ git ◊git/verb{branch} ◊git/object{brownies}
  }

  This creates the branch, but does not change ◊code/inline{HEAD}, as revealed by ◊code/inline{◊git/verb{status}}:

  ◊code/block{
$ git ◊git/verb{status}
HEAD detached at 464f886
nothing to commit, working tree clean
  }

  ◊margin-note{
    Alternatively, create a branch and check it out in one command:

    ◊code/block{
$ git ◊git/verb{checkout} ◊git/object{-b brownies}
Switched to a new branch 'brownies'
    }
  }

  We have to checkout the new branch as a separate step:

  ◊code/block{
$ git ◊git/verb{checkout} ◊git/object{brownies}
  }

  Now the ◊code/inline{◊git/verb{status}} has changed:

  ◊code/block{
$ git ◊git/verb{status}
On branch brownies
nothing to commit, working tree clean
  }
}

We are no longer in “detached ◊code/inline{HEAD}” state. Also, we can navigate in history more conveniently using branch names (◊code/inline{master} and ◊code/inline{brownies}) instead of commit identifiers. Finally, the timelines for the different branches can evolve independently, which is the subject of the next section.

◊section['tree]{Tree}

◊new-thought{The current state} of the repository is: there are two commits, one with a full recipe for vegan cookies, another with just the ingredients part; also, there are two branches, called ◊code/inline{master} and ◊code/inline{brownies}, pointing at the second and first commit, respectively; the working directory reflects the time at the first commit, because the ◊code/inline{brownies} branch is checked out.

Let us start working on the ◊code/inline{brownies} recipe:

◊full-width{
  ◊code/block{
$ echo -e "Ingredients\n\n...\n\n" >> vegan-brownies.txt
$ git ◊git/verb{add} ◊git/object{vegan-brownies.txt}
$ git ◊git/verb{commit} ◊git/object{-m "Start working on vegan brownies"}
[brownies 9ea8492] Start working on vegan brownies
 1 file changed, 5 insertions(+)
 create mode 100644 vegan-brownies.txt
  }
}

Refreshing the window showing the repository history shows the following picture:

◊margin-note{◊figure{◊svg{images/brownies-commit.svg}}}

◊image["images/tree.png"]{A tree starting to form in the project history.}

The history of the project has diverged. The original timeline is still there, represented by the ◊code/inline{master} branch. It contains the full recipe for vegan cookies. Alternatively, on the ◊code/inline{brownies} branch, there is the recipe for vegan brownies, but the directions part of the cookies recipe is not there, because it was only added on the second commit of the main timeline. We can checkout the branches to navigate between these ◊informal{parallel universes} and see the differences:

◊margin-note{Branches in Git are just references to commits, not copies of the project, which makes them fast and cheap. This was an important feature that set Git apart from other version control systems and led to its popularity.}

◊margin-note{◊figure{◊svg{images/tree.svg}}}

◊code/block{
$ ls
vegan-brownies.txt	vegan-cookies.txt
$ cat vegan-cookies.txt
Ingredients

...


$ git ◊git/verb{checkout} ◊git/object{master}
Switched to branch 'master'
$ ls
vegan-cookies.txt
$ cat vegan-cookies.txt
Ingredients

...


Directions

...


}

If we keep at this, creating branches and committing on them, then the project history starts to look like a tree, hence the name. But creating more and more of these ◊informal{parallel universes} is not enough. Eventually we conclude the development of the brownies recipe, and we want to bring it back to the main line of history for our cookbook project. That is the subject of the ◊reference['merge]{next section}.

◊section['merge]{Merge}

◊new-thought{We are working} on a recipe for vegan brownies on a separate branch, called ◊code/inline{brownies}. During this process, the main line of development for our cookbook is still ◊code/inline{master}. The two branches can advance with more commits independent of one another—changes in ◊code/inline{brownies} are not seen in ◊code/inline{master} and vice-versa. This is important to prevent interference, it could be hard to write a recipe if the rest of the cookbook keeps changing. For this small project, this might seem like an abundance of caution, but for bigger projects it is an essential feature.

◊margin-note{
  ◊figure{◊figure{◊svg{images/merge.svg}}}

  The merge commit contains changes from both parents. The result no longer looks like a tree, the technical term for this data structure is ◊technical-term{Directed Acyclic Graph (◊acronym{DAG})}.
}

When the development of the brownies recipe is complete, it is time to bring it to the main line of development, on the ◊code/inline{master} branch. In our running example, the result bringing together the brownies recipe on the ◊code/inline{brownies} branch and the directions for the cookies recipe on the second commit of the ◊code/inline{master} branch. Git calls this operation a ◊technical-term{merge}.

Start by checking ◊code/inline{master} out. On the ◊acronym{GUI}, use the ◊emphasis{Branch} > ◊emphasis{Checkout…} menu option:

◊image["images/checkout-master.png"]{The checkout dialog.}

Then, use the ◊emphasis{Merge} > ◊emphasis{Local Merge…} menu option, and select to merge the ◊code/inline{brownies} branch:

◊image["images/merge.png"]{The merge dialog.}

After clicking on the ◊emphasis{Merge} button, the following screen shows that the merge succeeded:

◊image["images/merge-succeeded.png"]{The merge succeeded.}

To see the effect of the merge, go to the window showing the repository history and select the menu option ◊emphasis{File} > ◊emphasis{Update}:

◊margin-note{
  There is a special case of merge when the branch being merged is a direct successor of the current branch. It is not necessary to create a new merge commit with the tips of the two branches as parents, because advancing the pointer is enough to merge the two lines of history. Git calls this a ◊technical-term{fast-forward}. The following example shows a merge of the ◊code/inline{cupcakes} branch into ◊code/inline{master}. The ◊code/inline{master} branch advanced to match ◊code/inline{cupcakes}, but no new merge commits are created:

  ◊figure{◊svg{images/fast-forward.svg}}
}

◊image["images/history-after-merge.png"]{The project history after the merge.}

The ◊code/inline{brownies} branch remains pointing at the same commit as before, and ◊code/inline{master} has advanced to point at a new commit which has two parents. One of the parents is our second commit, adding directions to the cookies recipe; and the other parent is the commit adding the brownies recipe. Use a text editor to assert that both recipes are in the working directory at the same time.

At this point, it is safe to remove the ◊code/inline{brownies} branch. Use the ◊emphasis{Branch} > ◊emphasis{Delete…} menu option on the main window:

◊image["images/delete-branch.png"]{The branch deletion dialog.}

Check the branch deletion on the project history by refreshing:

◊image["images/after-branch-deletion.png"]{History after branch deletion.}

On the ◊acronym{CLI}, start by checking ◊code/inline{master} out using the ◊code/inline{◊git/verb{checkout}} command:

◊code/block{
$ git ◊git/verb{checkout} ◊git/object{master}
Switched to branch 'master'
}

Then, merge the ◊code/inline{brownies} branch using the using the ◊code/inline{◊git/verb{merge}} command:

◊code/block{
$ git ◊git/verb{merge} ◊git/object{brownies}
Merge made by the 'recursive' strategy.
 vegan-brownies.txt | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 vegan-brownies.txt
}

A text editor will open when running the command above, to allow for customizing the commit message for the merge commit. After finishing the process, observe the situation of the working directory, which contains the changes from both the cookies and the brownies recipes:

◊code/block{
$ ls
vegan-brownies.txt	vegan-cookies.txt
$ cat vegan-cookies.txt
Ingredients

...


Directions

...


}

Finally, delete the ◊code/inline{brownies} branch:

◊code/block{
$ git ◊git/verb{branch} ◊git/object{-d brownies}
Deleted branch brownies (was 9ea8492).
}

◊paragraph-separation[]

◊new-thought{Iterate on the process} above and, eventually, a version of the cookbook will be ready for release. It does not mean that work on it will halt, but that a certain point in history is special, and we want to mark it. That is the topic of the ◊reference['tags]{next section}.

◊section['tags]{Tags}

◊margin-note{◊svg{images/tag.svg}}

◊new-thought{Tags are the last} kind of ◊refernece['references]{reference} covered in this article. They are similar to ◊reference['branches]{branches} in that they point to arbitrary commits and are identified by a name. The difference is that they ◊emphasis{do not move}. Tags are immutable, they always point to the same commit at which they pointed when created. Their main utility is to mark special points in history, for example, released versions or the last version before a big structural change on the project.

To create a tag on the ◊acronym{GUI}, go to the window showing the project history, right-click on the commit of interest and use the ◊emphasis{Create tag} option:

◊image["images/tag.png"]{Tag creation.}

After clicking on the ◊emphasis{Tag} button, the project history shows the tag:

◊image["images/history-after-tag.png"]{Project history with a tag.}

On the ◊acronym{CLI}, the process is similar to creating a branch. First, checkout the commit of interest, then run the following command:

◊code/block{
$ git ◊git/verb{tag} ◊git/object{cookbook-0.1}
}

◊paragraph-separation[]

◊new-thought{This concludes} the overview of the basic features for using Git locally. Next, we discuss how to distribute the repository to remote computers.







































◊; ◊section['remote-repositories]{Remote Repositories}

◊; Analogy (fax machine)
◊; GitHub (example, popular) / gitlab bitbucket / any other machine would work
◊; speed-dial ‘git remote add …’ (phrasal verb)

◊; ◊section['aside-a-primer-to-public-key-cryptography]{Aside: A Primer to Public-Key Cryptography}

◊; ◊section['connect-to-remote]{Connect to Remote}

◊; ◊section['communicate-with-remote]{Communicate with Remote}

◊; push, fetch+merge, pull

◊; ◊paragraph-separation[]

◊; BUILD UP TO “GIT FOR COLLABORATION”

◊; ◊new-thought{Changes, commits, references}, branches, merges and tags. These are the core concepts for working effectively with Git on a single machine. They are flexible features, which accommodate diverse workflows, from big distributed teams developing big projects to a single person versioning a single file. On the ◊references['workflow]{following section} we cover a simple workflow that brings together all the concepts presented thus far.

◊; ◊section['workflow]{Workflow}

◊; ◊new-thought{There does not exist} a single workflow with Git that comprehends all the different features and use cases. Git is a flexible tool which accommodates a wide variety of needs. It is possible to create complex schemes to organize branches and these might solve problems common in big companies and projects. But most Git users avoid this complexity, and follow the streamlined workflow which we present in this section. It is in the sweet spot between simplicity, flexibility, and a rich and useful project history.

◊; GitHub flow: https://guides.github.com/introduction/flow/

◊; Avoid long-runnign branches.

◊; ◊section['where-to-learn-more-about-git]{Where to Learn More About Git?}

◊; https://git-scm.com/
◊; https://try.github.io · By Code School
◊; http://gitreal.codeschool.com/
◊; http://rogerdudler.github.io/git-guide/
◊; https://help.github.com/
◊; https://git-scm.com/book/
◊; https://git-scm.com/docs
◊; MANUALS

◊; ------------------ APPENDIX -----------------------------------

◊; ◊appendix['crafting-the-perfect-commit]{Crafting the Perfect Commit}

◊; .gitignore

◊; Git is flexible and supports different workflows.

◊; make sure the changes to the code do not break the test suite, add tests for any new code, and include documentation, ◊link["http://keepachangelog.com"]{changelog entries}, and a detailed commit message

◊; ◊margin-note{The reader interested in the ◊acronym{CLI} support for selectively adding changes to the index should refer to the ◊code/inline{◊git/object{--interactive}} option documented on the ◊link["https://git-scm.com/docs/git-add#git-add---interactive"]{◊code/inline{git-add(1)}} manual page.}

◊; It is possible to be selective and add changes to the index line-by-line. The ◊acronym{CLI} has this feature, but the interface for it is cumbersome; the ◊acronym{GUI} is better. On the ◊technical-term{Unstaged Changes} pane, click on the relevant file and the changes appear on the right pane; then right-click on the hunk or line of interest and use the ◊technical-term{Stage Hunk For Commit} or the ◊technical-term{Stage Line For Commit} action.

◊; ◊margin-note{Unfortunately, on the ◊acronym{GUI} we are using, the option of selectively staging parts of a ◊emphasis{new} (untracked) file is unavailable. The example in the figure is from another repository in which there are changes in the working directory for a tracked file (one which Git already knows about). Other ◊acronym{GUI}s have this missing feature.}

◊; ◊image["images/selective-staging.png"]{Selective staging.}

◊; They contain modifications to the code (don’t break tests—git bisect), tests, documentation, changelog and so forth, and the commit message includes a careful explanation of the motivation, alternative solutions, links to bug trackers and more. It should explain everything about the context for a person at the history in the future. These messages generally follow a ◊link["http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html"]{strict format}: a short title on a line by itself, a blank line, and then paragraphs or bulleted lists with more detailed information.

◊; «Example of commit message»

◊; During development, one should use a personal space in the repository, ◊emphasis{commit early, and commit often}, using the commit messages as notes to self. When a feature stabilizes, all tests are passing, and the development is ready to be part of the project, then Git offers ways to ◊reference['crafting-the-perfect-commit]{rewrite the history} and craft a carefully constructed commit. This approach is more advanced, but it is better to follow it than to wait too long to commit, and risk losing work in the process.

◊; ◊margin-note{Pay attention to the line-length limits in carefully constructed commit messages. They are important for people using tools which do not soft-wrap the text, including the ◊acronym{CLI}.}

◊; ‘rebase --interactive’

◊; TODO: Fix tag for menu options (for example, ‘Repository’ > ‘See all’). For now they are ◊emphasis, but they should be more semantic. Also, some might be missing the ellipsis.

◊; TODO: More semantic tag for file names.

◊; TODO: Redo all the images of the GUI up to ‘Tag’, using the proper capturing tool with the space bar??

◊; TODO: Double-check ◊git/verb & ◊git/object

◊; TODO: Double-check that every ◊svg is surrounded by ◊figure