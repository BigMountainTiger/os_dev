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

iso_dir := targets/x86_64/iso
local_iso_files := $(shell find $(iso_dir) -type f ! -name "linker.ld")
build_iso_files := $(addprefix $(build_dir)/, $(local_iso_files))
kernel_bin := $(build_dir)/dist/kernel.bin
iso := $(build_dir)/dist/x86_64/kernel.iso

$(build_iso_files): $(build_dir)/% : %
	mkdir -p "$(@D)" && \
	cp "$<" "$@"

$(kernel_bin): $(all_object_files)
	mkdir -p "$(@D)" && \
	ld -n -o "$@" -T targets/x86_64/linker.ld $(all_object_files)

$(iso): $(build_iso_files) $(kernel_bin)
	cp $(kernel_bin) $(build_dir)/$(iso_dir)/boot && \
	mkdir -p "$(@D)" && \
	grub-mkrescue -d /usr/lib/grub/i386-pc -o $@ $(build_dir)/$(iso_dir)

.PHONY: build-x86_64
build-x86_64: $(iso)
