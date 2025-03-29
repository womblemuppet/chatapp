# Steps for fresh start of mysql:

# Start mysql container
# Clear data directory ( /var/lib/mysql/ )
# mysqld --initialize (or just mysqld --initialize-insecure)
# restart mysql container (will launch mysqld when it starts)

# Run to set up users:

ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
ALTER USER 'mysql_user'@'localhost' IDENTIFIED BY 'password';

CREATE USER IF NOT EXISTS 'mysql_user'@'localhost' IDENTIFIED BY 'mysql';
CREATE USER IF NOT EXISTS 'mysql_user'@'%' IDENTIFIED BY 'mysql';
GRANT ALL PRIVILEGES ON chatapp_main_db.* TO 'mysql_user'@'%';
GRANT ALL PRIVILEGES ON chatapp_main_db.* TO 'mysql_user'@'localhost';

FLUSH PRIVILEGES;

# restart mysqld


# SCHEMA:
CREATE DATABASE chatapp_main_db;
USE chatapp_main_db;

CREATE TABLE users (
  id INT(10) NOT NULL AUTO_INCREMENT,
  username varchar(255),
  password_hash varchar(255)
);
