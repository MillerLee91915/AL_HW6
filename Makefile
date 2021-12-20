
all:hw6_test.s numsort.s
	arm-none-eabi-gcc -g ./hw6_test.s  ./numsort.s -o hw6
clean:
	rm -f hw6
