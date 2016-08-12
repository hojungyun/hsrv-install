# hsrv-install
This is a ruby script to install hsrv host.

### Installation

1. Install CentOS

2. Verify the Internet connected

3. Install Ruby
 ```sh
 curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
 curl -L get.rvm.io | bash -s stable
 source /etc/profile.d/rvm.sh
 rvm install 2.2.2 
 rvm list rubies
 rvm use 2.2.2 --default
 ruby -v
 ```

4. Download the script from Github
 ```sh
 yum -y install git
 git clone https://github.com/hojungyun/hsrv-install.git
 ```

5. Run the script
 ```sh
 cd hsrv-install
 ./post_hsrv.rb
 ```

### Development

The script includes the followings
- Yum update
- Install Java8
- Install ElasticSearch
- Install MySQL
- Install Ntpd
