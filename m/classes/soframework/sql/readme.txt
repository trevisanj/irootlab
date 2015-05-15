The file taskman.sql contains the MySQL scripts to create a new task management database.

1. In MySQL, first create a new database, e.g. xxxxx
mysql> create database xxxxx;

2. Out of MySQL, run mysqldump:
shell> mysqldump -u your_user_name -p xxxxx < taskman.sql
