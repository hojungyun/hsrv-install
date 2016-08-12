class Elasticsearch < Item
  def initialize
    super("Install ElasticSearch 1.7.x", "off")
  end
  def check_status
  end
  def run
    puts "[-] installing elasticsearch 1.7.x"
    system("rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch")
    repo = <<EOF
[elasticsearch-1.7]
name=Elasticsearch repository for 1.7.x packages
baseurl=http://packages.elastic.co/elasticsearch/1.7/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
EOF
    File.open("/etc/yum.repos.d/elasticsearch.repo", 'w') do |file|
      file.puts repo
    end
    system("yum -y install elasticsearch")
    system("service elasticsearch start")
    system("chkconfig --add elasticsearch")
    system("chkconfig elasticsearch on")

  end
end