class Java8 < Item
  def initialize
    super("Install Java 1.8.0 OpenJDK", "off")
  end
  def check_status
  end
  def run
    puts "[-] installing java-1.8.0-openjdk"
    system("yum -y install java-1.8.0-openjdk")
  end
end