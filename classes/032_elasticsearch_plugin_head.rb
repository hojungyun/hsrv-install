class ElasticsearchPluginHead < Item
def initialize
    super("Install ElasticSearch Plugin Head", "off")
  end
  def check_status
  end
  def run
    puts "[-] installing elasticsearch-head"
    system("yum -y update nss")
    system("/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head")

  end
end