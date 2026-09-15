#compile bootloader and add to disk
smlrcc -flat16 -origin 0x7C3D -doss -nobss -entry _boot -S bootldr.c -o bootldr.asm
yasm -f bin bootldr.asm -o bootldr.bin
gio trash osdisk.img

dd if=/dev/zero of=osdisk.img bs=32901120B count=1
mkfs.fat -F 16 -g 255/63 osdisk.img
dd if=bootldr.bin of=osdisk.img bs=1 seek=61 conv=notrunc


#compile kernel and add to disk
smlrcc -flat16 -origin 0x0700 -doss -nobss -entry _boot -S kernel.c -o kernel.asm
yasm -f bin kernel.asm -o kernel.bin
mcopy -i osdisk.img kernel.bin ::/kernel.bin

qemu-system-i386 -drive file=osdisk.img,format=raw -monitor stdio 