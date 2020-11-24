set -xe

gprbuild --target=arm-eabi
arm-eabi-objcopy -O binary obj/main obj/main.bin
pyocd flash -a 0x00000000 obj/main.bin
