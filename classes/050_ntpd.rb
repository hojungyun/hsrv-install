class Ntpd < Item
  def initialize
    super("Install ntpd", "off")
  end
  def check_status
  end
  def run
    puts "[-] installing ntpd"
    system("yum -y install ntp")
    system("service ntpd start")
    system("chkconfig ntpd on")
  end
end