# 安装选项
LIB_DESTDIR		= /usr/local/lib
CANGJIE_DESTDIR	= $(CANGJIE_PATH)

# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2

# lib 选项
# lib 类型, "dy" or "static"
LIB_TYPE		= static

all: protobuf

# 安装
install:
	make -C third_party/json install OUTPUT=$(abspath $(OUTPUT)) LIB_DESTDIR=$(LIB_DESTDIR) CANGJIE_DESTDIR=$(CANGJIE_DESTDIR)
	make -C src/protobuf install OUTPUT=$(abspath $(OUTPUT)) LIB_DESTDIR=$(LIB_DESTDIR) CANGJIE_DESTDIR=$(CANGJIE_DESTDIR)

protobuf: json
	make -C src/protobuf protobuf OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)" LIB_TYPE=$(LIB_TYPE)

json:
	make -C third_party/json json OUTPUT=$(abspath $(OUTPUT)) CJC_FLAGS="$(CJC_FLAGS)" LIB_TYPE=$(LIB_TYPE)

clean:
	-rm -rf $(OUTPUT)

.PHONY: all protobuf json install clean