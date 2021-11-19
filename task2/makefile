CXX := g++
BINS = server_basic
CFLAGS = -O2

.PHONY : all
all : $(BINS)

server_basic : server_basic.cpp
	$(CXX) $(CFLAGS) -o $@ $^
	

.PHONY : clean
clean :
	rm -rf $(BINS)

