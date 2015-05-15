% This command line will work to compile mym on the Lancaster University HEC cluster
mex -I/usr/shared_apps/packages/mysql-5.5.25/include -L/usr/shared_apps/packages/mysql-5.5.25/lib -I/usr/include -L/usr/lib -lz -lmysqlclient mym.cpp        
