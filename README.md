# docker-ethos-open-source-miner-builder
This Docker makes building or updating your preferred open source miner for ethOS without polluting your system with openCL CUDA libraries and development tools. The resulting binary can be used to replace the existing miner binary in /opt/miners/minerfolder/minerbinary of your mining rig. 

## ethOS 
This project makes binaries that are compatiable to run on ubuntu 14 / 16 computers which is compatiable with ethOS.

Make sure to backup the existing binary. Please be aware that the new binary will get replaced with every update of ethOS (ethos-update) and/or its miners (update-miners). 

If you have expanded the space on your ethOS miner you can install docker with `sudo hotfix docker-install`. If you also install this to /opt/miners then when it builds the miner will be deployed to the proper directory. 

Note: This Dockerfile can build many more miners than ethOS supports. If you choose to use them please be forewarned that ethOS does not support miners that it did not ship with. Features like hash monitor and using the local.conf are highly customized and do not always support miner updates without official releases that patch these features. Learn more here: https://github.com/cynixx3/third-party-miner-installer-for-ethos

## Build Method 1 (single miner w/ file edits)
There are a few ways to command the build file one way would be to just uncomment variables for the miner you want in Dockerfile, then run `docker build -t miner .` to build the miner environment where you can replace "miner" with its name. 

Then to compile, or recompile the miner with any updates run `docker run -v $(pwd):/host -it miner` (for windows set the absolute path of the directory you want the miner to be copied to IE `docker run -v C:\Miners:/host -it miner`)

For the first time you can do both and subsquient rebuilds only need the second command.
```docker build -t miner . && docker run -v $(pwd):/host -it miner```

### Optional For Method 1 and 2
To allow easy future updates a script like 
```
#!/bin/bash
docker run -v $(pwd):/host -t $1
```
will allow you to run a command like `./build.sh xmr-stak` or `./build.sh progpowminer` and it will update that miner quickly.

## Build Method 2 (single miner w/ CLI)
With Docker any build-arg's in the build command will overwrite the ones in the Dockerfile you can use --build-args flags like the following to build xmr-stak without edits to the Dockerfile:

`docker build -t miner --build-arg MINER_GIT_URL=https://github.com/fireice-uk/xmr-stak.git --build-arg MINER_GIT_BRANCH=master --build-arg MINER_FOLDER=xmr-stak --build-arg MINER_GEN="" --build-arg MINER_CONFIG="cmake -DXMR-STAK_COMPILE=generic -DCPU_ENABLE=ON -DCMAKE_LINK_STATIC=ON -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON --build ." --build-arg MINER_EXE="bin/xmr-stak bin/libxmrstak_cuda_backend.so bin/libxmrstak_opencl_backend.so" .`

When that is done run the same `docker run -v $(pwd):/host -it miner` as above (or for windows `docker run -v C:\Miners:/host -it miner`) to compile and copy to the miner to the current directory. When you want to update the miner just the docker run command will quickly compile the miner if the image is still around.

Explination of some build-arg variables:
- MINER_GIT_URL is the full github .git url
- MINER_GIT_BRANCH is any checkout, branch, tag, or commit
- MINER_FOLDER is the folder git clone creates
- MINER_GEN is for autogen or autoconf commands and its flags (can be blank)
- MINER_CONFIG is the command before compiling and its flags
- MINER_EXE has any final compiled files you want to copy out of the docker and to the host
- MINER_KERNELS is the folder path to the miner extras like a directory of kernels 

There are more build args in the Dockerfile for use with other miners.

## Build Method 3 (multiple miners)
The other way to build the image and start the container (which will exit immediately) is to open docker-compose.yml and comment or uncomment the section with the miner you want, then run `docker-compose up`. Docker will compile the miner and copy it to the host. You can run `docker-compose down` to close the docker images.

If you make Dockerfile changes after running compose up, then to rebuild without having to delete all images and start fresh (within the same cuda version / opencl version), run `docker-compose up --build`. 

To pull the latest miner code, re-compile, and copy the latest version to the host just command `docker-compose up` again. If the images are still around it will be a quick process.

## For All Methods

Once the image build was successful and the container was created using the up or run commands, the binaries will be copied from the container to the host automatically in the same directory the docker was run in, at that point you can just transfer it to a mining rig IE for ethOS: /opt/miners/xmr-stak/xmr-stak.

* Note: With either method this docker will overwrite same named files on the host.

* Note: Miner folders will likely be root after building, to fix run `sudo chown -R $(whoami).$(whoami) *`


## Contributing

If you got a new miner working using these tools or just improved an intergration please submit a pull request with a new branch for the miner you added.

## Authors

* **[cYnIxX3](https://github.com/cynixx3)**
This script was not funded or sponsored by any organization. If you found this script useful please donate 
~~~
~ BitCoin to:
~ BTC 1G6DcU8GrK1JuXWEJ4CZL2cLyCT57r6en2
~ or Ethereum to:
~ ETH 0x42D23fC535af25babbbB0337Cf45dF8a54e43C37
~~~

### Licensing

This is free to use privately. If packaged in a commercial solution please contact cynixx3@gmail.com.
