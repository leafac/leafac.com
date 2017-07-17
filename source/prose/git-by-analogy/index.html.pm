#lang pollen

◊define-meta[title]{Git by Analogy}
◊define-meta[date]{2017-07-06}

◊margin-note{To follow the command-line snippets, this article assumes familiarity with basic command line skills: navigating the filesystem, creating directories and so forth. But following the command-line snippets is optional, one can use a ◊acronym{GUI} instead.}

◊new-thought{What does} ◊link["https://git-scm.com/"]{Git} do? How to start with Git? Where to learn more about Git? This article addresses these three questions; the purpose is not turn the reader into an specialist, but to explore the basic underlying concepts and the most commonly used operations. The space of educational material about Git is enormous, this article distinguishes itself for being directed by analogies which make the ideas relatable, and for exploring some of the ◊emphasis{whys}, going beyond the ◊emphasis{hows}.

◊section['what-does-git-do]{What does Git do?}

◊margin-note{Some tools have simple, embedded version control systems, for example, Google Docs allows traversing the history and comparing different versions of a file. Git is a more sophisticated version of this, with more features and support for a whole project, instead of a single document.}

◊new-thought{Git solves} the problem of ◊technical-term{version control}. The name might sound unfamiliar, but the problem is not: keeping track of the changes in a project as it evolves, and collaborating on it with other people. The version control problem occurs whenever someone copies a file to modify it and compare the versions, sends a project as an email attachment, or loses work due to a corrupted or accidentally deleted file. Git is a ◊technical-term{version control system}, which solves the version control problem by tracking the project’s history.

◊margin-note{
 The author uses Git in almost everything he does on the computer: from keeping ◊link/internal["/cooking"]{vegan recipes} to the preparation of this article. The person below does not.

 ◊no-indent[] ◊svg{filesystem-without-version-control.svg}
}

Most companies use some version control system, Git being the most popular choice. Also, most free-software projects use version control systems and accept contributions through them. So knowing Git is a highly marketable skill. Moreover, version control can improve overall quality of digital life: version diary entries, recipes, lecture notes, and any other personal projects. Git users do not lose work for technical issues, and have a rich history of the progress over time to compare, explore and experiment with different versions of a project.

◊section['how-to-start-with-git]{How to start with Git?}

◊margin-note{This article does not cover technical issues that are system-dependent and change often, for example, how to install Git and ◊acronym{GUI} front-ends. Refer to the ◊link["https://www.git-scm.com/"]{tool’s website} for more on these topics.}

◊new-thought{There are two} main ways to learn and use Git: through the Command-Line Interface (◊acronym{CLI}) and through the Graphical User Interface (◊acronym{GUI}). The ◊acronym{GUI} serves as a front-end for the tool; it is more friendly and, for some operations, it is more convenient. In everyday Git usage, a ◊acronym{GUI} is usually a better choice. But the ◊acronym{GUI} may not support all operations available in Git, or may have issues with big repositories. In some cases, a graphical environment is not available at all, for example, when accessing a remote server machine. Also, the ◊acronym{GUI} makes it harder to automate some tasks and generally does not interact well with scripts. So there are reasons to learn both the ◊acronym{CLI} and the ◊acronym{GUI}, as they offer different advantages and disadvantages.

◊margin-note{There are stand-alone Git ◊acronym{GUI}s and there are Git ◊acronym{GUI}s inside text editors. The latter are preferred, particularly for the most frequent operations.}

In this tutorial, we show how to perform operations both with the ◊acronym{CLI} and with the ◊acronym{GUI}. While there is only one ◊acronym{CLI}, there are many choices of ◊link["https://www.git-scm.com/downloads/guis"]{◊acronym{GUI}s}. The purpose of this article is communicate basic principles, which are skills that transfer to different ◊acronym{GUI}s, so we use the ◊acronym{GUI} that comes with Git. It is not the most good-looking option, but it is fully functional, cross-platform and requires no extra setup.

For the rest of this article, we cover the most common use cases for Git, organized by three overarching goals: (1) using Git alone on a local computer; (2) using Git with remote computers; and (3) using Git with collaborators.

◊full-width{
 ◊figure{◊svg{goals.svg}}
}

◊section['an-aside-about-github]{An Aside About GitHub}

◊margin-note{
 ◊svg{git-vs-github.svg}

 ◊no-indent[] GitHub is to Git as Gmail is to email. They are popular commercial tools which make the underlying technology easier to use and provide convenient extensions, but are not essential. One can use Git without GitHub the same way one can send emails from providers other than Gmail.
}

◊new-thought{It is a common} misconception among beginners that Git and ◊link["https://github.com"]{GitHub} are synonyms, or that Git is short for GitHub. But they are not the same: Git is the tool, which is free software; and GitHub is a company and a commercial product built around Git which provides hosting and extended functionality. ◊reference['TODO]{In a later section}, when we discuss using Git with remote computers, we will use GitHub because it is the most popular choice, but the distinction should be clear.

◊; TODO: Fix the reference in the paragraph above.

◊section['an-aside-about-git-commands]{An Aside About Git Commands}

◊new-thought{Git provides} many distinct operations under the ◊code/inline{git} executable, which is called in a way that resembles natural language, for example:

◊figure{◊svg{grammar.svg}}

In general, Git commands follow the pattern:

◊margin-note{By convention, command lines are prefixed with ◊code/inline{$} and comments with ◊code/inline{#}.}

◊code/block{
$ git ◊git/verb{verb} ◊git/object{objects-and-options ...}
}

◊section['an-aside-about-the-gui]{An Aside About the ◊acronym{GUI}}

◊new-thought{Generally}, Git does not install desktop shortcuts for the ◊acronym{GUI}. Start it by running the following command line:

◊margin-note{For the reader who is only interested in the ◊acronym{GUI} portion of this article and wants to avoid the command-line, this is the only necessary command.}

◊code/inline{
$ git ◊git/verb{gui}
}

◊section['local-setup]{Local Setup}

◊new-thought{As we will see} later, one of Git’s features is to attribute work to different collaborators in a project. So it is necessary to identify to Git, even if one does not plan to use Git for collaboration. After having installed Git but before running any commands, run the following commands:

◊margin-note{Replace the ◊code/inline{◊git/object{<placeholders>}} with the actual information.}

◊margin-note{On the ◊acronym{GUI}, go to ◊emphasis{Preferences} and fill in ◊emphasis{Gloal User Name} and ◊emphasis{Email Address}.}

◊margin-note{
  It is important to ◊emphasis{choose an email address that one owns forever}. Institutional emails are bad choices because, after the affiliation ends, the email address could be reassigned and all the previous work under that name would be attributed to the new person.

  This issue is more important for contributions for public projects, but it is cumbersome to have multiple profiles and distinguish between personal work and institutional work. So, unless an institution insists on the use of their email address, avoid it.
}

◊code/block{
$ git ◊git/verb{config} ◊git/object{--global user.name "<name>"}
$ git ◊git/verb{config} ◊git/object{--global user.email "<email>"}
}

The commands above modify the configuration file located at ◊code/inline{~/.gitconfig}. Besides identification, there is an optional but highly recommended setup step, regarding files which would never belong to any project, but are generated by the operation system, text editors and so forth. For example, macOS creates ◊code/inline{.DS_Store} files in each directory visiter with Finder, to store custom folder attributes. To configure Git to ignore those files, first run:

◊code/block{
$ git ◊git/verb{config} ◊git/object{--global core.excludesfile ~/.gitignore}
}

Then add to ◊code/inline{~/.gitignore} the patterns for the files which should be ignored, for example:

◊code/block{
$ echo ".DS_Store" >> ~/.gitignore
$ echo "*.text-editor-temporary-file" >> ~/.gitignore
}

◊section['first-git-command]{First Git Command}

◊new-thought{The most useful} Git command asks it to report the current status. Run the following ◊reference['local-setup]{after setting up}:

◊full-width{
  ◊code/block{
$ git ◊git/verb{status} 
fatal: Not a git repository (or any of the parent directories): .git
  }
}

The result is a fatal error: Git cannot find the repository. The ◊acronym{GUI}, also detects that there is no repository:

◊image["gui-initial-screen.png"]{The initial screen.}

The next sections explain what is a repository, and how to create one.

◊section['office]{Office}

◊margin-note{
  ◊svg{desktop.svg}

  ◊no-indent[] The office metaphor on a desktop.
}

◊new-thought{Modern operating system’s} ◊acronym{GUI}s make an analogy to an office environment. There is a desktop with some files organized in folders, and tools to work on them: text editors are analogous to pens and pencils, for example. Let us then consider an office environment in which it is necessary to track a project’s history over time. One could use, for example, a copying machine to record different versions as files change. Soon, this results in the situation mentioned ◊reference['what-does-git-do]{when introducing version control}: there are many different versions of any given file and it is difficult to inspect the differences, attribute the changes to different people in the project, collaborate and experiment. Unsurprisingly, these are the exact same issues that arise when using the computer.

To address this problem in an office, one could try a new system. After changing a file, one would take note of the change in a slip of paper, mentioning what was the previous content and what is the new content. One could use a paper tray to organize these slips of paper. After significant progress—which might mean anything from changing a single line to changing dozens of files—one could move these slips of paper into a box, label the box, and put the box in a cabinet for storage. The label on the box would contain the identification of the author of the changes, the current date and time, a high-level description of the box contents, an unique identifier for the current box and a reference to the identifier of the previous box.

◊margin-note{
  ◊svg{office.svg}

  ◊no-indent[] The extended office metaphor for version control, with Git as a robot in the middle managing the process.
}

With this system, the result would be a chain of boxes that record the history of the project in an organized and predictable manner. There is still only one working copy of the files, but it is possible to recreate the project’s history and recollect who changed what, when and why, by looking at the boxes.

Maintaining this system is a lot of work, though. To recover the state of the files at a particular moment, it is necessary to look in the cabinet for the relevant series of boxes, open each of them in order and apply the recorded changes to the files. To find who is responsible for a particular change, one has to open several boxes to find the relevant slip of paper. It would be desirable to have a robot to manage these processes.

In the computer, this robot is Git. It extends the office analogy of files and folders in the filesystem with metaphorical slips of paper to record changes, a paper tray, labeled boxes and a cabinet. Over the course of this article, we will learn about each of these components, their technical names in Git’s lexicon and the basic operations on them.

◊section['working-directory]{Working Directory}

◊margin-note{
  ◊svg{working-directory.svg}

  ◊no-indent[] The working directory.
}

◊new-thought{The first component} of this analogy that we explore is the files and the folders, in which work happens. They correspond to the filesystem which already exists in the computer, and Git calls them the ◊technical-term{working directory}. Apart from this special terminology, there is nothing special about the ◊technical-term{working directory}; tools like text editors can work on these files oblivious of the version control system.

We start by creating a directory to contain our project, which in our running example is a ◊link/internal["/cooking"]{vegan recipe cookbook}:

◊margin-note{On the ◊acronym{GUI}, use a file browser to create a directory.}

◊code/block{
$ mkdir recipes
$ cd recipes/
}

◊section['repository]{Repository}

◊margin-note{
  ◊svg{repository.svg}

  ◊no-indent[] The empty repository.
}

◊new-thought{Now that we have} a working directory, we need to inform Git that we are interested in tracking the history of this project. In particular, we command Git to create the ◊informal{cabinet}, which it calls the ◊technical-term{repository}:

◊margin-note{In the ◊acronym{GUI} click on ◊technical-term{Create New Repository}.}

◊code/block{
$ git ◊git/verb{init} 
Initialized empty Git repository in .../recipes/.git/
}

As the output says, Git created an empty repository in a folder called ◊code/inline{.git} within project’s directory. Because the name of this folder starts with a dot (◊code/inline{.}), it is ◊informal{hidden}. There is nothing special about hidden folders, but, by convention, file browsers generally do not show them unless explicitly requested. The ◊code/inline{.git} folder is Git’s ◊informal{cabinet} for this project; Git manages its contents, which should not be edited by hand. Due to the existence of this folder, the status has changed:

◊full-width{
  ◊code/block{
$ git ◊git/verb{status} 
On branch master

  Initial commit  

nothing to commit (create/copy files and use "git add" to track)
  }
}

The ◊acronym{GUI} indicates that the repository has been created by showing the screen which we explore in a ◊reference['commit]{later section}:

◊image["repository-created.png"]{Repository created successfully.}

Git is longer complaining about the nonexistence of a repository, but it does mention two new concepts: ◊technical-term{branches} and ◊technical-term{commits}. We explore these terms in later sections, but first we need to consider some trade-offs regarding repository creation.

◊section['fine-points-about-repositories]{Fine Points About Repositories}

◊new-thought{What constitutes} a project, and, consequently, a repository? There is no definitive answer to this question. Consider, for example, a product composed of a front-end and a back-end; are they separate projects living in two repositories, or two parts of a single project under two folders of the same repository? People in charge of this decision have to consider the following information:

◊list/ordered{
  ◊list/ordered/item{
    It is monetarily cheap to create repositories. Most hosts, for example, GitHub, charge by the number of collaborators and the level of support, not by the number of repositories under an organization. (Other integrated tools, for example, continuous integration servers, might charge per-repository, though.)
  }
  ◊list/ordered/item{
    It is technically cheap to create repositories. Git has optimized data structures and avoids costly operations, for example, it avoids maintaining copies of files. If a single file stands on its own, there could be repository just for it.
  }
  ◊list/ordered/item{
    It is complicated to manage access control within a repository. A person that has access to the repository has access to all the files in it and their whole history. It is easy to manage access control for whole repositories, though.
  }
  ◊list/ordered/item{
    It is complicated to synchronize the changes across different repositories.
  }
}

◊section['changes]{Changes}

◊margin-note{
  ◊svg{changes.svg}

  ◊no-indent[] The changes.
}

◊new-thought{As the project} evolves, people modify the files in the working directory. On our extended office metaphor for version control, this requires taking notes of what changed in slips of paper. For example, to modify a line in a file, it is necessary to register the previous contents of that line as well as the new contents. This is a non-trivial amount of work, but fortunately we have Git as our robot managing the tedious parts. Its first task is to detect changes in the working directory.

Currently, our working directory is empty. Let us start by creating a file to contain our first recipe. We can use text editors or any other tool that works on files. If using the command line, run the following:

◊code/block{
$ echo -e 'Ingredients\n\n...\n\n' > vegan-cookies.txt
}

This creates a file name ◊code/inline{vegan-cookies.txt}, which contains the (elided) list of ingredients for ◊link/internal["/cooking/chocolate-chip-cookie/"]{vegan cookies}. Git notices this change, as the following status reveals:

◊full-width{
  ◊code/block{
$ git ◊git/verb{status}
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	vegan-cookies.txt

nothing added to commit but untracked files present (use "git add" to track)
  }
}

On the ◊acronym{GUI}, click on the ◊technical-term{Rescan} button to see the new file listed under ◊technical-term{Unstaged Changes}:

◊image["status-after-file-creation.png"]{Status after file creation.}

Both the ◊acronym{CLI} and the ◊acronym{GUI} are saying that a new file exists in the working directory, but it is not known by Git. It is an “untracked file,” which is an “unstaged change.” But these messages about files are just for user convenience; internally, Git does not reason directly about files or directories, but about ◊emphasis{changes}. This is why, in the analogy, we do not represent changes with complete files, but with scraps of paper containing ◊code/inline{+} and ◊code/inline{-} to represent additions and deletions.

◊section['staging-area]{Staging Area}

◊margin-note{
  ◊svg{staging-area.svg}

  ◊no-indent[] The staging area.
}

◊new-thought{To introduce the new file} to Git, the first step is to add to the paper tray the slip of paper representing the file creation. Later, these scraps of paper will be the contents of a box, which will be part of the project’s history. This intermediary step is important, because it is on the paper tray that we organize the changes into a set that makes sense together. We do not always want to add all the changes in the working directory to the paper tray. Some of them might never go the paper tray at all—they might be, for example, the result of a failed experiment, which we do not want as part of the project’s history.

◊margin-note{The reader interested in the ◊acronym{CLI} support for selectively adding changes to the index should refer to the ◊code/inline{◊git/object{--interactive}} option documented on the ◊link["https://git-scm.com/docs/git-add#git-add---interactive"]{◊code/inline{git-add(1)}} manual page.}

It is possible to be selective and add changes to the index line-by-line. The ◊acronym{CLI} has this feature, but the interface for it is cumbersome; the ◊acronym{GUI} is better. On the ◊technical-term{Unstaged Changes} pane, click on the relevant file and the changes appear on the right pane; then right-click on the hunk or line of interest and use the ◊technical-term{Stage Hunk For Commit} or the ◊technical-term{Stage Line For Commit} action.

◊margin-note{Unfortunately, on the ◊acronym{GUI} we are using, the option of selectively staging parts of a ◊emphasis{new} (untracked) file is unavailable. The example in the figure is from another repository in which there are changes in the working directory for a tracked file (one which Git already knows about). Other ◊acronym{GUI}s have this missing feature.}

◊image["selective-staging.png"]{Selective staging.}

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

◊section['commit]{Commit}

◊margin-note{
  ◊svg{commit.svg}

  ◊no-indent[] A single commit.
}

◊new-thought{In our office analogy}, the ◊technical-term{commits} are the ◊informal{labeled boxes} which live in the cabinet (◊reference['repository]{repository}) and store the changes to the project.

At this point, the changes are organized on the ◊informal{paper tray} and ready to go into the box. To finish the process, we have to create the label, which is composed of:

◊list/ordered{
  ◊list/ordered/item{Information about the author including name and email.}
  ◊list/ordered/item{The current date and time.}
  ◊list/ordered/item{An unique identifier.}
  ◊list/ordered/item{A reference to the identifier of the previous box in the chain (except for this first commit, which starts the chain).}
  ◊list/ordered/item{A high-level description of the contents.}
}

◊margin-note{The ◊reference['local-setup]{setup} process of identifying to Git was necessary to make the automatic parts of labeling work.}

All information except for the last are added to the label automatically by Git. The commit author has to provide a description of its contents; on the ◊acronym{GUI}, this goes on the bottom-right pane:

◊figure{◊svg{commit-legend.svg}}

The equivalent on the ◊acronym{CLI} is the following:

◊code/block{
$ git ◊git/verb{commit }
}

◊margin-note{
  On most machines, the default text editor is ◊link["TODO"]{Vim}. Configure the text editor that Git uses with:

  ◊code/block{
$ git ◊git/verb{config} \
  ◊git/object{--global core.editor "<EDITOR>"}
  }

  In many cases—particularly for ◊acronym{GUI} text editors—one has to provide a flag to the text editor process for it to work well with Git. For example, for Atom, one has to use ◊code/inline{◊git/object{"atom --wait"}}.
}

◊; TODO: Fix link above.

After running this command, Git starts a text editor with a special file already open. One has to write the commit description on that file.

To finally create the commit, on the ◊acronym{CLI} one has to close the special file that Git opened in the text editor for writing the commit message. Git will then print some statistics about the commit:

◊code/block{
".git/COMMIT_EDITMSG" 10L, 250C written 
[master (root-commit) cff98a54] Add cookies recipe 
 1 file changed, 1 insertion(+)
  create mode 100644 vegan-cookies.txt
}

On the ◊acronym{GUI}, one clicks on ◊technical-term{Commit}, and the status bar indicates success:

◊margin-note{The word “commit” can be a noun, meaning the box containing changes, or a verb, meaning the act of creating the box.}

◊image["after-first-commit.png"]{After first commit.}

Now our cabinet (repository) contains the first labeled box (commit). The paper tray (staging area) is empty and Git gives as a new empty box to fill with the next changes to the project. Asking for the current status confirms that:

◊code/block{
$ git ◊git/verb{status}
On branch master
nothing to commit, working tree clean
}

◊paragraph-separation[]

◊new-thought{This section} has been slow and detailed, but creating a commit is a low overhead operation—specially if there is Git support integrated in the text editor. The following sequence of commands condenses the topics of this section: first, it modifies a file, simulating work on the project; then, it adds the modification to the index (the ◊code/inline{◊git/object{-a}} option); finally, it creates a commit with a given message (the ◊code/inline{◊git/object{-m}} option). For convenience, ◊code/inline{git ◊git/verb{add}} and ◊code/inline{git ◊git/verb{commit}} have been performed in a single command, using the option ◊code/inline{◊git/object{-a}}, which adds all changes to the index:

◊margin-note{On the ◊acronym{GUI}, repeat the process above: modify the file using a text editor, add the modification to the index, write a message and click on ◊emphasis{Commit}.}

◊code/block{
$ echo -e "Directions\n...\n" >> vegan-cookies.txt
$ git ◊git/verb{commit} ◊git/object{-am "Add directions"}
}

◊; NEXT: Rinse and repeat, do a bunch more of commits.

◊; TODO: ◊section['where-to-learn-more-about-git]{Where to Learn More About Git?}