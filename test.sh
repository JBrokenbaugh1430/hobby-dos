smlrcc -flat16 -origin 0x7C00 -doss -nobss -entry _main -S test.c -o test.asm
yasm -f bin test.asm -o test.bin
dd if=test.bin of=test.img bs=1 seek=0 conv=notrunc

qemu-system-i386 -drive file=test.img,format=raw -monitor stdio 