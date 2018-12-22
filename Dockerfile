# To build several miners for a ubuntu 16 environment
# Save the contents of this to Dockerfile
# comment / uncomment what you want
# and run the commands below
#* docker build -t miner .
#* docker run -v $(pwd):/host -it miner
# Just running the second command would rebuild with updates
FROM nvidia/cuda:10.0-devel-ubuntu16.04

RUN apt-get -y update \
&&  apt-get -y install \
        automake \
        git \
        libssl-dev \
#* for ccminer
        libcurl4-openssl-dev \
#* for ethminer
        cmake mesa-common-dev \
#* for xmr-stak
        opencl-headers ocl-icd-opencl-dev libmicrohttpd-dev libhwloc-dev

WORKDIR /build

#* CCMiner
ARG MINER_GIT_URL=https://github.com/tpruvot/ccminer.git
ARG MINER_GIT_BRANCH=linux
ARG MINER_FOLDER=ccminer
ARG MINER_EXE=ccminer
ARG MINER_GEN="./autogen.sh"
ARG MINER_CONFIG="./configure --with-cuda=/usr/local/cuda"

#* CCMiner forks (duplicate values above omitted below, so just uncomment both sections)
#* Klaust
#ARG MINER_GIT_URL=https://github.com/KlausT/ccminer.git
#* Nevermore
#ARG MINER_GIT_URL=https://github.com/brian112358/nevermore-miner.git
#ARG MINER_FOLDER=nevermore-miner
#* Zcoin
#ARG MINER_GIT_URL=https://github.com/zcoinofficial/ccminer.git
#ARG MINER_GIT_BRANCH=master

#* Ethminer
#ARG MINER_GIT_URL=https://github.com/ethereum-mining/ethminer.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=ethminer
#ARG MINER_EXE=ethminer/ethminer
#ARG MINER_CONFIG="cmake -DETHASHCL=ON -DETHASHCUDA=ON -DETHSTRATUM=ON --build ."

#* ProgPOW (ethminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/ifdefelse/ProgPOW.git
#ARG MINER_FOLDER=ProgPOW
#ARG MINER_CONFIG="cmake -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs -DETHASHCL=OFF -DETHASHCUDA=ON -DETHSTRATUM=ON --build ."

#* SGminer-GM
#ARG MINER_GIT_URL=https://github.com/tpruvot/sgminer.git
#ARG MINER_GIT_BRANCH=ethash
#ARG MINER_FOLDER=sgminer
#ARG MINER_EXE=sgminer
#ARG MINER_GEN="autoreconf -i"
#ARG MINER_CONFIG="./configure"

#* Avermore (sgminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/brian112358/avermore-miner.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=avermore-miner

#* XMR-Stak
#ARG MINER_GIT_URL=https://github.com/fireice-uk/xmr-stak.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=xmr-stak
#ARG MINER_EXE="bin/xmr-stak bin/libxmrstak_cuda_backend.so bin/libxmrstak_opencl_backend.so"
#ARG MINER_CONFIG="cmake -DXMR-STAK_COMPILE=generic -DCPU_ENABLE=ON -DCMAKE_LINK_STATIC=ON -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON --build ."

RUN git clone $MINER_GIT_URL --branch $MINER_GIT_BRANCH --single-branch

WORKDIR /build/$MINER_FOLDER
RUN if [ -f .gitmodules ] ; then git submodule update --init ; fi

RUN $MINER_GEN

RUN \
#* for ccminer compatability
CUDA_CFLAGS="-O3 -lineno -Xcompiler -Wall  -D_FORCE_INLINES" CXXFLAGS='-O3 -D_REENTRANT -falign-functions=16 -falign-jumps=16 -falign-labels=16' \
 $MINER_CONFIG

RUN printf "#!/bin/bash\n\
git pull\n\
#* for ccminer compatability
sed -E 's/^#(nvcc_ARCH.*$)/\1/' -i Makefile.am\n\
make\n\
strip $MINER_EXE \n\
cp $MINER_EXE /host" > run.sh \
&&  chmod u+x run.sh

CMD ["/bin/bash", "-c", "./run.sh"]
