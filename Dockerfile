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
#* for bfgminer
        libevent-dev libjansson-dev libsensors4-dev uthash-dev \
#* for ccminer
        libcurl4-openssl-dev \
#* for DaggerGPUMiner
        libboost-dev libboost-system-dev \
#* for ethminer
        mesa-common-dev \
#* for nheqminer
        libboost-all-dev \
#* for xmr-stak
        libhwloc-dev libmicrohttpd-dev ocl-icd-opencl-dev opencl-headers \
#* for xmrig-amd
        libuv1-dev \
#* for grin
        clang curl libncurses5-dev libncursesw5-dev zlib1g-dev \
&&  curl https://sh.rustup.rs -o rustup.sh \
&&  chmod +x rustup.sh \
&&  ./rustup.sh -y \
&&  mv $HOME/.cargo/bin/* /usr/local/bin/ \
#* for energiminer
&&  printf "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main \n#deb-src http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main \n" >> /etc/apt/sources.list \
&&  DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F \
&&  apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get -y install \
         gcc-6 g++-6 gcc-7 g++-7 \
&&  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 100 --slave /usr/bin/g++ g++ /usr/bin/g++-5 \
&&  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 \
#* for beam
&&  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7 \
&&  curl -O https://cmake.org/files/v3.12/cmake-3.12.0-Linux-x86_64.sh \
&&  sh cmake-3.12.0-Linux-x86_64.sh --skip-license --prefix=/usr

WORKDIR /build

#* for docker-compose
ARG MINER_GIT_URL
ARG MINER_GIT_BRANCH
ARG MINER_FOLDER
ARG MINER_EXE
ARG MINER_KERNELS
ARG MINER_GEN
ARG MINER_CONFIG
ARG extracflags
ARG extracxxflags
ARG extracuda_cflags
ARG CONFIG_CPP

#* Uncomment a parent (and fork) section below to build a single miner 
#* Beam Nvidia
#ARG MINER_GIT_URL=https://github.com/BeamMW/cuda-miner.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=cuda-miner
#ARG CONFIG_CPP="update-alternatives --set gcc /usr/bin/gcc-6"
#ARG MINER_EXE=equihash/beam-cuda-miner
#ARG MINER_GEN="cmake ."

#* Beam AMD
#ARG MINER_GIT_URL=https://github.com/BeamMW/opencl-miner.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=opencl-miner
#ARG CONFIG_CPP="update-alternatives --set gcc /usr/bin/gcc-7"
#ARG MINER_EXE=beam-opencl-miner
#ARG MINER_KERNELS=kernels
#ARG MINER_GEN="cmake ."

#* BFGMiner
#ARG MINER_GIT_URL=https://github.com/luke-jr/bfgminer.git
#ARG MINER_GIT_BRANCH=bfgminer
#ARG MINER_FOLDER=bfgminer
#ARG MINER_EXE=bfgminer
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG="./configure --with-cuda=/usr/local/cuda"

#* CCMiner (parent)
#ARG MINER_GIT_URL=https://github.com/tpruvot/ccminer.git
#ARG MINER_GIT_BRANCH=linux
#ARG MINER_FOLDER=ccminer
#ARG MINER_EXE=ccminer
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG="./configure --with-cuda=/usr/local/cuda"
#ARG extracuda_cflags="-O3 -lineno -Xcompiler -Wall  -D_FORCE_INLINES"
#ARG extracxxflags="-O3 -D_REENTRANT -falign-functions=16 -falign-jumps=16 -falign-labels=16"

#* Klaust (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/KlausT/ccminer.git

#* Nevermore (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/brian112358/nevermore-miner.git
#ARG MINER_FOLDER=nevermore-miner

#* Suprminer (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/ocminer/suprminer.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=suprminer
#ARG CONFIG_CPP="git clone https://github.com/peters/curl-for-windows.git compat/curl-for-windows"

#* Zcoin (ccminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/zcoinofficial/ccminer.git
#ARG MINER_GIT_BRANCH=master

#* CGMiner
#ARG MINER_GIT_URL=https://github.com/ckolivas/cgminer.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=cgminer
#ARG MINER_EXE=cgminer
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG="./configure --with-cuda=/usr/local/cuda"

#* CUBalloon
#ARG MINER_GIT_URL=https://github.com/Belgarion/cuballoon.git
#ARG MINER_FOLDER=cuballoon
#ARG MINER_GIT_BRANCH=master
#ARG MINER_EXE=cpuminer
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG="./configure --with-crypto --with-curl"
#ARG extracflags="-O2 -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores -DUSE_ASM -pg"

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
#ARG extracxxflags="-std=c++0x"
#ARG CONFIG_CPP="update-alternatives --set gcc /usr/bin/gcc-6"

#* ProgPOW (ethminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/ifdefelse/ProgPOW.git
#ARG MINER_FOLDER=ProgPOW
#ARG MINER_KERNELS
#ARG MINER_CONFIG="cmake -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs -DETHASHCL=OFF -DETHASHCUDA=ON -DETHSTRATUM=ON --build ."

#* UBQminer (ethminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/ubiq/ubqminer.git
#ARG MINER_FOLDER=ubqminer

#* Grin
#ARG MINER_GIT_URL=https://github.com/mimblewimble/grin.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=grin
#ARG MINER_EXE="/lib/x86_64-linux-gnu/libncursesw.so.5 /lib/x86_64-linux-gnu/libtinfo.so.5 target/release/grin"

#* Grin miner
#ARG MINER_GIT_URL=https://github.com/mimblewimble/grin-miner.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=grin-miner
#ARG MINER_EXE="/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu/libncursesw.so.5 /lib/x86_64-linux-gnu/libtinfo.so.5 target/release/grin-miner grin-miner.toml"

#* Nheqminer Cuda Tromp Nvidia (parent)
#ARG MINER_GIT_URL=https://github.com/nicehash/nheqminer.git
#ARG MINER_GIT_BRANCH=Linux
#ARG MINER_FOLDER=nheqminer/Linux_cmake/nheqminer_cuda_tromp
#ARG MINER_EXE=nheqminer_cuda_tromp
#ARG MINER_GEN="cd ../../cpu_xenoncat/Linux/asm ;./assemble.sh"
#ARG MINER_CONFIG="cmake COMPUTE=30;40;50 ."

#* Nheqminer VerusCoin Cuda Tromp Nviaia (nheqminer Cuda Tromp fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/veruscoin/nheqminer.git

#* Nheqminer XMP SilentArmy AMD (parent)
#ARG MINER_GIT_URL=https://github.com/nicehash/nheqminer.git
#ARG MINER_GIT_BRANCH=Linux
#ARG MINER_FOLDER=nheqminer/Linux_cmake/nheqminer_AMD
#ARG MINER_EXE=nheqminer_AMD
#ARG MINER_KERNELS="../../3rdparty/amd_bins_linux/* ../../3rdparty/amd_silentarmy_kernels/*"
#ARG MINER_CONFIG="cmake . -DOPENCL_LIBRARY=/usr/lib/x86_64-linux-gnu/libOpenCL.so -DOPENCL_INCLUDE_DIRECTORY=/opt/AMDAPPSDK-3.0/include"

#* Nheqminer VerusCoin AMD (nheqminer AMD fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/veruscoin/nheqminer.git
#ARG MINER_FOLDER=nheqminer/Linux_cmake/nheqminer_cuda_tromp
#ARG MINER_EXE=nheqminer_cuda_tromp
#ARG MINER_GEN="cd ../../cpu_xenoncat/Linux/asm ;./assemble.sh"
#ARG MINER_CONFIG="cmake ."

#* Nheqminer Bitcoin Gold
#ARG MINER_GIT_URL=https://github.com/martin-key/nheqminer-bitcoin-gold.git
#ARG MINER_GIT_BRANCH=kost
#ARG MINER_FOLDER=nheqminer-bitcoin-gold/nheqminer
#ARG MINER_EXE=nheqminer
#ARG MINER_CONFIG="cmake -DXENON=1 -DMARCH=-m64 ."

#* Nsgminer
#ARG MINER_GIT_URL=https://github.com/ghostlander/nsgminer.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=nsgminer
#ARG MINER_EXE=nsgminer
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG="./configure --with-cuda=/usr/local/cuda"

#* SGminer-GM (parent)
#ARG MINER_GIT_URL=https://github.com/tpruvot/sgminer.git
#ARG MINER_GIT_BRANCH=ethash
#ARG MINER_FOLDER=sgminer
#ARG MINER_EXE=sgminer
#ARG MINER_KERNELS=kernel
#ARG MINER_GEN=./autogen.sh
#ARG MINER_CONFIG=./configure
#ARG extracflags="-g -O2"

#* FancyIX (sgminer fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/fancyIX/sgminer-phi2-branch.git
#ARG MINER_GIT_BRANCH=master
#ARG MINER_FOLDER=sgminer-phi2-branch
#ARG MINER_GEN="autoreconf -i"

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

#* XMR-aeon-Stak (xmr-stak fork, duplicate values above omitted below)
#ARG MINER_GIT_URL=https://github.com/IndeedMiners/xmr-aeon-stak.git
#ARG MINER_GIT_BRANCH=dev
#ARG MINER_FOLDER=xmr-aeon-stak

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

RUN git clone $MINER_GIT_URL --branch $MINER_GIT_BRANCH --single-branch --recursive

WORKDIR /build/$MINER_FOLDER
RUN if [ -f .gitmodules ] ; then git submodule update --init ; fi

RUN $CONFIG_CPP

RUN $MINER_GEN

RUN \
    CUDA_CFLAGS="$extracuda_cflags" \
    CXXFLAGS="$extracxxflags" \
    CFLAGS="$extracflags" \
    $MINER_CONFIG

RUN printf "#!/bin/bash\n\
git pull \n\
#* for ccminer compatability \n\
if [ -f Makefile.am ] ; then sed -E 's/^#(nvcc_ARCH.*$)/\1/' -i Makefile.am ; fi \n\
#* for nheqminer compatability \n\
if [ -f CMakeLists.txt ] ; then sed -E 's/ -gencode arch=compute_20,code=sm_21;//' -i CMakeLists.txt ; fi \n\
if [ -f Cargo.toml ] ; then cargo build ; else make ; fi \n\
strip $MINER_EXE \n\
if [ ! -d /host/$MINER_FOLDER ] ; then mkdir /host/$(echo $MINER_FOLDER | cut -d / -f 1) ; fi \n\
rsync -av $MINER_EXE /host/$(echo $MINER_FOLDER | cut -d / -f 1) \n\
if [ $MINER_KERNELS ] ; then cp -r $MINER_KERNELS /host/$MINER_FOLDER/kernels ; fi" > run.sh \
&&  chmod u+x run.sh

CMD ["/bin/bash", "-c", "./run.sh"]
