void putc(char c){

    char var = 'f';
    asm("mov ah, 0x0E\nmov byte al, [bp-2]\nint 0x10\n");
    asm("mov ah, 0x0E\nmov byte al, [bp+4]\nint 0x10\n");
    return;
}

void puts(char* string){

    
    asm(

        "push si\n"
        "mov si, [bp+4]\n"
      
        //Get the address of the first parameter passed(string)
      
        
        "load_char:\n"
            
            //Load the current character of the string into AL
            "lodsb\n"
            "cmp al, 0\n"
            
            //Stop if null terminator is reached
            "jz exit\n" 

            //Print character if not null
            "mov ah, 0x0E\n"
            "int 0x10\n"
            "jmp load_char\n"


        //Return callee-saved registers to original state and exit(return handled outside of inline assembly)
        "exit:\n"
            "pop si\n"

    );
    return;
}

