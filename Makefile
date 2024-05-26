# Nazwa pliku wykonywalnego
TARGET = program

# Kompilator i asembler
CC = gcc
ASM = nasm

# Flagi kompilatora
CFLAGS = -Wall -g

# Flagi asemblera
ASMFLAGS = -f elf64

# Pliki źródłowe
C_SOURCES = main.c
ASM_SOURCES = f.asm

# Pliki obiektowe
OBJS = $(C_SOURCES:.c=.o) $(ASM_SOURCES:.asm=.o)

# Reguła domyślna
all: $(TARGET)

# Reguła budowania pliku wykonywalnego
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Reguła budowania plików obiektowych z plików C
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Reguła budowania plików obiektowych z plików ASM
%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

# Reguła czyszczenia
clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
