#lang pollen

◊define-meta[title]{Email Migration: The Ultimate Solution to a Ridiculous Problem}
◊define-meta[date]{2017-08-05}

◊margin-note{This article assumes familiarity with the command-line.}

◊margin-note{I personally experienced all the issues listed here in a recent email migration.}

Migration tools in email clients do not work. Most applications, for example, ◊link["https://www.mozilla.org/en-US/thunderbird/"]{Thunderbird} and ◊link["https://support.apple.com/mail"]{Apple Mail}, come with assistants to import the email archives from other applications. These features do not work: they lose email; concatenate all history in a single giant email; create a new mailbox for each individual message, breaking the organization system; and so forth. This is frustrating, because email migration was supposed to be a solved problem: standard email exchange formats do exist, ◊code/inline{.eml} and ◊code/inline{.mbox} files being the most common examples. Unfortunately, problems arise because every application has a slightly different understanding of those formats. This is a ◊emphasis{ridiculous} problem.

Besides assistants in email clients themselves, there exist many tools for converting between message formats. Unfortunately, they generally are not well maintained or paid products. However, there is an alternative, simple solution: while email clients might not agree on the storage formats, they must all talk the same protocols to email servers! The source client can upload messages to the server, and the target client can download them. This method might not preserve tags and other client-specific advanced features. But it preserves the ◊emphasis{read} status, the folder structure, and other fundamental attributes of email archives. Moreover, this method is guaranteed to work regardless of the email clients involved.

In fact, people on the Internet have suggested this method before. And they recommend using the email provider the person already has, for example, ◊link["https://www.google.com/gmail/"]{Gmail} or ◊link["https://www.icloud.com"]{iCloud}. This is simple to setup, because it just reuses the configuration already in the email client. For this simplicity, it is the most recommended approach to people not familiar with the command-line. But it has an important drawback: it involves uploading and re-downloading the whole message history! Depending on the size of the history, this can take days. It is a ◊emphasis{ridiculous} solution.

◊paragraph-separation[]

In this article, we introduce an alternative that brings together the two non-solutions discussed above. ◊emphasis{It is the ultimate solution to the ridiculous problem of email migration}. It is a compromise between running conversion tools locally and using a remote email server to intermediate the migration: ◊emphasis{setup a temporary local email server}.

◊figure{◊svg{images/migration.svg}}

