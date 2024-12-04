#!/bin/bash

xdotool getactivewindow windowsize 1350 350


# Compilar los archivos .asm
nasm -f elf32 main.asm
nasm -f elf32 ./src/addFirstLinkedList.asm
nasm -f elf32 ./src/fillStructure.asm
nasm -f elf32 ./src/nextNode.asm
nasm -f elf32 ./src/requestMemory.asm
nasm -f elf32 ./src/lenStr.asm
nasm -f elf32 ./src/createFile_Folder.asm
nasm -f elf32 ./src/writeFile.asm
nasm -f elf32 ./src/printUser.asm
nasm -f elf32 ./src/saveUsers.asm
nasm -f elf32 ./src/intToStr.asm
nasm -f elf32 ./src/cleanFile.asm
nasm -f elf32 ./src/Conciliate.asm
nasm -f elf32 ./src/printDebts.asm
nasm -f elf32 ./src/readFile.asm
nasm -f elf32 ./src/readUsers.asm
nasm -f elf32 ./src/strToInt.asm
nasm -f elf32 ./src/conciliateReports.asm

# Enlazar los archivos objeto
ld -s -m elf_i386 -o main main.o io.o  ./src/addFirstLinkedList.o ./src/fillStructure.o ./src/nextNode.o ./src/requestMemory.o ./src/createFile_Folder.o ./src/writeFile.o ./src/lenStr.o ./src/printUser.o ./src/saveUsers.o ./src/intToStr.o ./src/cleanFile.o ./src/printDebts.o ./src/Conciliate.o ./src/readFile.o ./src/readUsers.o ./src/strToInt.o ./src/conciliateReports.o
clear
./main