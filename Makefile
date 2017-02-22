#!/usr/bin/make
# Makefile automatically generated using ./configure  
# 2017-02-22

# Build machine specs
export MACHINE  = x86_64-linux-gnu
export ARCH     = x86_64

# C compiler information
export CC       = /usr/bin/cc
export CCVER    = 6.2.0
export STDC_VER = 201112
export CFLAGS   = -O2 -Wall -Wextra -Werror -Iinclude

# Archiver information
export AR       = /usr/bin/ar
export ARFLAGS  = -cru

# Project information
export TYPE     = library
export PROJECT  = ini
export PREFIX   = /usr/local
export VERSION  = 0.1.0

export DOCS     = doc
export MANPATH  = /usr/local/man/man3
# Build information
export SRC_DIR  = src
export INC_DIR  = include
export BUILD    = build
export HEADERS  = $(wildcard $(INC_DIR)/*.h)
export SOURCE   = $(wildcard $(SRC_DIR)/*.c)
export OBJECTS  = $(SOURCE:.c=.o)
export TARGET   = $(BUILD)/$(PROJECT)

.PHONY: all clean dist install uninstall upgrade

all: $(TARGET)

clean:
	@rm -rf $(OBJECTS)

dist: $(TARGET) clean 
	@echo "creating distribution archive $(PROJECT)-$(VERSION).tar.gz"
	if [ -d $(DOCS) ]; then \
		tar -czvf $(PROJECT)-$(VERSION).tar.gz configure Makefile $(DOCS) $(TARGET) $(SRC_DIR) $(IN_DIR); \
	else \
		tar -czvf $(PROJECT)-$(VERSION).tar.gz configure Makefile $(TARGET) $(SRC_DIR) $(INC_DIR); \
	fi 

install: $(TARGET)
	if [ -f $(TARGET).a ]; then \
		mkdir -p $(PREFIX)/lib; \
		mkdir -p $(PREFIX)/include; \
		echo "installing lib$(PROJECT).a in $(PREFIX)/lib"; \
		cp -uv $(TARGET).a $(PREFIX)/lib/lib$(PROJECT).a-$(VERSION); \
		cp -tuv $(PREFIX)/ $(HEADERS); \
		ln -sf $(PREFIX)/lib/lib$(PROJECT).a-$(VERSION) $(PREFIX)/lib/lib$(PROJECT).a; \
	elif [ -f $(TARGET) ]; then \
		mkdir -p $(PREFIX)/bin; \
		echo "installing $(PROJECT) in $(PREFIX)/bin"; \
		cp -uv $(TARGET) $(PREFIX)/bin/$(PROJECT)-$(VERSION); \
		chmod 0755 $(PREFIX)/bin/$(PROJECT)-$(VERSION); \
		ln -sf $(PREFIX)/bin/$(PROJECT)-$(VERSION) $(PREFIX)/bin/$(PROJECT); \
	else \
		echo "Could not find $(TARGET) or $(TARGET).a"; \
	fi
	if [ -f $(DOCS)/$(PROJECT).[1-7] ]; then \
		mkdir -p $(MANPATH); \
		cp -uv $(DOCS)/$(PROJECT).[1-7] $(MANPATH)/; \
	fi;

uninstall:
	if [ -f $(PREFIX)/lib/lib$(PROJECT).a-$(VERSION) ]; then \
		echo "uninstalling lib$(PROJECT).a from $(PREFIX)/lib"; \
		rm -rf $(PREFIX)/lib/lib$(PROJECT).a-$(VERSION); \
		rm -rf $(PREFIX)/lib/lib$(PROJECT).a; \
	elif [ -f $(PREFIX)/bin/$(PROJECT)-$(VERSION) ]; then \
		echo "uninstalling $(PROJECT) from $(PREFIX)/bin"; \
		rm -rf $(PREFIX)/bin/$(PROJECT)-$(VERSION); \
		rm -rf $(PREFIX)/bin/$(PROJECT); \
	else \
		echo "Could not find $(PREFIX)/bin/$(PROJECT)-$(VERSION) or $(PREFIX)/lib/lib$(PROJECT).a-$(VERSION)"; \
	fi
	if [ -f $(DOCS)/$(PROJECT).[1-7] ]; then \
		rm -rf $(MANPATH)/$(PROJECT).[1-7]; \
	fi;

upgrade: install

%.o: %.c
	@echo "cc $<"
	@$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJECTS) $(HEADERS)
	@echo "building $(PROJECT)"
	@$(AR) $(ARFLAGS) $(TARGET).a $(OBJECTS)
# End of auto-generated Makefile

# Appending from Makefile.in
EXAMPLES= examples
EXSRC = $(wildcard $(EXAMPLES)/*.c)
EXOBJ = $(EXSRC:.c=.o)

example: $(EXOBJ)
	$(CC) $(CFLAGS) $(EXOBJ) $(TARGET).a -o $(BUILD)/example