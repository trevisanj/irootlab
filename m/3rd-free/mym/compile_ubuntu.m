% I used this line to compile on my Ubuntu 10.04 32 bit
% It requires Debiang packages libmysqlclient-dev and the zlib/libz? (not sure about the package, probably comes with gnome-devel)

mex -I/usr/include/mysql -I/usr/include -L/usr/lib -lz -lmysqlclient mym.cpp