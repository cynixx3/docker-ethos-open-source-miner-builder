# docker-ethos-open-source-miner-builder
Docker which makes building or updating your own or preferred open source miner for ethOS without polluting your system with openCL and CUDA libraries. The resulting binary can be used to replace the existing miner binary in /opt/miners/minerfolder/minerbinary of your mining rig. Make sure to backup the existing binary. Please be aware that the new binary will get replaced with every update of ethOS (ethos-update) and/or its miners (update-miners). 

If you have expanded the space on your ethOS miner you can install docker with `sudo hotfix docker-install`. If you also install this to /opt/miners then when it builds the miner will be deployed to the proper directory. 

Build Method 1
There are a few ways to command the build file one way would be to just uncomment variables for the miner you want, then run `docker build -t miner .` to build the miner environment. 

Then to compile, or recompile the miner with any updates run `docker run -v $(pwd):/host -it miner` (for windows set the absolute path of the directory you want the miner to be copied to IE `docker run -v C:\Miners:/host -it miner`)

Build Method 2
With Docker any build-arg's in the build command will overwrite the ones in the Dockerfile you can use --build-args flags like the following to build xmr-stak without edits to the Dockerfile:

`docker build -t miner --build-arg MINER_GIT_URL=https://github.com/fireice-uk/xmr-stak.git --build-arg MINER_GIT_BRANCH=master --build-arg MINER_FOLDER=xmr-stak --build-arg MINER_GEN="" --build-arg MINER_CONFIG="cmake -DXMR-STAK_COMPILE=generic -DCPU_ENABLE=ON -DCMAKE_LINK_STATIC=ON -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON --build ." --build-arg MINER_EXE="bin/xmr-stak bin/libxmrstak_cuda_backend.so bin/libxmrstak_opencl_backend.so" .`

When that is done run `docker run -v C:\Miners:/host -it miner` to compile and copy to the miner to the current directory. When you want to update the miner just the docker run command will quickly compile the miner if the image is still around.

- MINER_GIT_URL is the full github .git url
- MINER_GIT_BRANCH is any checkout, branch, tag, or commit
- MINER_FOLDER is the folder git clone creates
- MINER_GEN is for autogen or autoconf commands and its flags (can be blank)
- MINER_CONFIG is the command before compiling and its flags
- MINER_EXE has any final compiled files you want to copy out of the docker and to the host
- MINER_KERNELS is the folder path to the miner extras like a directory of kernels 

There are more build args in the Dockerfile for use with other miners.

Build Method 3
The other way to build the image and start the container (which will exit immediately) is to open docker-compose.yml and comment or uncomment the section with the miner you want, then run `docker-compose up`. Docker will compile the miner and copy it to the host. You can run `docker-compose down` to close the docker images.

If you make Dockerfile changes after running compose up, then to rebuild without having to delete all images and start fresh (within the same cuda version / opencl version), run `docker-compose up --build`. 

To pull the latest miner code, re-compile, and copy the latest version to the host just command `docker-compose up` again. If the images are still around it will be a quick process.

For All Methods

Once the image build was successful and the container was created using the up or run commands, the binaries will be copied from the container to the host automatically in the same directory the docker was run in, at that point you can just transfer it to a mining rig IE for ethOS: /opt/miners/xmr-stak/xmr-stak.

Note: With either method this docker will overwrite same named files on the host.

Note: Miner folders will likely be root after building, to fix run `sudo chown -R $(whoami).$(whoami) *`

Note: This Dockerfile can build many more miners than ethOS supports. If you choose to use them please be forewarned that ethOS does not support miners that it did not ship with. Features like hash monitor and using the local.conf are highly customized and do not always support miner updates without official releases that patch these features. Learn more here: https://github.com/cynixx3/third-party-miner-installer-for-ethos

---
Licensing

This is free to use privately. If packaged in a commercial solution please contact cynixx3@gmail.com.
