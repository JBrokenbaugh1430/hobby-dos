This project was turned into a repository for the purpose of showing how a basic operating system is made.
This may be made distributable in the future.
Originally I used C more extensively, however, after deciding to restart this project, I decided to drop the bulky custom structs I used last time and use C mainly as a wrapper to control the execution flow of Assembly.


## A basic overview of the compilation process of this:
1. The code for the bootloader and kernel are written
2. A fresh FAT16 disk image is made
3. The bootloader is compiled to a binary and inserted into the MBR
4. The kernel is compiled to a binary and copied to the disk image
5. The disk image is loaded as a virtual machine in QEMU
