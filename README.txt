# AL_HW5

# 描述你程式的內容

  hw6_test.s 會直接在 data section 中，輸入一串數字。
  之後會把 array size 載入到 r0 、 array address 載入到 r1 ，再把他們推到 stack 裡面傳給 NumSort 函式。 
  numsort.s 先把 hw5_test.s 中傳入的參數 load 出來，之後再 malloc 陣列大小的空間，並把位址存在 r8，
  之後就透過選擇排序法每次都從未排序的陣列中取出最小的，放在已排序的最後。過程中，皆有符合 APCS 規範，透過 r0 r1 傳遞參數。
  透過semihosting，使用”SWI #0x123456”來執行open(),write(),close()這些動作
  
 # 執行結果
 
 result.txt:1,3,6,9,10,11,20,40
 
# 如何編譯程式

./arm-none-eabi-gcc -g ./hw6_test.s  ./numsort.s -o hw6

# 如何執行你的程式

./arm-none-eabi-insight hw6
