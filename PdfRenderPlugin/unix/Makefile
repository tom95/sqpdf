PLUGIN_NAME=PdfRenderPlugin
SOURCES=PdfRenderPlugin.c
PATH_TO_SQUEAK=../../../../
BASE=../../../../../opensmalltalk-vm
PKGLIBS=poppler-cpp

CFLAGS=-m32 \
	   -Wall \
	   -g \
	   -I$(BASE)/platforms/Cross/vm \
	   -I$(BASE)/platforms/Cross/plugins/$(PLUGIN_NAME) \
	   -I../Cross \
	   -I. \
	   -I$(BASE)/platforms/unix/vm \
	   -I$(BASE)/src/vm \
	   -I$(BASE)/build.linux64x64/squeak.cog.spur/build \
	   -DLSB_FIRST=1 \
		$(shell env PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig pkg-config --cflags $(PKGLIBS))
LDFLAGS=-m32 \
	   -shared \
	   -fPIC
CXXFLAGS=$(CFLAGS) -std=c++11
LDLIBS=$(shell env PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig pkg-config --libs $(PKGLIBS))
SOURCES += $(BASE)/src/plugins/$(PLUGIN_NAME)/$(PLUGIN_NAME).c ../Cross/$(PLUGIN_NAME).c ../Cross/pdf.cpp
CPP_OBJECTS = $(SOURCES:.cpp=.o)
OBJECTS = $(CPP_OBJECTS:.c=.o)

EXECUTABLE=$(PATH_TO_SQUEAK)/bin/$(PLUGIN_NAME)

install: $(EXECUTABLE)

$(EXECUTABLE): $(PLUGIN_NAME)
	cp $(PLUGIN_NAME) $(EXECUTABLE)

$(PLUGIN_NAME): $(OBJECTS)

clean:
	rm -f $(EXECUTABLE) $(PLUGIN_NAME) $(OBJECTS)

LINK_PLATFORM=$(BASE)/platforms/unix/plugins/$(PLUGIN_NAME)
LINK_CROSS=$(BASE)/platforms/Cross/plugins/$(PLUGIN_NAME)
symlink:
	ln -s $(shell pwd) $(LINK_PLATFORM)
	ln -s $(shell pwd)/../Cross $(LINK_CROSS)
cleansymlink:
	rm -f $(LINK_PLATFORM) $(LINK_CROSS)

.PHONY: clean install

