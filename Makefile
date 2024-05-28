CC = gcc
CFLAGS = -m64 -Wall
LDFLAGS = -lallegro -lallegro_image -lallegro_primitives -lallegro_font -lallegro_ttf -lallegro_main

all: main.o f.o
	$(CC) $(CFLAGS) main.o f.o -o f $(LDFLAGS)

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

f.o: f.s
	nasm -f elf64 f.s -o f.o

r:
	del *.o
	del f.exe
	make all

c:
	del *.o f.exe
