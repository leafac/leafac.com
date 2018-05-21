---
layout: default
title: "Email Migration: The Ultimate Solution to a Ridiculous Problem"
date: 2018-05-21
---

<aside markdown="1">
**Pre-requisites**: Familiarity with the command-line.
</aside>

We switch email clients from time to time, and when we do, we need to migrate the local email history from one application to the other. This may seem easy, because email clients generally include migration assistants and store emails in standard formats, for example, `.eml` and `.mbox`. But recently I was migrating from [Thunderbird](https://www.mozilla.org/en-US/thunderbird/) to [Apple Mail](https://support.apple.com/mail) and these tools failed: they lost emails, concatenated all emails together, or created a new mailbox for each email.

Email migration is a ridiculous problem, and we introduce the ultimate solution: setting up a local email server. An email server is the common denominator between otherwise incompatible email clients, but common email servers (for example, [iCloud](https://www.icloud.com) and [Gmail](https://www.google.com/gmail/)) are impractical for email migration. While simpler to use, these email servers would require us to upload our whole local email history only to re-download it in a new email client. With a local email server we accelerate an email migration that could take days to a few hours.

<figure markdown="1">
{% include_relative migration.svg %}
<figcaption markdown="1">
**Left**: Migrating the local email history using the migration assistant fails.  
**Center**: Migrating using common email servers (for example, iCloud and Gmail) succeeds, but is impractical.  
**Right**: Our solution, migrating using a local email server (Dovecot), works best.
</figcaption>
</figure>

Our technique on a high level:

1. Install and configure a local email server.
2. Connect both the old and the new email clients to the local email server.
3. Transfer the local email history from the old email client to the local email server.
4. Transfer the local email history from the local email server to the new email client.
5. Stop and uninstall the email server.

Setup
=====

**Backup your local email history. You might lose emails if the migration fails.**

* * *

First, install the local email server, [Dovecot](https://www.dovecot.org). For example, in [macOS](https://www.apple.com/macos/), Dovecot is available via [Homebrew](https://brew.sh):

```
$ brew install dovecot
```

Create a directory to hold the temporary Dovecot mailboxes:

<pre>
$ mkdir <span class="placeholder" markdown="1">\<migration-directory></span>
</pre>

<aside markdown="1">
See the [appendix](#appendix-dovecot-configuration) for more details on `dovecot.conf`.
</aside>
<aside markdown="1">
The path to `dovecot.conf` depends on the installation. For macOS and Homebrew, the appropriate path is `/usr/local/etc/dovecot/dovecot.conf`. Another path appropriate for many installations is `/etc/dovecot/dovecot.conf`.
</aside>

Configure Dovecot by replacing the <span class="placeholder" markdown="1">\<placeholders></span> on the following template:

<div class="code-block" markdown="1">
/usr/local/etc/dovecot/dovecot.conf
<pre>
protocols = imap

default_login_user = <span class="placeholder" markdown="1">\<user></span>
default_internal_user = <span class="placeholder" markdown="1">\<user></span>

userdb {
  driver = static
  args = uid=<span class="placeholder" markdown="1">\<user></span> gid=<span class="placeholder" markdown="1">\<group></span>
}

passdb {
  driver = static
  args = password=<span class="placeholder" markdown="1">\<password></span>
}

mail_uid = <span class="placeholder" markdown="1">\<user></span>
mail_gid = <span class="placeholder" markdown="1">\<group></span>
mail_location = maildir:<span class="placeholder" markdown="1">\<migration-directory></span>

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
</pre>
</div>

- <span class="placeholder" markdown="1">\<user></span> and <span class="placeholder" markdown="1">\<group></span>: Refer to `id(1)`. For example, on my machine

  ```
  $ id
  uid=501(leafac) gid=20(staff) [...]
  ```

  so <span class="placeholder" markdown="1">\<user></span> is `leafac` and <span class="placeholder" markdown="1">\<group></span> is `staff`.

- <span class="placeholder" markdown="1">\<password></span>: An arbitrary password.

- <span class="placeholder" markdown="1">\<migration-directory></span>: The directory for the temporary Dovecot mailboxes created above.

Migrate
=======

Start the local email server:

<aside markdown="1">
`ulimit -n`: Dovecot needs to open more than the default limit of 256 files.  
`sudo`: Dovecot needs to bind to a network port below 1024. Specifically, port 143, for IMAP.  
`/usr/local/sbin/dovecot`: Path to the `dovecot(1)` executable installed via Homebrew. Another common path is `/usr/sbin/dovecot`.  
`-F`: Run Dovecot on the foreground, instead of as a daemon. Stop it with `Ctrl + C`.
</aside>

```
$ ulimit -n 1024 && sudo /usr/local/sbin/dovecot -F
```

Confirm that the email server is running by inspecting the startup log messages and the contents of the <span class="placeholder" markdown="1">\<migration-directory></span>. Dovecot must have created its administration files and directories, otherwise review the steps thus far.

* * *

Connect the email clients (for example, Thunderbird and Apple Mail) to the local email server using the following settings:

<aside markdown="1">
An email client may insist on configuring a server to send emails (SMTP). Let this part of the configuration fail or reuse the settings from another account.
</aside>

<aside markdown="1">
Ignore warnings about insecure connections. We setup Dovecot insecurely on purpose because it is simpler and sufficient—the email migration is local.
</aside>

<aside markdown="1">
If you change Dovecot’s configuration (`dovecot.conf`), restart it or run the following command on a separate terminal:

```
$ sudo doveadm reload
```
</aside>

| Email Address | <span class="placeholder" markdown="1">\<user></span>@localhost |
| Server | `localhost` |
| Protocol | IMAP |
| Port | 143 |
| User | <span class="placeholder" markdown="1">\<user></span> |
| Password | <span class="placeholder" markdown="1">\<password></span> |

On the source email client, move emails from the local folders to the temporary server. Wait for completion and then, on the target email client, move emails from the temporary server to local folders. Wait for completion again. To guarantee that the process succeeded, close the email clients so that they commit pending transactions to the server and check the ◊path{<span class="placeholder" markdown="1">\<migration-directory></span>}, it should contain only empty directories and Dovecot’s administration files.

◊section['teardown]{Teardown}

After the migration is complete, remove the configurations connecting the email clients to the temporary email server. Then, stop the server by killing the process or running the following command on a separate terminal:

◊code/block{
$ sudo doveadm stop
}

Finally, remove Dovecot’s configuration and ◊path{<span class="placeholder" markdown="1">\<migration-directory></span>}, and uninstall it:

◊margin-note{Again, the location of ◊path{dovecot.conf} varies, be consistent with the choice made at ◊reference["#configuration"]{configuration}.}

◊code/block{
$ rm /usr/local/etc/dovecot/dovecot.conf
$ rm -rf <span class="placeholder" markdown="1">\<migration-directory></span>
$ brew uninstall dovecot
}

Appendix: Dovecot Configuration
===============================

◊margin-note{Refer to Dovecot’s manual for more details on each individual configuration option.}

Dovecot supports many kinds of services, for example, the IMAP and POP3 email server protocols, and authentication for other applications. In our temporary email server, we only want the IMAP service:

◊code/block{
protocols = imap
}

Usually email servers support multiple users and have to manage a database with their credentials. This database management might need to collaborate with other applications, for example, a web-client which allows users to change their passwords. We do not want this complexity, so we hard-code in the configuration file the credentials for a single user, ourselves:

◊margin-note{Dovecot is not a single process, but a collection of processes. They perform specific tasks and drop to only the necessary privileges, which enhances security and stability. Here we configure some of these processes to run as our user, which prevents permission problems with the files and directories Dovecot generates in the ◊path{<span class="placeholder" markdown="1">\<migration-directory></span>}.}

◊code/block{
default_login_user = <span class="placeholder" markdown="1">\<user></span>
default_internal_user = <span class="placeholder" markdown="1">\<user></span>

userdb {
  driver = static
  args = uid=<span class="placeholder" markdown="1">\<user></span> gid=<span class="placeholder" markdown="1">\<group></span>
}

passdb {
  driver = static
  args = password=<span class="placeholder" markdown="1">\<password></span>
}
}

When Dovecot has identified the user, it needs to find the corresponding mailbox. Again, we hard-code the location in the configuration file:

◊code/block{
mail_uid = <span class="placeholder" markdown="1">\<user></span>
mail_gid = <span class="placeholder" markdown="1">\<group></span>
mail_location = maildir:<span class="placeholder" markdown="1">\<migration-directory></span>

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
