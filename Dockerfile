ARG IMAGE="ubuntu:focal"
#FROM alpine:3.14

FROM $IMAGE AS common

WORKDIR /work

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      make \
  && apt-get update -qq && apt-get autoclean && apt-get clean && apt-get -y autoremove \
  && update-ca-certificates
RUN apt-get install -y --no-install-recommends \
      autoconf \
      bison \
      clang \
      flex libfl-dev \
      g++ \
      gcc \
      gnat-9 \
      gperf \
      llvm-dev \
      readline-common \
      zlib1g-dev




RUN apt-get install -y --no-install-recommends \
      libgnat-9 \
      python-is-python3 \
      python3 \
      python3-pip \
      python3-dev \
      swig \
      zlib1g-dev \
      libboost-dev \
  && apt-get autoclean && apt-get clean && apt-get -y autoremove


ENV DEBIAN_FRONTEND noninteractive



RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      openjdk-11-jdk \
  && apt-get autoclean && apt-get clean && apt-get -y autoremove

RUN apt-get install curl gnupg2 wget git -y 
RUN wget https://github.com/sbt/sbt/releases/download/v1.7.1/sbt-1.7.1.tgz && tar -xzf sbt-1.7.1.tgz \
    && cp sbt/bin/* /usr/bin/ && rm sbt-1.7.1.tgz

RUN apt-get update -qq &&  apt-get install libusb-* -y 

RUN git clone http://git.veripool.org/git/verilator && cd verilator \
 && git checkout v4.110 \
 && unset VERILATOR_ROOT \
 && autoconf \
 && ./configure --prefix="/usr/local/"\
 && make -j$(nproc) \
 && make install 
RUN mkdir -p /opt/riscv 

COPY riscv /opt/riscv
RUN pip install intelhex
RUN mkdir -p /work/jtaghub
COPY jtaghub /work/jtaghub


