# modified from https://makefiletutorial.com/
CC = gcc
CFLAGS = -m64 -Og -g -Wall -Werror
LDFLAGS = -pthread

BUILD_DIR := build

SRCS := $(shell find . -name "*.c")
EXES := $(basename $(SRCS))

all: $(EXES)

$(EXES): %: $(BUILD_DIR)/%
	$<

# implied in default targets
# $(BUILD_DIR)/%: $(BUILD_DIR)/%.o

# https://stackoverflow.com/questions/15189704/makefile-removes-object-files-for-no-reason
.PRECIOUS: $(BUILD_DIR)/%.o
$(BUILD_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean $(EXES)
