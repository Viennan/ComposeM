FROM nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04

ARG HOST_USER=wiennan
ARG HOST_UID=1000
ARG HOST_GID=1000

USER root

RUN apt update && \
    apt install -y \
        sudo \
        nano \
        cmake \
        build-essential \
        clang \
        python3 \
        python3-pip \
        python3-dev \
        git \
        wget \
        curl \
        libegl1 \
        libgles2 \
        mesa-utils \
        nasm \
        yasm \
        libdrm-dev \
        libopenjp2-7-dev \
        libwebp-dev \
        frei0r-plugins-dev \
        libaom-dev \
        libass-dev \
        libcodec2-dev \
        libdav1d-dev \
        libvpl-dev \
        libgsm1-dev \
        libmp3lame-dev \
        libopus-dev \
        librsvg2-dev \
        librtmp-dev \
        libshine-dev \
        libsnappy-dev \
        libspeex-dev \
        libtheora-dev \
        libtwolame-dev \
        libvorbis-dev \
        libvpx-dev \
        libx264-dev \
        libx265-dev \
        libxvidcore-dev \
        libzvbi-dev \
        libxml2-dev \
        ocl-icd-opencl-dev \
        libssl-dev \
        libvpl-dev \
        libva-dev \
    && \
    rm -rf /var/lib/apt/lists/*

RUN set -e; \
    # process group conflict
    if getent group $HOST_GID > /dev/null 2>&1; then \
        EXISTING_GROUP=$(getent group $HOST_GID | cut -d: -f1); \
        echo "Using existing group: $EXISTING_GROUP (GID: $HOST_GID)"; \
        GROUP_NAME="$EXISTING_GROUP"; \
    else \
        GROUP_NAME="$HOST_USER"; \
        groupadd -g $HOST_GID $GROUP_NAME; \
        echo "Created new group: $GROUP_NAME (GID: $HOST_GID)"; \
    fi; \
    \
    # process user conflict
    if getent passwd $HOST_UID > /dev/null 2>&1; then \
        EXISTING_USER=$(getent passwd $HOST_UID | cut -d: -f1); \
        echo "User with UID $HOST_UID already exists: $EXISTING_USER"; \
        echo "Modifying existing user to match host configuration..."; \
        # modify user props
        usermod -g $GROUP_NAME -d /home/$HOST_USER -m -s /bin/bash $EXISTING_USER 2>/dev/null || true; \
        USER_NAME="$EXISTING_USER"; \
    else \
        USER_NAME="$HOST_USER"; \
        useradd -m -u $HOST_UID -g $GROUP_NAME -s /bin/bash $USER_NAME; \
        echo "Created new user: $USER_NAME (UID: $HOST_UID)"; \
    fi; \
    \
    # sudo no password
    if ! grep -q "^$USER_NAME" /etc/sudoers 2>/dev/null; then \
        echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
        echo "Added $USER_NAME to sudoers"; \
    else \
        echo "User $USER_NAME already in sudoers"; \
    fi

