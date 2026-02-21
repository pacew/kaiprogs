FROM ubuntu:24.04

ARG HOST_UID=1000
ARG HOST_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    emacs-nox \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Create user matching host uid/gid so kai tree file ownership stays clean.
# ubuntu:24.04 ships with an 'ubuntu' user at 1000:1000; rename it if needed.
RUN set -e; \
    if getent group ${HOST_GID} >/dev/null 2>&1; then \
        old_group=$(getent group ${HOST_GID} | cut -d: -f1); \
        [ "$old_group" != "pace" ] && groupmod -n pace "$old_group"; \
    else \
        groupadd -g ${HOST_GID} pace; \
    fi; \
    if getent passwd ${HOST_UID} >/dev/null 2>&1; then \
        old_user=$(getent passwd ${HOST_UID} | cut -d: -f1); \
        if [ "$old_user" != "pace" ]; then \
            usermod -l pace -d /home/pace -m -s /bin/bash "$old_user"; \
        fi; \
    else \
        useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash pace; \
    fi

# Create .claude dir owned by pace so claude can write config at runtime
RUN mkdir -p /home/pace/.claude && chown pace:pace /home/pace/.claude

# kaiprogs/bin is on PATH; the volume mount provides it at runtime
ENV PATH="/home/pace/kai/kaiprogs/bin:${PATH}"

USER pace
WORKDIR /home/pace/kai

CMD ["/bin/bash"]
