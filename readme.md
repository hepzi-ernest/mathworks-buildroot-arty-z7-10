# MathWorks&reg; Buildroot

The MathWorks build system is [documented here](board/mathworks/doc/readme.md).

The original buildroot documentation can be [found here](README).

# To build on Ubuntu 22.04  
1. Downgrade the gcc version to 9  
2. Download the linaro toolchain from https://releases.linaro.org/components/toolchain/binaries/6.3-2017.02/arm-linux-gnueabihf/gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf.tar.xz to /opt/linaro/aarch32-6.3.1-2017.02  
3. python2 build.py -c board/mathworks/zynq/boards/zybo/catalog.xml  

Note: Probably one of the deleted patch in the fakeroot package was unnecessary
