# compile and link helloworld.exe
all:        
	nasm -f win32 neli.asm -o main.obj        
	c:\mingw\bin\gcc -O3 main.obj -o neli.exe
# delete the generated .obj and .exe 
clean:        
	rm -rf main.obj neli.exe