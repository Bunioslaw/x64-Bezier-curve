CC = gcc
CFLAGS = -m64 -Wall
LDFLAGS = -lallegro -lallegro_primitives

all: main.o bezier.o
	$(CC) $(CFLAGS) main.o bezier.o -o bezier $(LDFLAGS)

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

bezier.o: bezier.s
	nasm -f elf64 bezier.s -o bezier.o

r:
	del *.o
	del bezier.exe
	make all

c:
	del *.o bezier.exe
