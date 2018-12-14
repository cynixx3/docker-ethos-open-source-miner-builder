# docker-ethos-ethminer
Docker image which makes building or updating your own or preferred open source miner for ethOS super easy without polluting your system with openCL and CUDA libraries. The resulting binary can be used to replace the existing miner binary in /opt/miners/minerfolder/minerbinary of your mining rig. Make sure to backup the existing binary. Please be aware that the new binary will get replaced with every manual update of ethOS (ethos-update) and/or its miners (update-miners). 

There are a couple ways to command the build file one way would be to just comment or uncomment variables for the miner you want, then run ```docker build -t miner .``` to build the miner environment. 

Then to build, or rebuild the miner with updates on linux run ```docker run -v $(pwd):/host -it miner``` or for windows set the absolute path of the directory you want the miner to be copied to ```docker run -v C:\Users\Me\Desktop:/host -it miner```

The other way to build the image and start the container (which will exit immediately) is to open docker-compose.yml and comment or uncomment the section with the miner you want, then run ```docker-compose up```

Once the image build was successful and the container was created using the up command, the binaries will be copied from the container to the host automatically in the same directory the docker was run in, so at that point you can just transfer it to a mining rig IE: /opt/miners/xmr-stak/xmr-stak.

If you make Dockerfile changes then to rebuild without having to delete all images and start fresh (within the same cuda version / opencl version) ```docker-compose up --build``` but just
```docker-compose up``` to pull the latest code, build, and copy the latest version
