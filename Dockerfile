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

# Create user matching host uid/gid so kai tree file ownership stays clean
RUN groupadd -g ${HOST_GID} pace && \
    useradd -m -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash pace

# kaiprogs/bin is on PATH; the volume mount provides it at runtime
ENV PATH="/home/pace/kai/kaiprogs/bin:${PATH}"

USER pace
WORKDIR /home/pace/kai

CMD ["/bin/bash"]
