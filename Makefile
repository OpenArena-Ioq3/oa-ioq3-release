.PHONY: release engine_windows engine_linux clean_engine clean_output clean distclean

ENGINE_DIR := openarena-ioq3
LINUX_ENGINE_BINARY_DIR := $(ENGINE_DIR)/build/release-linux-x86_64/
WINDOWS_ENGINE_BINARY_DIR := $(ENGINE_DIR)/build/release-mingw32-x86_64/
ENGINE_OPTS := 

OUTPUT_DIR := build

WINDOWS_OUTPUT_DIR := $(OUTPUT_DIR)/windows
LINUX_OUTPUT_DIR := $(OUTPUT_DIR)/linux

TIMESTAMP = @$(shell cd $(ENGINE_DIR) && git show -s --format=%ct)
ENGINE_ZIP_BASE = $(shell cd $(ENGINE_DIR) && \
			git rev-parse --short=11 HEAD).zip
LINUX_ENGINE_ZIP = $(ENGINE_DIR)-linux-$(ENGINE_ZIP_BASE)
WINDOWS_ENGINE_ZIP = $(ENGINE_DIR)-windows-$(ENGINE_ZIP_BASE)

release: engine_linux engine_windows $(LINUX_OUTPUT_DIR) $(WINDOWS_OUTPUT_DIR)
	cp $(LINUX_ENGINE_BINARY_DIR)/{oa-ioq3ded.x86_64,oa-ioquake3.x86_64,renderer_opengl1_x86_64.so,renderer_opengl2_x86_64.so} \
		$(LINUX_OUTPUT_DIR)
	cp $(WINDOWS_ENGINE_BINARY_DIR)/{oa-ioq3ded.x86_64.exe,oa-ioquake3.x86_64.exe,renderer_opengl1_x86_64.dll,renderer_opengl2_x86_64.dll,SDL264.dll} \
		$(WINDOWS_OUTPUT_DIR)
	cd $(LINUX_OUTPUT_DIR) && zip -r ../$(LINUX_ENGINE_ZIP) .
	cd $(WINDOWS_OUTPUT_DIR) && zip -r ../$(WINDOWS_ENGINE_ZIP) .

engine_windows:
	$(MAKE) -C $(ENGINE_DIR) $(ENGINE_OPTS) PLATFORM=mingw32 ARCH=x86_64

engine_linux:
	$(MAKE) -C $(ENGINE_DIR) $(ENGINE_OPTS)

$(WINDOWS_OUTPUT_DIR): $(OUTPUT_DIR)
	mkdir -p $(WINDOWS_OUTPUT_DIR)

$(LINUX_OUTPUT_DIR): $(OUTPUT_DIR)
	mkdir -p $(LINUX_OUTPUT_DIR)

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

clean_engine:
	$(MAKE) -C $(ENGINE_DIR) clean

clean_output:
	rm -rf $(OUTPUT_DIR)

clean: clean_engine clean_output

distclean: clean_output
	$(MAKE) -C $(ENGINE_DIR) distclean
