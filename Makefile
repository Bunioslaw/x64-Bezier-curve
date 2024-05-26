CC = gcc
CFLAGS = -m64 -Wall

all: main.o f.o
	$(CC) $(CFLAGS) main.o f.o -o f

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

f.o: f.s
	nasm -f elf64 f.s
	
recompile:
	rm -rf *.o
	rm -rf f
	make all

clean:
	rm -rf *.o f