#lang pollen

◊define-meta[title]{Git by Analogy}
◊define-meta[date]{2017-08-15}

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

We configure Git to ignore these files by creating a file at ◊path{~/.config/git/ignore} with one line for each path Git must ignore:

◊margin-note{The language to specify ignored files is sophisticated, see ◊link["https://git-scm.com/docs/gitignore"]{the manual for ◊code/inline{gitignore(5)}}.}

◊code/block{
# ~/.config/git/ignore

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

  The screen above means the repository was successfully created. Besides this main ◊acronym{GUI} window, there is another front-end window to show the project history. Open it with the ◊menu-option/path["Repository" "Visualise All Branch History"] menu option, or directly from the command line with ◊code/inline{gitk}. Currently there is no history to show, the cabinet is still empty, so this window shows an error:

  ◊image["images/no-history-yet.png"]{History visualization window with error due to empty repository.}
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

The lifecycle of changes start in the working directory, when we make changes to the project. Create a file named ◊path{vegan-cookies.txt} with the following contents:

◊margin-note{The ◊link/internal["/cooking/chocolate-chip-cookie/"]{complete vegan cookies recipe}.}

◊code/block{
# vegan-cookies.txt
Ingredients

...
}

We can now check that Git detected the change in the working directory.

◊git/gui{
  Click on ◊menu-option{Rescan} to see the new file listed on the ◊menu-option{Unstaged Changes} pane:

  ◊image["images/rescan.png"]{The change in the working directory.}
}

◊git/cli{
  Run ◊code/inline{◊git/verb{status}}:

  ◊full-width{
    ◊code/block{
$ git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	vegan-cookies.txt

nothing added to commit but untracked files present (use "git add" to track)
    }
  }
}

Thus far, Git only detected the change in the working directory, but it has not registered it in the project history yet. The change is not in a box in the cabinet, but only in the working directory.

◊section['staging-area]{Staging Area}

◊margin-note{
  ◊figure{◊svg{images/staging-area.svg}}

  The staging area.
}

◊new-thought{To introduce the new file} to Git, the first step is to add to the paper tray the slip of paper representing the file creation. Later, these scraps of paper will be the contents of a box, which will be part of the project’s history. This intermediary step is important, because it is on the paper tray that we organize the changes into a set that makes sense on its own. We do not always want to add all the changes in the working directory to the paper tray. Some of them might never go the paper tray at all—they might be, for example, the result of a failed experiment, which we do not want as part of the project’s history.

◊margin-note{It is possible to be more selective and stage ◊reference['changes]{changes} hunk by hunk or line by line. See ◊reference['crafting-the-perfect-commit]{◊emphasis{Crafting the Perfect Commit}} for more.}

For simplicity, in our first example we will add to the paper tray the scrap of paper representing the creation of the whole ◊code/inline{vegan-cookies.txt} file. The technical names for the paper tray are ◊technical-term{staging area} or ◊technical-term{index}. We add changes to the index using the following command:

◊code/block{
$ git ◊git/verb{add} ◊git/object{vegan-cookies.txt }
}

◊acronym{GUI} users should select ◊code/inline{vegan-cookies.txt} on the ◊technical-term{Unstaged Changes} pane and click on ◊technical-term{Stage Changed}. This has the same effect as the command line above.

When asked about the current status, Git’s output has changed:

◊code/block{
$ git ◊git/object{status }
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

    new file:  vegan-cookies.txt
}

Git now knows that the creation of the file ◊code/inline{vegan-cookies.txt} is on the paper tray and will be part of the next box (commit). The next section addresses this step.

◊section['commits]{Commits}

◊margin-note{
  ◊figure{◊svg{images/commit.svg}}

  A single commit.
}

◊new-thought{In our office analogy}, the ◊technical-term{commits} are the ◊informal{labeled boxes} which live in the cabinet (◊reference['repository]{repository}) and store the changes to the project. At this point, the changes are organized on the ◊informal{paper tray} and ready to go into the box. To finish the process, we have to create the label, which is composed of:

◊list/unordered{
  ◊list/unordered/item{Information about the author including name and email.}
  ◊list/unordered/item{The current date and time.}
  ◊list/unordered/item{An unique identifier.}
  ◊list/unordered/item{A reference to the identifier of the previous box in the chain (except for this first commit, which starts the chain).}
  ◊list/unordered/item{A high-level description of the contents.}
}

◊margin-note{The ◊reference['local-setup]{setup} process of identifying to Git was necessary to make the automatic parts of labeling work.}

All information except for the last are added to the label automatically by Git. The commit author has to provide a description of its contents; on the ◊acronym{GUI}, this goes on the bottom-right pane:

◊figure{◊svg{images/gui-commit.svg}}

The equivalent on the ◊acronym{CLI} is the following:

◊code/block{
$ git ◊git/verb{commit }
}

◊margin-note{
  On most machines, the default text editor is ◊link["http://www.vim.org/"]{Vim}. Configure the text editor that Git uses with:

  ◊code/block{
$ git ◊git/verb{config} \
  ◊git/object{--global core.editor "<EDITOR>"}
  }

  In many cases—particularly for ◊acronym{GUI} text editors—one has to provide extra options to the text editor for it to work well with Git. For example, for ◊link["https://atom.io/"]{Atom}, one has to use ◊code/inline{◊git/object{"atom --wait"}}.
}

After running this command, Git starts a text editor with a special file already open. To finally create the commit, one has to write the commit description on that file and close it. Git will then print some statistics about the commit:

◊margin-note{The ◊code/inline{cff98a54} in the output is the unique identifier for the commit, it is different for each repository.}

◊code/block{
".git/COMMIT_EDITMSG" 10L, 250C written 
[master (root-commit) cff98a54] Add cookies recipe 
 1 file changed, 1 insertion(+)
  create mode 100644 vegan-cookies.txt
}

On the ◊acronym{GUI}, one clicks on ◊technical-term{Commit}, and the status bar indicates success:

◊margin-note{The word “commit” can be a noun, meaning the box containing changes, or a verb, meaning the act of creating the box.}

◊image["images/after-first-commit.png"]{After first commit.}

Now our cabinet (repository) contains the first labeled box (commit). The paper tray (staging area) is empty and Git gives us a new empty box to fill with the next changes to the project. Asking for the current status confirms that:

◊code/block{
$ git ◊git/verb{status}
On branch master
nothing to commit, working tree clean
}

◊paragraph-separation[]

◊new-thought{These past few sections} have been slow and detailed, but going from a change in the working directory to a commit is a low overhead operation—specially if there is Git support integrated in the text editor. Let us review the whole process, on fast-forward. First, modify a file using a text editor or the following command line:

◊code/block{
$ echo -e "Directions\n\n...\n\n" >> vegan-cookies.txt
}

Then, if using the ◊acronym{GUI}, click on ◊emphasis{Rescan}, select the file name under ◊technical-term{Unstaged Changes}, click on ◊emphasis{Stage Changed}, write a message on the lower-right pane and click on ◊emphasis{Commit}. Alternatively, if using the command line, run the following:

◊margin-note{Use the ◊code/inline{◊git/object{-a}} option only when confident of the changes on the working directory. Generally, it is better to inspect the changes and organize them on the staging area. This is the perfect opportunity to spot unaddressed ◊code/inline{TODO}s left over on the code, for example.}

◊code/block{
$ git ◊git/verb{commit} ◊git/object{-am "Add directions"}
}

◊margin-note{The ◊code/inline{◊git/object{-a}} and the ◊code/inline{◊git/object{-m}} options have been condensed into ◊code/inline{◊git/object{-am}}.}

The command above is a shortcut for convenience. The ◊code/inline{◊git/object{-a}} option adds all changes to the index—subsuming the ◊code/inline{◊git/verb{add}} command—and the ◊code/inline{◊git/object{-m}} option lets us specify the commit message without opening a text editor.

◊section['fine-points-about-commits]{Fine Points About Commits}

◊margin-note{For an example of a small personal project in which commits are ◊emphasis{not} carefully crafted, see the ◊link["https://git.leafac.com/www.leafac.com/"]{source} for the website containing this article. For an example of the opposite, see the source for ◊link["https://github.com/git/git/commits/master"]{Git itself}.}

◊new-thought{What constitutes} a meaningful contribution, and, consequently, a commit? The answer to this question depends on who are the potential consumers of this information. On projects of lesser importance, people might only be interested in some aspects of version control, for example, not losing files due to corruption or facilitating collaboration on a small team. In those cases, little care goes into crafting meaningful commits and their corresponding commit messages.

On bigger, more important projects, in which more people are involved, a lot of attention goes into the commits. They make sure the changes to the code do not break the test suite, add tests for any new code, include documentation, and so forth. But, generally, these great commits are not born this way. They are manufactured after the fact, using the advanced techniques laid out on a ◊reference['crafting-the-perfect-commit]{later section}.

Beginners should ◊emphasis{commit early, and commit often}. Anything from a single line to a couple hours of work is enough. It is better to have too many commits than to wait until too many changes have accumulated in the working directory. The commit messages can be notes to self, to inform the writing of a detailed commit message in the future, if desirable. This is the best way to enjoy some of the benefits of version control with minimal effort.

◊section['read-history]{Read History}

◊margin-note{Alternatively, open the ◊acronym{GUI} by running the program ◊code/inline{gitk} instead of ◊code/inline{git ◊git/verb{gui}} on the command line.}

◊new-thought{In our running example} we already have two commits, how do we inspect those ◊emphasis{boxes in the cabinet}? The recommended approach is to use the ◊acronym{GUI}, by going to the menu option ◊emphasis{Repository} > ◊emphasis{Visualise All Branch History}:

◊margin-note{Git names the unique identifier for the commits after the hashing algorithm used to calculated it: ◊acronym{SHA1}.}

◊image["images/log.png"]{The contents of the cabinet: the project history.}

◊margin-note{Any prefix of the commit identifier that remains unique throughout the repository is a valid argument for ◊code/inline{◊git/verb{show}}, for example, ◊code/inline{◊git/object{ab84ed16}} would have the same result.}

The top panes show the chain of commits, most recent on top. It includes the title of the commit message, author and date. The lower panes show information about the selected commit. It includes the full commit message, the list of modified files, the changes in those files, and the ◊acronym{SHA1 ID}, which is how Git calls the unique identifier for the commit.

On the command-line, use a combination of ◊code/inline{◊git/verb{log}} and ◊code/inline{◊git/verb{show}} to achieve the same effect:

◊full-width{
  ◊code/block{
$ git ◊git/verb{log}
commit ab84ed162d98c5d41f09826408a1412a5ed655f5 (HEAD -> master)
Author: Leandro Facchinetti <me@leafac.com>
Date:   Mon Jul 24 17:46:48 2017 -0400

    Add directions

commit 30a7d90741c4ef3544562144a9b4b692ba58e2e0
Author: Leandro Facchinetti <me@leafac.com>
Date:   Mon Jul 24 17:46:35 2017 -0400

    Add cookies recipe

$ git ◊git/verb{show} ◊git/object{ab84ed162d98c5d41f09826408a1412a5ed655f5}
commit ab84ed162d98c5d41f09826408a1412a5ed655f5 (HEAD -> master)
Author: Leandro Facchinetti <me@leafac.com>
Date:   Mon Jul 24 17:46:48 2017 -0400

    Add directions

diff --git a/vegan-cookies.txt b/vegan-cookies.txt
index 5ce4655..11660f0 100644
--- a/vegan-cookies.txt
+++ b/vegan-cookies.txt
@@ -3,3 +3,8 @@ Ingredients
 ...


+Directions
+
+...
+
+
  }
}

The snippet above first shows the project history in reverse chronological order. The ◊code/inline{◊git/verb{log}} command lists the boxes labels, with the unique identifier and information about the author, the date at the moment of commit, and the message describing the box contents written by the author. Then, we select a single identifier and use ◊code/inline{◊git/verb{show}} to see the contents of a particular box.

◊paragraph-separation[]

◊new-thought{Another use case} for reading the project history is to reconstruct how a particular file was composed. This amounts to recovering all the most recent slips of paper relative to that file that have not been subsumed by subsequent changes. These slips of paper might be in several different boxes and, Git, the office robot, automates all the hard work of finding them. In Git terminology, this is called ◊emphasis{blaming} the file.

On the ◊acronym{GUI}, go back to the window which we used to create a commit—as opposed to the one showing the project history—and use the menu option ◊emphasis{Repository} > ◊emphasis{Browse master’s Files}. This opens a file browser, and selecting a file on it opens another window containing the reconstruction of that file over time, with all the relevant commits. Clicking on section of the file opens information about the particular commit on the bottom pane, and clicking on the commit identifier in blue on the left changes the perspective to show how the file was at that time.

◊image["images/blame.png"]{The file browser on the top, the reconstruction of the vegan cookie recipe in the middle, and information about a particular commit on the bottom.}

On the ◊acronym{CLI}, use the ◊code/inline{◊git/verb{blame}} command with the name of the file of interest as argument:

◊full-width{
  ◊code/block{
$ git ◊git/verb{blame} ◊git/object{vegan-cookies.txt}
^30a7d90 (Leandro Facchinetti 2017-07-24 17:46:35 -0400  1) Ingredients
^30a7d90 (Leandro Facchinetti 2017-07-24 17:46:35 -0400  2)
^30a7d90 (Leandro Facchinetti 2017-07-24 17:46:35 -0400  3) ...
^30a7d90 (Leandro Facchinetti 2017-07-24 17:46:35 -0400  4)
^30a7d90 (Leandro Facchinetti 2017-07-24 17:46:35 -0400  5)
ab84ed16 (Leandro Facchinetti 2017-07-24 17:46:48 -0400  6) Directions
ab84ed16 (Leandro Facchinetti 2017-07-24 17:46:48 -0400  7)
ab84ed16 (Leandro Facchinetti 2017-07-24 17:46:48 -0400  8) ...
ab84ed16 (Leandro Facchinetti 2017-07-24 17:46:48 -0400  9)
ab84ed16 (Leandro Facchinetti 2017-07-24 17:46:48 -0400 10)
  }
}

◊section['navigate-in-history]{Navigate in History}

◊new-thought{Besides reading the history}, as we covered in the ◊reference['read-history]{previous section}, one can ◊informal{travel in time}, and have the working directory reflect the project state at some time in the past. The boxes (commits) in the cabinet (repository) form a chain, because their labels include a reference to the previous (parent) box. So Git can open each of these boxes in reverse order and apply the changes in them backwards to the working directory, an operation it calls ◊technical-term{checkout}.

◊margin-note{If the uncommitted changes in the working directory and the changes in checkout do not refer to the same lines of the same files, then checkout succeeds even in an ◊technical-term{dirty} working directory. But having a ◊technical-term{clean} working directory before checkout avoids confusion.}

A necessary precondition for this operation is that the working directory is ◊technical-term{clean}. There should be no pending changes that have not been committed. This is important because checkout modifies the files in the working directory, and uncommitted changes could conflict with those modifications. Our project is already in this ◊technical-term{clean} state, so we can move on.

On the ◊acronym{GUI}, go to the window with the repository history, which we introduced in the ◊reference['read-history]{previous section}, and copy the identifier for the first commit, in which we added the cookies recipe:

◊image["images/identifier-for-previous-commit.png"]{The first commit is selected on the top pane, and the identifier is on the right of the button labeled ‘SHA1 ID:’. This identifier changes from repository to repository.}

Now, back on the other window, go to ◊emphasis{Branch} > ◊emphasis{Checkout}, and paste the identifier on the dialog box:

◊image["images/checkout.png"]{The checkout dialog.}

Finally, click on ◊emphasis{Checkout}. A dialog warns about “branches” and “detached checkouts,” we will learn about them on the following sections. For the time being, it is safe to click ◊emphasis{◊acronym{OK}}:

◊image["images/detached-checkout.png"]{A dialog warning about a “detached checkout,” which can be ignored for now.}

To check that checkout succeeded, go to the window showing the repository history and select the menu option ◊emphasis{File} > ◊emphasis{Update}. The graph showing the repository history changes, showing the first commit highlighted in yellow. This represents the point in time that the working directory currently reflects:

◊image["images/after-checkout.png"]{After checkout, the current commit is the first in history—in yellow.}

◊margin-note{Many text editors reload files changed in the disk automatically.}

To see the effect of checkout in the working directory, reload ◊code/inline{vegan-cookies.txt} from the disk in the text editor. Notice that the part added on the second commit regarding directions is no longer there. This does not mean that those changes are lost, they are still preserved in the box in the cabinet, and can be recovered any time. It is just the current state of the working directory that reflects an earlier point in history.

To perform a checkout on the ◊acronym{CLI}, first copy the commit identifier for the first commit from the ◊code/inline{◊git/verb{log}} command in the ◊reference['read-history]{previous section}. Then, use the ◊code/inline{◊git/verb{checkout}} command with the identifier as an argument:

◊code/block{
$ git checkout 30a7d90741c4ef3544562144a9b4b692ba58e2e0
Note: checking out '30a7d90741c4ef3544562144a9b4b692ba58e2e0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 30a7d90... Add cookies recipe
}

As before, inspecting ◊code/inline{vegan-cookies.txt} reveals the changes to the working directory:

◊code/block{
$ cat vegan-cookies.txt
Ingredients

...
}

But, similar to the ◊acronym{GUI} dialog, the output of the ◊code/inline{◊git/verb{checkout}} command includes a warning. Instead of “detached checkout,” it uses the unfortunately gory term “detached ◊code/inline{HEAD}.” We address this on the ◊reference['references]{next section}.

◊; TODO: MARK WHEN FINISHED CORE FEATURES…

◊section['references]{References}

◊margin-note{◊svg{images/references.svg}}

◊new-thought{In our office} metaphor for how Git works, the cabinet contains a chain of boxes. Each box label contains a reference to the parent box, so we can reconstruct the history by following the chain. But how do we know where it starts?

We can borrow the solution used by libraries: index cards. The index cards point to the box that starts the chain. When performing operations on the cabinet, we start by looking the index cards. For example, in a ◊reference['read-history]{previous section}, we asked Git to show the project history, listing each commit. It accomplished that by first consulting an index card. We did not specify which index card it should read, so, by default, it used a special index card which points to the commit currently represented by the working directory. Git calls these index cards ◊technical-term{references} and the special reference which points to the commit currently represented by the working directory is called the ◊code/inline{HEAD}.

Many Git operations implicitly move the ◊code/inline{HEAD}, making it point to a different commit, for example, ◊reference['commits]{commit} and ◊reference['navigate-in-history]{checkout}. On the ◊acronym{GUI}, the ◊code/inline{HEAD} is represented by the yellow dot, as opposed to the blue dots. On the ◊acronym{CLI}, Git is more explicit and includes ◊code/inline{HEAD -> master} in the outputs of ◊code/inline{◊git/verb{log}} and ◊code/inline{◊git/verb{show}}. These outputs suggest that the special index card ◊code/inline{HEAD} is not the only kind of reference. In the ◊reference['branches]{next section}, we cover a second kind of reference, and finally solve the “detached ◊code/inline{HEAD}” mystery.

◊section['branches]{Branches}

◊margin-note{◊svg{images/branches.svg}}

◊new-thought{The working directory} currently represents our first commit, the cookies recipe in ◊code/inline{vegan-cookies.txt} only has “Ingredients” and no “Directions,” which we only introduced in the second commit. In other words, the ◊code/inline{HEAD} is the first commit. And Git needs an index card (reference) to find the start of the chain of boxes (commits) in the cabinet (repository). From the start, it can follow the chain backwards in time, because each box label contains a reference to its parent. But, when a box is created, it does not know who its children will be, so boxes cannot include references to them. As a result, the commit chain can only be navigated in one direction: backwards. Adding all this information together, we would expect the second commit to be inaccessible, as there is no path from ◊code/inline{HEAD} to it. Yet, the ◊code/inline{GUI} window showing the project history still includes the second commit. How can this be?

An indexing system composed of a single index card would be ineffective. We need more references then just ◊code/inline{HEAD}. In particular, we would like to create arbitrary index cards, pointing to arbitrary boxes, and refer to them by a keyword. For example, an index card could point to the box representing the main version of the project, and refer to it by the keyword ◊emphasis{master}. As ◊code/inline{HEAD} moves around, ◊emphasis{master} is preserved, and we can always come back to the canonical version of the project by ◊reference['navigate-in-history]{navigating to ◊emphasis{master}.}

◊margin-note{The name ◊code/inline{master} is just the default, and there is no special meaning ascribed to it, we could ask Git to use a branch named ◊code/inline{development}, for example.}

Git calls these arbitrary index cards ◊emphasis{branches}, for a reason which will become evident in a ◊reference['tree]{later section}. Moreover, Git is an office robot eager to please and has implicitly maintained a branch pointing to the canonical version of the project for us. Since we created the repository and committed twice, Git has been update this index card up-to-date without us having to ask for it. Also, conveniently, it has identified this branch using the keyword ◊code/inline{master}. In fact, the ◊code/inline{◊git/verb{status}} commands have been telling us that all along, saying “On branch master.”

We are finally in a position in which the “detached ◊code/inline{HEAD}” situation makes sense. When ◊code/inline{HEAD} points to a commit, it can do it directly, or indirectly by pointing to a branch which points to a commit. When we were ◊reference['read-history]{reading the history}, before we ◊reference['navigate-in-history]{navigated back to the first commit}, the ◊code/inline{◊git/verb{log}} and ◊code/inline{◊git/verb{show}} commands on the ◊acronym{CLI} outputted ◊code/inline{HEAD -> master}, which means we were in this latter state: ◊code/inline{HEAD} was pointing to the branch ◊code/inline{master}, which in turn was pointing to a commit. Then, we checked the first commit out, which made ◊code/inline{HEAD} point directly to it, there was no branch intermediating the pointer. This situation is what Git calls “detached ◊code/inline{HEAD}.”

◊margin-note{There is a potential solution to this problem of losing a commit for losing all references to it. Git comes with an advanced command called ◊code/inline{◊git/verb{reflog}}, which lists the commits at which ◊code/inline{HEAD} has recently pointed. If ◊code/inline{HEAD} has recently been pointing at the lost commit, then it is listed by ◊code/inline{◊git/verb{reflog}} and it is possible to copy its identifier and check it out. If enough time has passed, then Git might have run a periodic garbage collection routine, which permanently removes inaccessible commits from the repository. In that case the commit is unrecoverable.}

Besides the gross name, there is nothing wrong with the “detached ◊code/inline{HEAD}” state. It can be useful for exploring the history, conducting quick experiments and so forth. We can even commit while in “detached ◊code/inline{HEAD}” state, and Git will update the ◊code/inline{HEAD} reference automatically. But, if we checkout any other commit or branch after that, then there will be no other references pointing to this newly created commit. And, as mentioned earlier, we can only follow the chain of commits backwards in time, so ◊emphasis{commits created while in detached “detached ◊code/inline{HEAD}” state can become inaccessible and be lost forever}.

Git repositories are immutable and there are very few operations which might result in data loss. This is one of them, which is why Git was so loud when warning about the “detached ◊code/inline{HEAD}” state (and probably why it was so unfortunately named). ◊emphasis{Be careful to avoid data loss when in “detached ◊code/inline{HEAD}” state}. We can evade this situation avoid data loss by creating a new branch, and have it point at the same commit as ◊code/inline{HEAD}: the first commit.

To create a branch using the ◊acronym{GUI}, select the window for creating commits and use the menu option ◊emphasis{Branch} > ◊emphasis{Create…} A dialog will ask for the name of the branch and extra optional information:

◊figure["images/branch-create.png"]{The dialog for branch creation.}

Click on the ◊emphasis{Create} button to create a branch and check it out. Then go to the window showing the project history and use the menu option ◊emphasis{File} > ◊emphasis{Update}. The pane updates to show the newly created branch ◊code/inline{brownies}, which points to the first commit. The name ◊code/inline{brownies} is in bold letters, which means ◊code/inline{HEAD} is pointing to this branch, and the dot for this commit is yellow, informing that this still is the commit that the working directory represents. We are no longer in “detached ◊code/inline{HEAD}” state:

◊margin-note{◊svg{images/brownies-branch.svg}}

◊figure["images/history-after-branch-creation.png"]{The repository after creating a branch.}

On the ◊acronym{CLI}, create a branch using the ◊code/inline{◊git/verb{branch}} command:

◊code/block{
$ git ◊git/verb{branch} ◊git/object{brownies}
}

The silence on the output means the branch was successfully created, but checking the ◊code/inline{◊git/verb{status}} reveals that we are still in “detached ◊code/inline{HEAD}” state:

◊code/block{
$ git ◊git/verb{status}
HEAD detached at 30a7d90
nothing to commit, working tree clean
}

This happens because ◊code/inline{◊git/verb{branch}} command only creates the branch, it does not automatically check it out. An explicit ◊code/inline{◊git/verb{checkout}} command is necessary:

◊code/block{
$ git ◊git/verb{checkout} ◊git/object{brownies}
Switched to branch 'brownies'
}

Alternatively, the last two commands can be abbreviated with the ◊code/inline{◊git/object{-b}} option to the ◊code/inline{◊git/verb{checkout}} command:

◊code/block{
$ git ◊git/verb{checkout} ◊git/object{-b brownies}
Switched to a new branch 'brownies'
}

◊paragraph-separation[]

◊new-thought{Now it is possible} to navigate in history referring to the names of the branches, instead of the unique identifiers for the commits, which is more convenient. Moreover, the project can evolve in multiple directions at the same time, this is the subject of the ◊reference['tree]{next section}.

◊section['tree]{Tree}

◊margin-note{Readers that prefer the ◊acronym{GUI} should use a text editor and the steps from a ◊reference['commits]{previous section} to create commits and follow along.}

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

◊margin-note{◊svg{images/brownies-commit.svg}}

◊image["images/tree.png"]{A tree starting to form in the project history.}

The history of the project has diverged. The original timeline is still there, represented by the ◊code/inline{master} branch. It contains the full recipe for vegan cookies. Alternatively, on the ◊code/inline{brownies} branch, there is the recipe for vegan brownies, but the directions part of the cookies recipe is not there, because it was only added on the second commit of the main timeline. We can checkout the branches to navigate between these ◊informal{parallel universes} and see the differences:

◊margin-note{Branches in Git are just references to commits, not copies of the project, which makes them fast and cheap. This was an important feature that set Git apart from other version control systems and led to its popularity.}

◊margin-note{◊svg{images/tree.svg}}

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
  ◊figure{◊svg{images/merge.svg}}

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