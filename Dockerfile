FROM ubuntu:18.04

ENV LIBZMQ_VERSION v4.3.1

WORKDIR /

RUN apt-get update && apt-get install -y \
    tree \
    htop \
    tmux \
    wget \
    vim \
    less \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    autoconf \
    build-essential \
    git \
    libtool \
    automake \
    pkg-config\
    unzip \
    libkrb5-dev \
    && git clone -b ${LIBZMQ_VERSION} --depth 1 https://github.com/zeromq/libzmq.git \
    && cd /libzmq \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && ldconfig \
    && cd / \
    && rm -rf libzmq \
    && apt-get autoremove -y \
    autoconf \
    build-essential \
    git \
    libtool \
    automake \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 appuser \
    && useradd -rm -d /home/appuser  -u 1000 -g appuser appuser
USER appuser
WORKDIR /home/appuser
