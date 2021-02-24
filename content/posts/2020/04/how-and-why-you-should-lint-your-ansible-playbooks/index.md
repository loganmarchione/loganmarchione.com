---
title: "How and why you should lint your Ansible playbooks"
date: "2020-04-18"
author: "Logan Marchione"
categories: 
  - "linux"
  - "oc"
cover:
    image: "/assets/featured/featured_ansible_text.svg"
    alt: "featured image"
    relative: false
---

# Introduction

## What is Ansible?

If you're reading this, you probably already know what [Ansible](https://www.ansible.com/) is, so I won't spend a lot of time here.

Ansible is open-source configuration management software. It lets you configure one machine, or 100 machines, in the same way, every time. You can use Ansible to install software, create users, update files, etc... Basically, if it's a task that can be automated, Ansible can do it.

I'm using Ansible in my homelab to:

- Provision virtual machines (e.g., setup basic packages, create users, setup SSH keys, etc...)
- Install applications (e.g., Docker host, Graylog, Nginx, LEMP stack, etc...)
- Install updates (e.g., `apt-get upgrade`)

## What is linting?

[Linting](https://en.wikipedia.org/wiki/Lint_(software)) is a way to analyze code to look for potential errors before the code executes. Generally, linting uses a set of known rules, and compares your code against those rules. For example, linting is used for:

- improving readability
- finding syntax errors (before execution)
- code standardizing ([relevant XKCD](https://xkcd.com/1285/))
- finding security issues

Linting can (and usually does) include some level of syntax checking, but it can also test for more things. However, linting is not the same as debugging, which generally takes place when the code compiles or executes, whereas linting takes places before code runs.

## Why lint Ansible?

Ansible uses [YAML](https://en.wikipedia.org/wiki/YAML) files to describe playbooks, roles, variables, and just about everything else. YAML is easy to read, but is picky about things like whitespace, indentation, and syntax in general. I'd like to have some confidence that updates to my playbooks will work, without having to run them after every update.

Let me preface this by saying, I'm not a developer and I don't write code for a living. Expect some of this to be slightly wrong, but it should be right enough to get you started.

# Installation

I'm going to assume you already have `ansible` installed and working. To install `ansible-lint`, use the [documentation on the Github repo](https://github.com/ansible/ansible-lint). Don't use your distribution's package manager, as the version of `ansible-lint` is probably very old.

```
pip3 install ansible-lint
```

Verify the installation with the command below.

```
ansible-lint --version
```

# Manual linting

First, view all the rules that `ansible-lint` will use by running `ansible-lint -L`. I was able to see 31 different rules that my code would be checked against.

```
101: Deprecated always_run
Instead of ``always_run``, use ``check_mode``
102: No Jinja2 in when
``when`` lines should not include Jinja2 variables
103: Deprecated sudo
Instead of ``sudo``/``sudo_user``, use ``become``/``become_user``.
104: Using bare variables is deprecated
Using bare variables is deprecated. Update your playbooks so that the environment value uses the full variable syntax ``{{ your_variable }}``
105: Deprecated module
These are deprecated modules, some modules are kept temporarily for backwards compatibility but usage is discouraged. For more details see: https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html
201: Trailing whitespace
There should not be any trailing whitespace
202: Octal file permissions must contain leading zero or be a string
Numeric file permissions without leading zero can behave in unexpected ways. See http://docs.ansible.com/ansible/file_module.html
203: Most files should not contain tabs
Tabs can cause unexpected display issues, use spaces
204: Lines should be no longer than 160 chars
Long lines make code harder to read and code review more difficult
205: Use ".yml" or ".yaml" playbook extension
Playbooks should have the ".yml" or ".yaml" extension
206: Variables should have spaces before and after: {{ var_name }}
Variables should have spaces before and after: ``{{ var_name }}``
301: Commands should not change things if nothing needs doing
Commands should either read information (and thus set ``changed_when``) or not do something if it has already been done (using creates/removes) or only do it if another check has a particular result (``when``)
302: Using command rather than an argument to e.g. file
Executing a command when there are arguments to modules is generally a bad idea
303: Using command rather than module
Executing a command when there is an Ansible module is generally a bad idea
304: Environment variables don't work as part of command
Environment variables should be passed to ``shell`` or ``command`` through environment argument
305: Use shell only when shell functionality is required
Shell should only be used when piping, redirecting or chaining commands (and Ansible would be preferred for some of those!)
306: Shells that use pipes should set the pipefail option
Without the pipefail option set, a shell command that implements a pipeline can fail and still return 0. If any part of the pipeline other than the terminal command fails, the whole pipeline will still return 0, which may be considered a success by Ansible. Pipefail is available in the bash shell.
401: Git checkouts must contain explicit version
All version control checkouts must point to an explicit commit or tag, not just ``latest``
402: Mercurial checkouts must contain explicit revision
All version control checkouts must point to an explicit commit or tag, not just ``latest``
403: Package installs should not use latest
Package installs should use ``state=present`` with or without a version
404: Doesn't need a relative path in role
``copy`` and ``template`` do not need to use relative path for ``src``
501: become_user requires become to work as expected
``become_user`` without ``become`` will not actually change user
502: All tasks should be named
All tasks should have a distinct name for readability and for ``--start-at-task`` to work
503: Tasks that run when changed should likely be handlers
If a task has a ``when: result.changed`` setting, it is effectively acting as a handler
504: Do not use 'local_action', use 'delegate_to: localhost'
Do not use ``local_action``, use ``delegate_to: localhost``
601: Don't compare to literal True/False
Use ``when: var`` rather than ``when: var == True`` (or conversely ``when: not var``)
602: Don't compare to empty string
Use ``when: var`` rather than ``when: var != ""`` (or conversely ``when: not var`` rather than ``when: var == ""``)
701: meta/main.yml should contain relevant info
meta/main.yml should contain: ``author, description, license, min_ansible_version, platforms``
702: Tags must contain lowercase letters and digits only
Tags must contain lowercase letters and digits only, and ``galaxy_tags`` is expected to be a list
703: meta/main.yml default values should be changed
meta/main.yml default values should be changed for: ``author, description, company, license, license``
704: meta/main.yml video_links should be formatted correctly
Items in ``video_links`` in meta/main.yml should be dictionaries, and contain only keys ``url`` and ``title``, and have a shared link from a supported provider
```

Then, simply pass a playbook or role to `ansible-lint` and it will tell you about possible problems. You can pass all of your playbooks at once, with the command below (assuming you're in the directory where your YML files reside).

```
ansible-lint *.yml
```

When you get your results, the output will be on three lines:

1. The rule that triggered
2. The file that contains the error and the line number (it may not always be this _exact_ line, but it's usually around here)
3. The offending line

For example, the code below is used to install a few packages, but it has an error that could cause some breakage. Can you spot it?

```
- name: Install pip packages
  pip:
    name:
      - certbot
      - certbot_dns_nsone
      - cryptography
    state: latest
```

In this code above, I'm using `pip` to install packages for [Certbot](https://github.com/certbot/certbot). However, I'm using the _latest_ tag, which means if I run this playbook across multiple machines at different times, I could get different packages (depending on what is hosted on PyPi). This could produce inconsistencies between machines. Imagine if you're Google and running this on 1000 servers: you could have 500 servers with one version, and 500 servers with another version (which may or may not be compatible with your software).

```
[403] Package installs should not use latest
roles/certs_certbot/tasks/main.yml:2
Task/Handler: Install pip packages
```

Ideally, I would specify a version number after each package (as shown below).

```
- name: Install pip packages
  pip:
    name:
      - certbot==1.0
      - certbot_dns_nsone==1.0
      - cryptography==1.0
    state: present
```

## Linting vs syntax-checking

As I mentioned earlier, linting is more detailed than syntax checking. Ansible has a built-in syntax checker that you should be using, but it may not catch everything.

```
ansible-playbook --syntax-check --list-tasks playbook.yml
```

As an example, below is a task from a playbook to setup a PHP configuration file. This code passed Ansible's syntax check, but `ansible-lint` caught two issues. Can you spot them?

```
- name: Update application configuration from template
  template:
    src: templates/php_99-custom_no_opcache.j2
    dest: /etc/php/{{php_upstream_version}}/fpm/conf.d/99-custom.ini 
    backup: yes
    owner: root
    group: root
    mode: 0644
```

First, there is an extra space after the name of the .ini file (on a desktop, click and drag in the code above and you'll see it).

```
[201] Trailing whitespace
roles/install_php_no_opcache/tasks/main.yml:26
dest: /etc/php/{{php_upstream_version}}/fpm/conf.d/99-custom.ini
```

Second, I am missing spaces before and after the variable name in curly brackets.

```
[206] Variables should have spaces before and after: {{ var_name }}
roles/install_php_no_opcache/tasks/main.yml:26
dest: /etc/php/{{php_upstream_version}}/fpm/conf.d/99-custom.ini
```

These two issues are technically OK as far as YML syntax is concerned, but they're not consistent across all my playbooks. This is especially important if you're working on code that has multiple contributors.

# Conclusion

That's it for now. In [part two](/2020/04/linting-ansible-playbooks-using-drone/), I'll explore using Drone to automate linting of Ansible playbooks!

Thanks for reading!

\-Logan

# Comments

[Old comments from WordPress](/2020/04/how-and-why-you-should-lint-your-ansible-playbooks/comments.txt)