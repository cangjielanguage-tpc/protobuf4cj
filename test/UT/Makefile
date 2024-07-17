# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2 -Woff unused

# 链接选项
LD_FLAGS		= -L$(OUTPUT) -L$(OUTPUT)/protobuf -lprotobuf-cj
LD_FLAGS_ADD	= -L$(OUTPUT)/proto -lgrouptest

# ---- 目标
TARGET			= $(OUTPUT)/ut.bench

all: $(TARGET)
$(TARGET): ./*.cj $(OUTPUT)/proto/grouptest.cjo
	cjc $(CJC_FLAGS) --test -p ./ --import-path $(OUTPUT) $(LD_FLAGS) $(LD_FLAGS_ADD) -o $@

$(OUTPUT)/proto/grouptest.cjo: $(OUTPUT)/proto/grouptest/*.pb.cj
	cjc $(CJC_FLAGS) --import-path $(OUTPUT) --output-type staticlib --output-dir $(OUTPUT)/proto --module-name proto -p $(OUTPUT)/proto/grouptest/

$(OUTPUT)/proto/grouptest/*.pb.cj: ./protofile/*.proto
	install -d $(OUTPUT)/proto
	protoc --plugin=$(OUTPUT)/protoc-gen-cj --cj_out=$(OUTPUT)/proto $^

clean:
	-rm -rf $(TARGET)
	-rm -rf $(OUTPUT)/proto

.PHONY: all clean