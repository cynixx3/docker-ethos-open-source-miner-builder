# To build several forks of ccminer for a ubuntu 16 environment
# Save the contents of this to Dockerfile and run the commands below
#* docker build -t ccminer .
#* docker run -v $(pwd):/host -it ccminer
# Just running the second command would rebuild with updates
FROM nvidia/cuda:10.0-devel-ubuntu16.04

RUN apt-get -y update \
&&  DEBIAN_FRONTEND=noninteractive apt-get -y install \
        automake \
        git \
        libssl-dev \
        libcurl4-openssl-dev

WORKDIR /build

ARG MINER_GIT_URL=https://github.com/tpruvot/ccminer.git
ARG MINER_GIT_BRANCH=linux
ARG MINER_FOLDER=ccminer
#* Or set a different fork here or using in the build command with --build-arg
#* Klaust
#ARG MINER_GIT_URL=https://github.com/KlausT/ccminer.git
#* Nevermore
#ARG MINER_GIT_URL=https://github.com/brian112358/nevermore-miner.git
#ARG MINER_FOLDER=nevermore-miner
#* Zcoin
#ARG MINER_GIT_URL=https://github.com/zcoinofficial/ccminer.git
#ARG MINER_GIT_BRANCH=master

RUN git clone $MINER_GIT_URL --branch $MINER_GIT_BRANCH --single-branch

WORKDIR /build/$MINER_FOLDER

RUN ./autogen.sh \
&&  ./configure --with-cuda=/usr/local/cuda

RUN printf "#!/bin/bash\n\
git pull\n\
sed -E 's/^#(nvcc_ARCH.*$)/\1/' -i Makefile.am\n\
make\n\
cp ccminer /host" > /run.sh \
&&  chmod u+x /run.sh

CMD ["/bin/bash", "-c", "/run.sh"]
