class YumUpdate < Item
  def initialize
    super("Update packages (yum update)", "off")
  end
  def check_status
  end
  def run
    puts "[-] updating all packages"
    system("yum -y update")
  end
end