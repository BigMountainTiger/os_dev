kernel_source_dir := src/impl/kernel
kernel_object_dir := $(build_dir)/build/kernel

x86_64_source_dir := src/impl/x86_64
x86_64_object_dir := $(build_dir)/build/x86_64

kernel_source_files := $(shell find $(kernel_source_dir) -name *.c)
kernel_object_files := $(patsubst $(kernel_source_dir)/%.c, $(kernel_object_dir)/%.o, $(kernel_source_files))

x86_64_c_source_files := $(shell find $(x86_64_source_dir) -name *.c)
x86_64_c_object_files := $(patsubst $(x86_64_source_dir)/%.c, $(x86_64_object_dir)/%.o, $(x86_64_c_source_files))

x86_64_asm_source_files := $(shell find $(x86_64_source_dir) -name *.asm)
x86_64_asm_object_files := $(patsubst $(x86_64_source_dir)/%.asm, $(x86_64_object_dir)/%.o, $(x86_64_asm_source_files))

all_object_files := $(kernel_object_files) $(x86_64_c_object_files) $(x86_64_asm_object_files)

$(kernel_object_files): $(kernel_object_dir)/%.o : $(kernel_source_dir)/%.c
	mkdir -p $(dir $@) && \
	gcc -c -I src/intf -ffreestanding $(patsubst $(kernel_object_dir)/%.o, $(kernel_source_dir)/%.c, $@) -o $@

$(x86_64_c_object_files): $(x86_64_object_dir)/%.o : $(x86_64_source_dir)/%.c
	mkdir -p $(dir $@) && \
	gcc -c -I src/intf -ffreestanding $(patsubst $(x86_64_object_dir)/%.o, $(x86_64_source_dir)/%.c, $@) -o $@

$(x86_64_asm_object_files): $(x86_64_object_dir)/%.o : $(x86_64_source_dir)/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst $(x86_64_object_dir)/%.o, $(x86_64_source_dir)/%.asm, $@) -o $@

local_target_dir := targets
build_target_dir := $(build_dir)/targets

$(build_target_dir): $(shell find $(local_target_dir) -type f)
	mkdir -p $(build_target_dir) && \
	cp -r $(local_target_dir)/* $(build_target_dir)

build-x86_64: $(build_target_dir)

# .PHONY: build-x86_64
# build-x86_64: $(all_object_files)
# 	mkdir -p dist/x86_64 && \
# 	ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(all_object_files) && \
# 	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin && \
# 	grub-mkrescue -d /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso