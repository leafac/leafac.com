#lang pollen

◊define-meta[title]{Git by Analogy}
◊define-meta[date]{2017-07-06}

◊margin-note{To follow the command-line snippets, this article assumes familiarity with basic command line skills: moving around, creating directories and so forth. But following the command-line snippets is optional, one can use a ◊acronym{GUI} instead.}

◊new-thought{What does} ◊link["https://git-scm.com/"]{Git} do? How to start with Git? Where to learn more about Git? This article addresses these three questions; after reading it, the reader will not be an specialist in the tool, and will not have memorized commands, but will know the basic underlying concepts and how to perform the most commonly used operations. The space of educational material about Git is enormous, this article distinguishes itself for being directed by analogies which make the ideas relatable, and for exploring some of the ◊emphasis{whys}, going beyond the ◊emphasis{hows}.

◊section['what-does-git-do]{What does Git do?}

◊margin-note{Some tools have simple, embedded version control systems, for example, Google Docs allows traversing the history and comparing different versions of a file. Git is a more sophisticated version of this, with more features and supporting a whole project, instead of a single file.}

◊new-thought{Git solves} the problem of ◊technical-term{version control}. The name might sound unfamiliar, but the problem is not: keeping track of the changes in a project as it evolves, and collaborating on it with other people. The version control problem occurs whenever someone copies a file to modify it and compare the versions, sends a project as email attachment, or loses work due to a corrupted or accidentally deleted file. Git is a ◊technical-term{version control system}, which solves the version control problem by tracking the project’s history.

◊margin-note{
 The author uses Git in almost everything he does on the computer: from keeping ◊link/internal["/cooking"]{vegan recipes} to the preparation of this article. The person below does not.

 ◊no-indent[] ◊svg{filesystem-without-version-control.svg}
}

Most companies use some version control system, among which Git is the most popular. Also, most free-software projects use version control systems and accept contributions through them. So knowing Git is a highly marketable skill. Moreover, version control can improve overall quality of digital life: version diary entries, recipes, lecture notes, and any other personal project. No work will be lost for technical issues, and there will be a rich history of the progress over time to compare, explore and experiment with different versions of the project.

◊section['how-to-start-with-git]{How to start with Git?}

◊margin-note{This article does not cover technical issues that are system-dependent and change often, for example, how to install Git and ◊acronym{GUI} front-ends. Refer to the ◊link["https://www.git-scm.com/"]{tool’s website} for more on these topics.}

◊new-thought{There are two} main ways to learn Git: through the Command-Line Interface (◊acronym{CLI}) and through the Graphical User Interface (◊acronym{GUI}). The ◊acronym{GUI} serves as a front-end for the tool, it is more friendly and, for some advanced operations, it is more convenient. In day-to-day use of Git, a ◊acronym{GUI} is usually a better choice. But the ◊acronym{GUI} may not support all operations available in Git, or may have issues with big repositories. In some cases, a graphical environment is not available at all, for example, when accessing a remote server machine. Also, the ◊acronym{GUI} makes it harder to automate some tasks and generally does not interact well with scripts. So there are reasons to learn both the ◊acronym{CLI} and the ◊acronym{GUI}, as they offer different advantages and disadvantages.

◊margin-note{There are stand-alone Git ◊acronym{GUI}s and there are Git ◊acronym{GUI}s inside text editors. The latter are preferred, particularly for the most frequent tasks.}

In this tutorial, we show how to perform operations both with the ◊acronym{CLI} and with the ◊acronym{GUI}. While there is only one ◊acronym{CLI}, there are many choices of ◊link["https://www.git-scm.com/downloads/guis"]{◊acronym{GUI}}. The purpose of this article is communicate basic principles, which are skills that transfer to different scenarios, so we use the ◊acronym{GUI} that comes with Git. It is not the most good-looking ◊acronym{GUI}, but it is fully functional, cross-platform and requires no extra setup.

For the rest of this article, we cover the most common use cases for Git, organized by three overarching goals: (1) using Git alone on a local computer; (2) using Git with remote computers; and (3) using Git with collaborators.

◊full-width{
 ◊figure{◊svg{goals.svg}}
}

◊section['an-aside-about-github]{An Aside About GitHub}

◊margin-note{
 ◊svg{git-vs-github.svg}

 ◊no-indent[] GitHub is to Git as Gmail is to email. They are popular commercial tools which make the underlying technology easier to use and provide convenient extensions, but are not essential. One can use Git without GitHub the same way one can send emails from providers other than Gmail.
}

◊new-thought{It is a common} misconception among beginners that Git and ◊link["https://github.com"]{GitHub} are synonyms, or that Git is short for GitHub. They are not the same: Git is the tool, which is free software; and GitHub is a company and a commercial product built around Git which provides hosting and extended functionality. ◊reference['TODO]{In a later section}, when we discuss using Git with remote computers, we will use GitHub for the example because it is the most popular choice, but the distinction should be clear.

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

◊new-thought{Generally}, Git does not install shortcuts for the the ◊acronym{GUI}. Start it by running the following command line:

◊margin-note{For the reader who is only interested in the ◊acronym{GUI} portion of this article and wants to avoid the command-line, this is the only necessary command.}

◊code/inline{
$ git ◊git/verb{gui}
}

◊section['local-setup]{Local Setup}

◊new-thought{As we will see} later, one of Git’s features is to keep track of who did what work. So, after having installed Git but before running any commands, it is necessary to identify to Git, for example:

◊margin-note{On the ◊acronym{GUI}, go to ◊emphasis{Preferences} and fill in ◊emphasis{Gloal User Name} and ◊emphasis{Email Address}.}

◊margin-note{
  It is important to ◊emphasis{choose an email address that one owns forever}. Institutional emails are bad choices because, after the affiliation ends, the email address could be reassigned and the new owner would gain credit for all previous work.

  This issue is more important for contributions for public projects, but it is cumbersome to have multiple profiles and distinguish between personal work and institutional work. So, unless an institution insists on the use of their email address, avoid it.
}

◊code/block{
$ git ◊git/verb{config} ◊git/object{--global user.name "Wheatley"}
$ git ◊git/verb{config} ◊git/object{--global user.email "wheatley@aperture.com"}
}

The commands above modify the configuration file located at ◊code/inline{~/.gitconfig}. Besides identification, there is an optional setup step, regarding files which would never belong to any project, but are generated by the operation system, text editors and so forth. For example, macOS creates ◊code/inline{.DS_Store} files in each directory visiter with Finder, to store custom folder attributes. To configure Git to ignore those files:

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

◊code/block{
$ git ◊git/verb{status} 
fatal: Not a git repository (or any of the parent directories): .git
}

The result is a fatal error: Git cannot find the repository. The ◊reference['repository]{next section} explains what a repository is, and how to create one. The ◊acronym{GUI}, also detects that there is no repository:

◊image["gui-initial-screen.png"]{The initial screen.}

◊section['repository]{Repository}

◊margin-note{◊svg{desktop.svg}}

◊new-thought{Modern operating system’s} ◊acronym{GUI}s make an analogy to an office environment. First, there is a desktop with some files; and tools to work on them: text editors are analogous to pens and pencils, for example. Then, files can be organized into folders. If it is necessary to track the project’s history over time, one could use a copying machine to keep versions as they evolve. Soon this results in the situation mentioned ◊reference['what-does-git-do]{when introducing version control}: there are many different versions of any given file and it is difficult to inspect the differences, attribute the changes to different people in the project, collaborate and experiment. Unsurprisingly, the exact same issues arise when using the computer.

To address this problem in an office, people could try a new system: to make changes to the project, one has to log them in slips of paper, put them in a box, label the box, and put the box in a cabinet for storage. The label in the box contains the identification of the author of the changes, the current date and time, a high-level description of the contents, an unique identifier and a reference to the identifier of the previous box. This creates a chain of boxes that record the history of the project in an organized and predictable manner. In this system, there is only one copy of the files on which to work, but it is still possible to recreate the history and recollect who changed what, when and why, by looking in the boxes. To help organize their creation, there is a paper tray in which the modifications are collected prior to storing them in a box.

◊margin-note{◊svg{commit.svg}}

Maintaining this system is a lot of work, though, so it is desirable to have a tool for automating most of it. Git is that tool. It extends the office metaphor with a paper tray, labeled boxes and cabinets. The basic workflow is: (1) files in the project changed, either because some lines were added, or because some lines were removed, or whole files are added, for example; (2) those changes are organized in a paper tray; (3) the contents of the paper tray go into the box; (4) the box is labeled; and (5) the labeled box goes into the cabinet. Over the next sections we address each of these steps in detail.

◊paragraph-separation[]

◊new-thought{The first component} of this extended metaphor that we explore is the files and the folders, in which work happens. They correspond to the filesystem which already exists in the computer, and Git calls them the ◊technical-term{working directory}. Apart from this special terminology, there is nothing special about the ◊technical-term{working directory}; tools like text editors can work on these files oblivious of the version control system.

We select a directory to hold our project, which in our running example is a ◊link/internal["/cooking"]{vegan recipe cookbook}:

◊margin-note{In the ◊acronym{GUI} click on “Create New Repository.”}

◊code/block{
$ mkdir recipes
$ cd recipes/
}

◊paragraph-separation[]

◊margin-note{
  ◊svg{repository.svg}

  ◊no-indent[] An empty repository.
}

◊new-thought{Now that we have} a working directory, we need to inform Git that we are interested in tracking the history of this project. In particular, we command Git to create the ◊informal{cabinet}, which Git calls the ◊technical-term{repository}:

◊code/block{
$ git ◊git/verb{init} 
Initialized empty Git repository in .../recipes/.git/
}

As the output says, Git created an empty repository in a folder called ◊code/inline{.git} within our working directory. Because the name of this directory starts with a dot (◊code/inline{.}), it is ◊informal{hidden}. There is nothing special about hidden folders, but, by convention, file browsers generally do not show them unless explicitly requested. The ◊code/inline{.git} folder is Git’s ◊informal{cabinet} for this project; it contains files managed by Git and should not be edited by hand. Because of its existence, the status has changed:

◊full-width{
  ◊code/block{
$ git ◊git/verb{status} 
On branch master

  Initial commit  

nothing to commit (create/copy files and use "git add" to track)
  }
}

The ◊acronym{GUI} indicates that the repository has been created by showing the screen which we explore on a ◊reference['commit]{following section}:

◊image["repository-created.png"]{Repository created successfully.}

Git is longer complaining about the nonexistence of a repository, but it does mention two new concepts: ◊technical-term{branches} and ◊technical-term{commits}. We explore this terms in later sections, but first we need to consider some decisions regarding repository creation.

◊section['fine-points-about-repositories]{Fine Points About Repositories}

◊new-thought{What constitutes} a project, and, consequently, a repository? There is no definitive answer to this question. Consider, for example, a product composed of a front-end and a back-end: are they separate projects living in two repositories, or two parts of a single project under two folders of the same repository? People in charge of this decision have to consider the following information:

◊list/ordered{
  ◊list/ordered/item{
    It is monetarily cheap to create repositories. Most hosts, for example, GitHub, charge by the number of collaborators and the level of support, not by the number of repositories under an organization. (Other integrated tools, for example, continuous integration servers, might change per-repository, though.)
  }
  ◊list/ordered/item{
    It is technically cheap to create repositories. Git has optimized data structures and avoids costly operations, for example, maintaining copies of files. If a single file stands on its own, there could be repository just for it.
  }
  ◊list/ordered/item{
    It is complicated to manage access control within a repository. A person that has access to the repository has access to all the files in it and their whole history. It is easy to manage access control for whole repositories, though.
  }
  ◊list/ordered/item{
    It is complicated to synchronize the changes across different repositories.
  }
}

◊section['commit]{Commit}

◊margin-note{
  ◊svg{single-commit.svg}

  ◊no-indent[] A single commit.
}

◊new-thought{In our office analogy}, the ◊technical-term{commits} are the ◊informal{labeled boxes} which live in the cabinet (◊reference['repository]{repository}) and store the changes to the project. These changes start in the working directory, with text editors and other tools modifying the files. Let us then create our first recipe:

◊margin-note{Alternatively, instead of using the command-line, use a text editor or another tool to create a file in the working directory.}

◊code/block{
$ echo -e 'Delicious recipe\n\nIngredients ...' > vegan-cookies.txt
}

According to Git, this changed the status:

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

On the ◊acronym{GUI}, click on the “Rescan” button to see the new file listed under “Unstaged Changes”:

◊margin-note{
  ◊svg{changes-in-working-directory.svg}

  ◊no-indent[] The current state, in which there are changes (represented by ◊code/inline{+} and ◊code/inline{-}) in the working directory.
}

◊image["status-after-file-creation.png"]{Status after file creation.}

Both the ◊acronym{CLI} and the ◊acronym{GUI} are saying that a new file exists in the working directory, but it is not known by Git. It is an “untracked file,” which is an “unstaged change.” To introduce the new file to Git, the change representing its creation has to go into a box (commit). But, before this can happen, the changes have to be organized. This step is important, because not necessarily all the changes should go in the same box; and some of them might not go into boxes at all—they might be, for example, the result of a failed experiment.

The changes in the working directory are organized before going into labeled boxes using the ◊informal{paper tray}. Git calls it the ◊technical-term{staging area} or ◊technical-term{index}. We add changes to the index using the following command:

◊code/block{
$ git ◊git/verb{add} ◊git/object{vegan-cookies.txt }
}

◊margin-note{The reader interested in the ◊acronym{CLI} support for selectively adding changes to the index should refer to the ◊code/inline{◊git/object{--interactive}} option documented on the ◊code/inline{git-add(1)} manual page.}

This adds the whole file to the index, but it is possible to be more selective and add changes to the index line-by-line. The ◊acronym{CLI} has this feature, but the interface for it is cumbersome; the ◊acronym{GUI} is better. On the “Unstaged Changes” pane, click on the relevant file and the changes appear on the right pane; then right-click on the hunk or line of interest and use the “Stage Hunk For Commit” or “Stage Line For Commit” action.

◊margin-note{Unfortunately, on the ◊acronym{GUI} we are using, the option of selectively staging parts of a ◊emphasis{new} (untracked) file is unavailable. The example in the figure is from another repository in which there are changes in the working directory for a tracked file (one which Git already knows about). Other ◊acronym{GUI}s have this feature.}

◊image["selective-staging.png"]{Selective staging.}

◊; TODO: Explain we want to commit whole file, so how do we stage it?

◊; TODO: Explain ‘git commit’.

◊figure{◊svg{commit-legend.svg}}

◊; TODO: ◊section['where-to-learn-more-about-git]{Where to Learn More About Git?}