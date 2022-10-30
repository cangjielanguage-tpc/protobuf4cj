# 安装选项
BIN_DESTDIR		= /usr/local/bin

# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2

# 链接选项
LD_FLAGS		= -L$(OUTPUT) -L$(OUTPUT)/protobuf -L$(OUTPUT)/json -lgoogle.protobuf -lgoogle.protobuf.compiler -lprotobuf-cj -ljson
LD_FLAGS_ADD	=

# ---- 目标
TARGET			= $(OUTPUT)/protoc-gen-cj
FFI_STDIO		= $(OUTPUT)/ffi-stdio.o

all: protoc

protoc: $(TARGET)
$(TARGET): ./*.cj $(FFI_STDIO)
	cjc $(CJC_FLAGS) -p . $(FFI_STDIO) --import-path $(OUTPUT) $(LD_FLAGS) $(LD_FLAGS_ADD) -o $@

$(FFI_STDIO): ./stdio.ffi.c
	install -d $(OUTPUT)
	gcc -g -c -fPIE $^ -o $@

install:
	-cp -a $(TARGET) $(BIN_DESTDIR)

clean:
	-rm -rf $(TARGET) $(FFI_STDIO)

.PHONY: all protoc install clean