# To build several miners for a ubuntu 16 environment
# Save the contents of this to Dockerfile
# uncomment what you want and run the commands below
#* docker build -t miner .
#* docker run -v $(pwd):/host -it miner
# Just running the second command would rebuild with updates
FROM nvidia/cuda:10.0-devel-ubuntu16.04

RUN apt-get -y update \
&&  DEBIAN_FRONTEND=noninteractive apt-get -y install \
        automake \
        git \
        libssl-dev \
#* for ccminer
        libcurl4-openssl-dev \
#* for DaggerGPUMiner
        libboost-dev libboost-system-dev \
#* for ethminer
        cmake mesa-common-dev \
#* for xmr-stak
         libhwloc-dev libmicrohttpd-dev ocl-icd-opencl-dev opencl-headers \
#* for xmrig-amd
         libuv1-dev \
#* for energiminer
&&  printf "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main \n#deb-src http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main \n" >> /etc/apt/sources.list \
&&  DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get -y install \
         gcc-6 g++-6 \
&&  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60

WORKDIR /build

#* for docker-compose
ARG MINER_GIT_URL
ARG MINER_GIT_BRANCH
ARG MINER_FOLDER
ARG MINER_EXE
ARG MINER_KERNELS
ARG MINER_GEN
ARG MINER_CONFIG

#* Uncomment a parent (and fork) section below to build a single miner 
#* CCMiner (parent)
#ARG MINER_GIT_URL=https://github.com/tpruvot/ccminer.git
#ARG MINER_GIT_BRANCH=linux
#ARG MINER_FOLDER=ccminer
#ARG MINER_EXE=ccminer
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG="./configure --with-cuda=/usr/local/cuda"

#* Klaust (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/KlausT/ccminer.git

#* Nevermore (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/brian112358/nevermore-miner.git
#ARG MINER_FOLDER=nevermore-miner

#* Zcoin (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/zcoinofficial/ccminer.git
#ARG MINER_GIT_BRANCH=master

#* Cuckoo
#ARG MINER_GIT_URL=https://github.com/tromp/cuckoo.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=cuckoo/src
#ARG MINER_EXE="cuckoo/lean19x1 cuckoo/mean29x4 cuckoo/simple19"

#* Dagger GPU miner (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/XDagger/DaggerGpuMiner.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=DaggerGpuMiner/GpuMiner
#ARG MINER_EXE=xdag-gpu

#* Ethminer (parent)
#ARG MINER_GIT_URL=https://github.com/ethereum-mining/ethminer.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=ethminer
#ARG MINER_EXE=ethminer/ethminer
#ARG MINER_KERNELS=libethash-cl/kernels/bin
#ARG MINER_CONFIG="cmake -DETHASHCL=ON -DETHASHCUDA=ON -DETHSTRATUM=ON --build ."

#* Energi miner (ethminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/energicryptocurrency/energiminer.git
#ARG MINER_FOLDER=energiminer
#ARG MINER_KERNELS=libnrghash-cl/kernels/bin
#ARG MINER_EXE=energiminer/energiminer

#* ProgPOW (ethminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/ifdefelse/ProgPOW.git
#ARG MINER_FOLDER=ProgPOW
#ARG MINER_KERNELS
#ARG MINER_CONFIG="cmake -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs -DETHASHCL=OFF -DETHASHCUDA=ON -DETHSTRATUM=ON --build ."

#* SGminer-GM (parent)
#ARG MINER_GIT_URL=https://github.com/tpruvot/sgminer.git
#ARG MINER_GIT_BRANCH=ethash
#ARG MINER_FOLDER=sgminer
#ARG MINER_EXE=sgminer
#ARG MINER_KERNELS=kernel
#ARG MINER_GEN="autoreconf -i"
#ARG MINER_CONFIG="./configure"

#* Avermore (sgminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/brian112358/avermore-miner.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=avermore-miner

#* SilentArmy (parent)
#ARG MINER_GIT_URL=https://github.com/mbevand/silentarmy.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=silentarmy
#ARG MINER_EXE="silentarmy sa-solver"

#* AMDVerusCoin (silentarmy fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/monkins1010/AMDVerusCoin.git
#ARG MINER_FOLDER=AMDVerusCoin

#* XMR-Stak (parent)
#ARG MINER_GIT_URL=https://github.com/fireice-uk/xmr-stak.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=xmr-stak
#ARG MINER_EXE="bin/xmr-stak bin/libxmrstak_cuda_backend.so bin/libxmrstak_opencl_backend.so"
#ARG MINER_CONFIG="cmake -DXMR-STAK_COMPILE=generic -DCPU_ENABLE=ON -DCMAKE_LINK_STATIC=ON -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON --build ."

#* xmrig-amd (parent)
#ARG MINER_GIT_URL=https://github.com/xmrig/xmrig-amd.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=xmrig-amd
#ARG MINER_EXE=xmrig-amd
#ARG MINER_CONFIG="cmake ."

#* xmrig-nvidia (xmrig-amd like, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/xmrig/xmrig-nvidia.git
#ARG MINER_FOLDER=xmrig-nvidia
#ARG MINER_EXE=xmrig-nvidia
#ARG MINER_CONFIG="cmake -DCUDA_ARCH=30;50;60 ."

#* xmrig Monero Ocean (xmrig-amd fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/MoneroOcean/xmrig.git
#ARG MINER_FOLDER=xmrig
#ARG MINER_EXE=xmrig

RUN git clone $MINER_GIT_URL --branch $MINER_GIT_BRANCH --single-branch

WORKDIR /build/$MINER_FOLDER
RUN if [ -f .gitmodules ] ; then git submodule update --init ; fi

#* for ccminer and sgminer compatability
RUN $MINER_GEN

RUN \
#* for ccminer compatability (-std=c++0x for energiminer)
    CUDA_CFLAGS="-O3 -lineno -Xcompiler -Wall  -D_FORCE_INLINES" \
    CXXFLAGS="-O3 -D_REENTRANT -falign-functions=16 -falign-jumps=16 -falign-labels=16 -std=c++0x" \
    $MINER_CONFIG

RUN printf "#!/bin/bash\n\
git pull \n\
#* for ccminer compatability \n\
if [ -f Makefile.am ] ; then sed -E 's/^#(nvcc_ARCH.*$)/\1/' -i Makefile.am ; fi \n\
make \n\
strip $MINER_EXE \n\
if [ ! -d /host/$MINER_FOLDER ] ; then mkdir /host/$(echo $MINER_FOLDER | cut -d / -f 1) ; fi \n\
rsync -av $MINER_EXE /host/$(echo $MINER_FOLDER | cut -d / -f 1) \n\
if [ $MINER_KERNELS ] ; then cp -r $MINER_KERNELS /host/$MINER_FOLDER/kernels ; fi" > run.sh \
&&  chmod u+x run.sh

CMD ["/bin/bash", "-c", "./run.sh"]
