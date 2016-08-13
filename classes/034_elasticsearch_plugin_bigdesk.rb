class ElasticsearchPluginBigdesk < Item
def initialize
    super("Install ElasticSearch Plugin Bigdesk", "off")
  end
  def check_status
  end
  def run
    puts "[-] installing bigdesk"
    system("yum -y update nss")
    system("/usr/share/elasticsearch/bin/plugin -install lukas-vlcek/bigdesk ")

  end
end