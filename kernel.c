asm("org 0x0700\n");
asm("mov sp, 0xF000");

void main(){

    //Just to test that the jump was successful
    puts("\r\nWelcome!\r\n");

    asm("jmp $\n");
}


#include "oslib.c"
