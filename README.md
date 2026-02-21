;; -*- mode: markdown; eval: (visual-line-mode 1); -*-

# File structure

## $HOME/kai

The working tree for the docker container.  Accessible with the same name on the host, but mounted noexec on the host.

## $HOME/kai/kaiprogs

A git repository for the programs that make up kai.  This clone is for collaborating with claude code but not executing programs.  origin is an external public repository like github so git pull is possible, but git push is not.

## $HOME/kaiprogs

The same kaiprogs repository to be used on the host and not accessible to the container.  Cloned with authority to push to the external repository.  Has done "git remote add kai $HOME/kai/kaiprogs" so changes made in $HOME/kai/kaiprogs can be pulled, locally reviewed, and pushed to the external repository.

## $HOME/kaiprogs/bootstrap

A script to run on the host after cloning kaiprogs from the external repository to the host.  Accomplishes:

* git config --global protocol.file.allow user
* stuff to create $HOME/kai with noexec
* clone the external reporitory into $HOME/kai/kaiprogs
* git remote add kai $HOME/kai/kaiprogs
* create the docker container (deleting the old one)


