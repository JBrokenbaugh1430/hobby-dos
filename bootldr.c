asm("org 0x7C3D\n");

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
#pragma pack(push, 1)
typedef struct {

    uint8_t size;
    uint8_t reserved;
    uint16_t sector_count;
    uint16_t buffer_offset;
    uint16_t buffer_segment;
    uint16_t sector_low_1;
    uint16_t sector_high_1;
    uint16_t sector_low_2;
    uint16_t sector_high_2;
} DiskAddressPacket;


#pragma pack(pop)
char* kernel_name = "KERNEL BIN";

void boot(){

   
    //Clear screen
    
    asm(    
        
        
        //Point ES:DI to start of VRAM
        "mov ax, 0xB800\n"
        "mov es, ax\n"
        "mov di, 0\n"

        //Set to repeat 1000 times for a total of 2000 chars
        "mov cx, 1000\n"

        //Fill with blank spaces, light gray on black color
        "mov ax, 0x0720\n"
        "rep stosw\n"

        //Set cursor back to top left
        "mov bh, 0\n"
        "mov dx, 0\n"
        "mov ah, 0x02\n"
        "int 0x10\n"
    );

    puts("B");
    load_kernel();

    //This shouldn't be reached!
    //If it is, just let the user restart.
    asm("read_failed:\n");
    puts("\r\nE");
    asm(

        //Check if a key is ready
        "check_key:"
            "mov ah, 0x01\n"
            "int 0x16\n"

        //If a key has not been pressed, keep checking
        "jz check_key\n"
        "mov ah, 0x0E\n"
        "mov al, 'k'\n"
        "int 0x10\n"
        
        //If a key has been pressed, reboot
        "mov dx, 0x64\n"
        "mov al, 0xFE\n"
        "out dx, al\n"
    );
}



void load_kernel(){

    //Read and execute kernel

    lba_read(164, 1, 0, 0x700);
    uint8_t result = find_file("KERNEL BIN");
    asm("jmp $\n");
    return;
    
}   

        

void lba_read(uint16_t sector, uint16_t count, uint16_t segment, uint16_t offset){

    asm(
        //Enable LBA
        "mov ah, 0x41\n"
        "mov bx, 0x55AA\n"
        "mov dl, 0x80\n"
        "int 0x13\n"
    );

        //Format DAP
        DiskAddressPacket DAP;
        DAP.size = 16;
        DAP.reserved = 0;
        DAP.sector_count = count;
        DAP.buffer_offset = offset;
        DAP.buffer_segment = segment;
        DAP.sector_high_1 = 0;
        DAP.sector_low_1 = sector;
        DAP.sector_high_2 = 0;
        DAP.sector_low_2 = 0;


        asm(
        "lea si, [bp-16]\n"       //DS:SI now points to the DAP
        "mov ah, 0x42\n"    //Set interrupt mode
        "mov dl, 0x80\n"    //Set drive number
        "int 0x13\n"        //Call read interrupt
        
        //Jump to error message if fail
        "jc read_failed\n"
        
    );
    return;
}

//TODO: Actually make this work
uint8_t find_file(char* name){

    uint16_t reserved_sectors;
    uint16_t bytes_per_sector;
    uint16_t sectors_per_fat;
    uint16_t fat_count;

    uint16_t fat_start;
    uint16_t root_dir_start;
    asm(
        //Get reserved sectors
        "mov word ax, [0x7C0E]\n"
        "mov word [bp-2], ax\n"

        //Get bytes per sector
        "mov word ax, [0x7C0B]\n"
        "mov word [bp-4], ax\n"

        //Get sectors per FAT
        "mov word ax, [0x7C16]\n"
        "mov word [bp-6], ax\n"

        //Get FAT count
        "mov word ax, [0x7C10]\n"
        "mov word [bp-8], ax\n"
        
    );

   
    fat_start = reserved_sectors;
    root_dir_start = fat_start + (fat_count * sectors_per_fat);

    asm("jmp $\n");
}
#include "oslib.c"
