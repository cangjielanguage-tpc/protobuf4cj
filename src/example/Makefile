# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g

# 链接选项
LD_FLAGS		= -L$(OUTPUT)/protobuf -lprotobuf-cj -lreflection
LD_FLAGS_ADD	=

# ---- 目标
TARGET			= $(OUTPUT)/example

all: build

run: build
	$(TARGET)

build: $(TARGET)
$(TARGET): ./*.cj
	cjc $(CJC_FLAGS) -p . --import-path $(OUTPUT) $(LD_FLAGS) $(LD_FLAGS_ADD) -o $@

clean:
	-rm -rf $(TARGET)

.PHONY: all build run clean