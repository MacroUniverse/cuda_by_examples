# Makefile

exe = julia.x

#========  settings for MatFile ====================a
mode = 3
ifeq ($(mode),1)
    # binary mode
    MatPath = ../../MatFile_linux/
    MatCompile = -I $(MatPath) -D MATFILE_BINARY 
    MatLink = -I $(MatPath) -Xcompiler \"-Wl,-rpath,$(MatPath)bin/\" -L$(MatPath)bin/ -l mat -l mx
endif
ifeq ($(mode),2)
    # text mode
    MatCompile = -D MATFILE_PRECISION=8
endif
ifeq ($(mode),3)
    # dual mode
     MatPath = ../../MatFile_linux/
    MatCompile = -I $(MatPath) -D MATFILE_DUAL -D MATFILE_PRECISION=8
    MatLink = -I $(MatPath) -Xcompiler \"-Wl,-rpath,$(MatPath)bin/\" -L$(MatPath)bin/ -l mat -l mx
endif
#=================================================


source = julia.cu nr3plus.cu matsave.cu
objects = $(source:.cu=.o)
compiler = nvcc

flags = -arch=sm_60 -O3 -std=c++11
# -g -O3 -fopenmp

$(exe):$(objects)
	$(compiler) -o $(exe) $(flags) $(objects) $(MatLink)

$(objects):$(source)
	$(compiler) -c $(flags) $(source) $(MatCompile)

# clean all except source
clean:
	rm -f *.o *.x *.gch *.mat *.matt Data/*.mat Data/*.matt

