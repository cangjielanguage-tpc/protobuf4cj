# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2

# lib 选项
# lib 类型, "dy" or "static"
LIB_TYPE		= static

# ---- 目标
PACKAGE_GOO_PB	= $(OUTPUT)/google.protobuf.cjo
PACKAGE_GOO_PBC = $(OUTPUT)/google.protobuf.compiler.cjo

all: google

google: $(PACKAGE_GOO_PB) $(PACKAGE_GOO_PBC)

$(PACKAGE_GOO_PB): ./protobuf/*.cj
	install -d $(OUTPUT)
	cjc $(CJC_FLAGS) -p ./protobuf --output-type=$(LIB_TYPE)lib --import-path $(OUTPUT) --output-dir $(OUTPUT)

$(PACKAGE_GOO_PBC): ./protobuf/compiler/*.cj $(PACKAGE_GOO_PB)
	cjc $(CJC_FLAGS) -p ./protobuf/compiler --output-type=$(LIB_TYPE)lib --import-path $(OUTPUT) --output-dir $(OUTPUT)

clean:
	-rm -rf $(OUTPUT)/google.protobuf.* $(OUTPUT)/libgoogle.protobuf.*

.PHONY: all google clean