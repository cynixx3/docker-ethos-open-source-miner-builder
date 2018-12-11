#Save this file as Dockerfile then run:
#  docker build --tag ccminer .
#  docker run -v $(pwd):/host -it ccminer
#* Setup the environment
FROM ubuntu:16.04
RUN \
  apt-get update \
&& apt-get -y dist-upgrade \
&& DEBIAN_FRONTEND=noninteractive apt-get -y install \
automake \
build-essential \
curl \
g++ \
gawk \
gcc \
git \
libcurl4-openssl-dev \
libc++-dev \
libgmp-dev \
libjansson-dev \
libssl-dev \
linux-headers-4.15.0-42-generic \
python-dev \
xorg \
&& mkdir /build
WORKDIR /build

#* Installing CUDA 9.2 and compatible drivers from nvidia website and not from ubuntu package is usually easier
ARG CUDA_TOOLKIT_URL=https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
ARG CUDA_TOOLKIT_PATCHURL=https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_linux

RUN \
  curl -LO $CUDA_TOOLKIT_URL  \
&& curl -LO $CUDA_TOOLKIT_PATCHURL

RUN \
  sh ./$(basename "$CUDA_TOOLKIT_URL") --silent --toolkit --no-drm

RUN \
  sh ./$(basename "$CUDA_TOOLKIT_PATCHURL") --silent --accept-eula

#* Copy miners source code and dependency code into the environment
ARG MINER_GIT_URL=https://github.com/zcoinofficial/ccminer.git
RUN git clone $MINER_GIT_URL --recursive
WORKDIR /build/ccminer/
RUN git submodule update --init

#* Compiling ccminner
RUN \
  ./autogen.sh \
&& ./configure

RUN \
  export PATH=$PATH:/usr/local/cuda-9.2/bin \
&& make

CMD ["cp", "ccminer", "/host"]
