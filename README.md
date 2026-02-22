# kai

## What this is really about

The primary contribution of this project is a carefully designed Docker environment
that lets an experienced person turn Claude Code loose — giving it broad autonomy
to read, write, and execute within a contained workspace — while maintaining
meaningful (not theatrical) safety properties.

The target is the middle ground between two failure modes: running Claude Code
directly on your laptop with full filesystem access ("openclaw"), and locking it
down so thoroughly that you can't actually discover what productive human-AI
collaboration looks like. The goal is an environment where a technically experienced
person who stays alert to context can work freely and learn fast, without betting
the laptop on it.

This is not designed to be safe for general users. That's a separate and important
problem. This is designed for people who have the systems background to understand
what the containment is actually doing, and who want to get real work done.

## Collaboration note

This project is developed in active collaboration with Claude (Anthropic's AI).
Pace provides the direction, security judgments, and use-case choices. Claude
contributes implementation, ideas, and most of the prose. "AI-assisted" would
understate it. Both are credited because the work is genuinely joint, and because
presenting Claude's writing as purely Pace's would be inaccurate.

## What the containment does

Claude Code runs inside a Docker container with access to a dedicated workspace
tree (`~/kai`). The key properties:

- **noexec on the host**: The workspace is bind-mounted noexec on the host,
  making it harder to accidentally execute code the AI has written. Not airtight —
  a host interpreter pointed at a script still runs it — but a useful mechanical
  reminder that enforces the discipline of treating AI-written code as data until
  reviewed.

- **Network filtering**: Outbound connections from the container are restricted
  to Anthropic API endpoints and GitHub (for git pulls), using a transparent
  SNI-filtering TLS proxy. Unknown domains can be reviewed interactively.

- **Two-clone git workflow**: Changes Claude makes to its own programs flow
  through a second git clone that requires deliberate human action to push to
  GitHub. Claude cannot self-publish code.

- **API key isolation**: The Anthropic API key is passed as an environment
  variable and never written to a file visible on the host filesystem.

The threat model is explicitly calibrated: low-sensitivity data, willing to
accept a full-laptop-copy risk to work productively in this area.

## The use case: a personal knowledge manager

The concrete application I'm building on top of this infrastructure is a PKM
(personal knowledge manager) — an Obsidian-spirit system of interlinked markdown
notes, operated via emacs and Unix CLI tools, with AI assistance for annotation,
linking, and retrieval. The PKM is a real thing I want, but it's also a strawman:
a concrete problem that exercises the infrastructure and produces something
demonstrably useful.

One scenario I'm particularly interested in is an **active journal**: a daily
practice where the AI greets you with a prompt enriched by your previous entries,
you respond, and the AI reflects observations back and prompts you to go deeper —
then formats the session into a PKM node. The kind of thing a good therapist or
coach does, but available daily and with access to your full history.

Other use cases that would fit this infrastructure equally well: a cooking
knowledge base, a reading log with AI-assisted synthesis, a research notebook.

## Who should look at this

If you are an experienced developer wanting to experiment with Claude Code at
full autonomy without the recklessness of running it on your host filesystem,
the infrastructure here may be directly useful or adaptable to your context.

If you're interested in building a PKM or active journal on top of this, or
have a different use case you'd like to bring, I'd like to hear from you.
I'm especially interested in people who want to own a specific application
domain while sharing the infrastructure work.

pace.willisson@gmail.com
