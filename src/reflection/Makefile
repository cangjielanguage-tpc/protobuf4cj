# 安装选项
LIB_DESTDIR		= /usr/local/lib
CANGJIE_DESTDIR	= $(abspath $(CANGJIE_PATH))

# 构建输出选项
OUTPUT			= ./output

# 编译选项
CJC_FLAGS		= -g -O2

# lib 选项
# lib 类型, "dy" or "static"
LIB_TYPE		= static
# lib 后缀
ifeq ($(LIB_TYPE), static)
	LIB_POSTFIX	= a
else
	LIB_POSTFIX = so
endif

LIB_NAME_REFL	= reflection

# ---- 目标
CJO_REFL		= $(OUTPUT)/protobuf/reflection.cjo
LIB_REFL		= $(OUTPUT)/protobuf/lib$(LIB_NAME_REFL).$(LIB_POSTFIX)

all: reflection

# 检查环境变量
env-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

# 安装
install: env-CANGJIE_DESTDIR
	-cp -a $(LIB_REFL) $(LIB_DESTDIR)
	install -d $(CANGJIE_DESTDIR)/protobuf
	-cp -a $(CJO_REFL) $(CANGJIE_DESTDIR)/protobuf

reflection: $(CJO_REFL) $(LIB_REFL)
$(CJO_REFL) $(LIB_REFL): ./*.cj
	install -d $(OUTPUT)/protobuf
	cjc $(CJC_FLAGS) -p . --output-type=$(LIB_TYPE)lib --module-name protobuf --import-path $(OUTPUT) --output-dir $(OUTPUT)/protobuf -o lib$(LIB_NAME_REFL).$(LIB_POSTFIX)

clean:
	-rm -rf $(CJO_REFL) $(LIB_REFL)

.PHONY: all install reflection clean env-CANGJIE_DESTDIR