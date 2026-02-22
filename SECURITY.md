;; -*- mode: markdown; eval: (visual-line-mode 1); -*-

# Threat model

Suppose there's a group of a dozen people who work together as commercial hackers and they use AI assistance to target a rolling list to of 1000 high value targets.  Our user, Alice, winds up on their list.

Alice has a significant enough public digital footprint that the hacker's AI can sink its teeth in and devote a portion of every day to crafting attacks on Alice.  It detects that she uses kai and it reads kai's sourcecode at github.  It's now in a position to send targeted messages to Alice's kai by posting comments to public content that Alice's kai will read.

Let's treat this as saying that the hackers can create a file with data of their choice in Alice's kai directory.

What are the consequences?

* kai might treat the file as code and execute it in the container
* Alice might treat the file as code and execute it on the host
* The presence of the file might poison kai's output to Alice

We'll leave the poinsed output to future research.

Similarly, we'll leave to future research the consequences of poisoning due to bad code executed in the container.

We'll focus on bad code that either exports Alices data or that uses Alices credentials to act on external systems.

# Defences

* We prevent the container from making outbound network connections

* We depend on Alice not to run an interpreter on a file found in the kai directory