◊section['setup]{Setup}

Backup the mailboxes! Problems during migration might result in data loss!

Install ◊link["https://www.dovecot.org"]{Dovecot}, which is our temporary email server for the migration. On ◊link["https://www.apple.com/macos/"]{macOS}, for example, use ◊link["https://brew.sh"]{Homebrew}:

◊code/block{
$ brew install dovecot
}

Create a directory to hold the temporary Dovecot mailboxes:

◊code/block{
$ mkdir ◊placeholder{migration-directory}
}

◊section['configure]{Configure}

◊margin-note{The location of the ◊path{dovecot.conf} file depends on the installation. The given path works for the installation using Homebrew, another common location is ◊path{/etc/dovecot/dovecot.conf}.}

◊margin-note{See the ◊reference['dovecot-configuration-explained]{appendix} for more details on this configuration file.}

Configure Dovecot with a ◊path{dovecot.conf} file, by  replacing the ◊code/inline{◊placeholder{placeholders}} in the following template:

◊file-listing["/usr/local/etc/dovecot/dovecot.conf"]{
protocols = imap

default_login_user = ◊placeholder{user}
default_internal_user = ◊placeholder{user}

userdb {
  driver = static
  args = uid=◊placeholder{user} gid=◊placeholder{group}
}

passdb {
  driver = static
  args = password=◊placeholder{password}
}

mail_uid = ◊placeholder{user}
mail_gid = ◊placeholder{group}
mail_location = maildir:◊placeholder{migration-directory}

namespace inbox {
  inbox = yes
}

log_path = /dev/stderr
auth_verbose = yes
auth_verbose_passwords = yes
auth_debug = yes
auth_debug_passwords = yes
mail_debug = yes
verbose_ssl = yes
}

Use ◊code/inline{id(1)} to identify the ◊code/inline{◊placeholder{user}} and  the ◊code/inline{◊placeholder{group}}. For example, in my case, the ◊code/inline{◊placeholder{user}} is ◊code/inline{leafac} and the ◊code/inline{◊placeholder{group}} is ◊code/inline{staff}:

◊code/block{
$ id
uid=501(leafac) gid=20(staff) [...]
}

Choose an arbitrary ◊code/inline{◊placeholder{password}} and use the ◊path{◊placeholder{migration-directory}} created during ◊reference['setup]{setup}.

◊section['migrate]{Migrate}

Start the migration email server:

◊margin-note{
  The path to the ◊code/inline{dovecot(1)} executable depends on the installation. The given path works for the installation using Homebrew, another common location is ◊path{/usr/sbin/dovecot}.

  The call to ◊code/inline{ulimit} is necessary because Dovecot wants to be able to open more than 256 files, the default limit.

  The call to ◊code/inline{sudo} is necessary because Dovecot needs to bind to a network port below 1024—specifically, the port for ◊initialism{IMAP}, 143.

  The ◊code/inline{-F} flag for Dovecot tells it to run on the foreground, instead of becoming a daemon. This makes it easy to see the logs as the server runs, and to kill it with ◊keyboard{Ctrl} + ◊keyboard{C}.
}

◊code/block{
$ ulimit -n 1024 && sudo /usr/local/sbin/dovecot -F
}

Confirm that email server is running correctly by inspecting the startup log messages and the contents of the ◊path{◊placeholder{migration-directory}}, Dovecot must have created its administration files and directories there. In case of error, review the steps thus far.

Connect your email clients, for example, Thunderbird and Apple Mail to this temporary email server:

◊margin-note{Some email clients insist on having a server to send emails (◊initialism{SMTP}). Let this part of the configuration fail or reuse the outgoing email configuration from other accounts.}

◊margin-note{
  If it is necessary to change Dovecot’s configuration from the ◊reference['configure]{previous section}, restart the server or run the following command on a separate terminal:

  ◊code/block{
$ sudo doveadm reload
  }
}

◊margin-note{Ignore any warnings from the email client saying that the connection is not secure. We do not need a secure connection for this local migration process, so we did not setup Dovecot securely.}

◊table{
  ◊table/body{
    ◊table/row{◊table/data{Email address} ◊table/data{◊code/inline{◊placeholder{user}@localhost}}}
    ◊table/row{◊table/data{Server} ◊table/data{◊code/inline{localhost}}}
    ◊table/row{◊table/data{Protocol} ◊table/data{◊initialism{IMAP}}}
    ◊table/row{◊table/data{Port} ◊table/data{143}}
    ◊table/row{◊table/data{User} ◊table/data{◊code/inline{◊placeholder{user}}}}
    ◊table/row{◊table/data{Password} ◊table/data{◊code/inline{◊placeholder{password}}}}
  }
}

On the source email client, move emails from the local folders to the temporary server. Wait for completion and then, on the target email client, move emails from the temporary server to local folders. Wait for completion again. To guarantee that the process succeeded, close the email clients so that they commit pending transactions to the server and check the ◊path{◊placeholder{migration-directory}}, it should contain only empty directories and Dovecot’s administration files.

◊section['teardown]{Teardown}

After the migration is complete, remove the configurations connecting the email clients to the temporary email server. Then, stop the server by killing the process or running the following command on a separate terminal:

◊code/block{
$ sudo doveadm stop
}

Finally, remove Dovecot’s configuration and ◊path{◊placeholder{migration-directory}}, and uninstall it:

◊margin-note{Again, the location of ◊path{dovecot.conf} varies, be consistent with the choice made at ◊reference['configuration]{configuration}.}

◊code/block{
$ rm /usr/local/etc/dovecot/dovecot.conf
$ rm -rf ◊placeholder{migration-directory}
$ brew uninstall dovecot
}

◊appendix['dovecot-configuration-explained]{Dovecot configuration explained}

◊margin-note{Refer to Dovecot’s manual for more details on each individual configuration option.}

Dovecot supports many kinds of services, for example, the ◊initialism{IMAP} and ◊initialism{POP3} email server protocols, and authentication for other applications. In our temporary email server, we only want the ◊initialism{IMAP} service:

◊code/block{
protocols = imap
}

Usually email servers support multiple users and have to manage a database with their credentials. This database management might need to collaborate with other applications, for example, a web-client which allows users to change their passwords. We do not want this complexity, so we hard-code in the configuration file the credentials for a single user, ourselves:

◊margin-note{Dovecot is not a single process, but a collection of processes. They perform specific tasks and drop to only the necessary privileges, which enhances security and stability. Here we configure some of these processes to run as our user, which prevents permission problems with the files and directories Dovecot generates in the ◊path{◊placeholder{migration-directory}}.}

◊code/block{
default_login_user = ◊placeholder{user}
default_internal_user = ◊placeholder{user}

userdb {
  driver = static
  args = uid=◊placeholder{user} gid=◊placeholder{group}
}

passdb {
  driver = static
  args = password=◊placeholder{password}
}
}

When Dovecot has identified the user, it needs to find the corresponding mailbox. Again, we hard-code the location in the configuration file:

◊code/block{
mail_uid = ◊placeholder{user}
mail_gid = ◊placeholder{group}
mail_location = maildir:◊placeholder{migration-directory}

namespace inbox {
  inbox = yes
}
}

Finally, we enable logging in the most verbose level, to help find configuration issues. Also, we change the log path to ◊path{/dev/stderr} so that we can read it while running Dovecot on the foreground:

◊code/block{
log_path = /dev/stderr
auth_verbose = yes
auth_verbose_passwords = yes
auth_debug = yes
auth_debug_passwords = yes
mail_debug = yes
verbose_ssl = yes
}