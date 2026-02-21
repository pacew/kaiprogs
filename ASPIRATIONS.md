-*- mode:visual-lines -*-

# Intro

DRAFT 

This is a brainstorming document.  All is very subject to revision

The kai project

An AI assisted personal knowledge manager

kai means knowledge with ai

A hobby project that might be personally useful but at least will be a vehicle to learn about claude code.

# My background

I've written a lot of distributed systems in my 45 year career - lots of embedded systems, device drivers, and plumbing for database driven web sites.  I've only started paying attention to AI since December 2025.

# Glossary

* **the container**: A locked down docker container that runs claude code.  The container has access to a limited number of files on the host and no ability to make network connections.

* **kai tree**: A directory tree on the host. the container has read/write/execute permission for all files in this tree.  The kai tree is also accessible to host processes running outside the container.

* **the model**: An external model that claude code interacts with that has the usual capabilities of a public AI chatbot, such as the ability to read public urls, to interact with well know services like search and youtube, but not to post to general urls.

# Security Posture

I'll treat the kai tree like a publically accessible but obscure web server with a robots.txt that requests that search engines stay out.

Claude code will be able to write to files in the kai tree, and I have to assume that prompt injection will happen and that the files may contain malware.  So, I'll defend against accidentally executing program in the kai tree by mounting it on the host with noexec.  Inside the container, the kai tree will be writable and executable by me or by the model.

So, programs running on the host will treat the kai tree as strictly data.  It will be important to stay aware there there is still an intentional execution path: Many subdirectories of the kai tree will be git repositories that will be pushed by host processes.  When these repositores are checked out into ordinary host directories, their files can be executed.  Security will come from me reviewing what I push.

If would be nice if there were a way to mark some repositores are "data only" that can be pushed without human review, but got an error if a clone operation is attempted in a directory that is not mounted noexec.

I feel confident in my ability to keep cleartext credentials out of repositories and the kai tree.  I feel confident that I can keep the level of sensitiviy of information that I put into the kai tree will be low enough that it wouldn't be devastating or even especially inconvenient for a bad guy to copy the whole tree.

It would be inconvenient but still not devastating if this project gives a bad guy a copy of my whole laptop.  It's a risk I'm willing to take to able to work in this area.

# Scope of capabilities

Very roughly, kai makes the Obsidian idea of an interlinked personal knowledge database easy to use.  The focus is on textual data and on the plumbing to make it useful.  A slick GUI is not needed - emacs and unix style command line utilities are great interfaces.

Out of scope: automatic actions triggered by the model (like sending email)

Perhaps nodes are automatically made from each chatbot interaction.  The model, either synchronously or in batch processes, annotates the raw data to make it more useful.

There will be tools to form the context for a new AI chat from nodes in the database.

There will be tools for explicit context management of a single AI chatbot thread - like forking.

# Related work

* https://github.com/topics/personal-knowledge-management
* https://github.com/lethain/library-mcp
* https://github.com/winstonkoh87/Athena-Public
* https://www.youtube.com/watch?v=IA02YB8mInM

# Scenarios

## Cooking

Markdown files containing

* recipies, including notations how frequently I make the dish, maybe even a history
* a list of kitchen equipment
* a list of staples always on hand
* a list of perishables presently on hand
* dietary preferences for me and friends
* files related to party planning

