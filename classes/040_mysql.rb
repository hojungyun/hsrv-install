class Mysql < Item
  def initialize
    super("Install MySQL 5.7", "off")
  end
  def check_status
  end
  def run
    puts "[-] installing mysql 5.7"
    system("yum -y localinstall https://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm")
    system("yum -y install mysql-community-server")
    system("chkconfig mysqld on")
    system("service mysqld start")
    system("grep 'temporary password' /var/log/mysqld.log")
    system("mysql_secure_installation")
    system("echo 'bind-address=127.0.0.1' >> /etc/my.cnf")
    system("service mysqld restart")
  end
end