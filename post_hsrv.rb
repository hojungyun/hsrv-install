#!/usr/bin/env ruby
# require 'tempfile'
require 'rubygems'

begin
  require 'active_support/inflector'
rescue LoadError
  puts "[+] Activesupport is not installed. Installing now..."
  system("gem install activesupport --no-ri --no-rdoc")
  puts "[+] Activesupport has been installed. Run the script again"
  exit 0
end

DIALOG = "/usr/bin/dialog"
APP_TITLE = "HSRV POST INSTALLATION"
TEMP_FILENAME = "temp.output"

# If dialog does not exist, install dialog
if not File.exist?(DIALOG)
  puts "[+] The dialog tool is not installed. Installing now..."
  # resouces = <<-EOF
  #   # Regular repositories
  #   deb http://http.kali.org/kali kali main non-free contrib
  #   deb http://security.kali.org/kali-security kali/updates main contrib non-free
  #
  #   # Source repositories
  #   deb-src http://http.kali.org/kali kali main non-free contrib
  #   deb-src http://security.kali.org/kali-security kali/updates main contrib non-free
  # EOF
  # puts "[-] adding the following resources to /etc/apt/source.list"
  # File.open("/etc/apt/sources.list", 'w') do |file|
  #   file.puts resouces
  # end
  # system("echo 'deb http://ftp.de.debian.org/debian sid main' >> /etc/apt/sources.list")
  # system("apt-get update")
  system("yum install -y dialog")
  puts "[+] Dialog tool has been installed."
end

class Dialog
  attr_reader :rows, :cols

  def initialize
    system("#{DIALOG} --print-maxsize >/dev/null 2> #{TEMP_FILENAME}")
    File.open(TEMP_FILENAME, "r") do |file|
      match_obj = file.readline.match(/MaxSize: (\d+), (\d+)/)
      @rows = match_obj[1]
      @cols = match_obj[2]
    end
  end

  def mbox_cols
    mbox_cols = @rows.to_i / 2
    if mbox_cols < 30
      @cols.to_i
    else
      mbox_cols
    end
  end

  def mbox_rows
    mbox_rows = @rows.to_i / 2
    if mbox_rows < 10
      @rows.to_i
    else
      mbox_rows
    end
  end

  def cbox_cols
    @cols.to_i + 15
  end

  def cbox_rows
    @rows.to_i
  end

end
dialog = Dialog.new

title = "About this tool"
message = <<EOF
This tool is for HSRV Linux post process to install various tools and update the existing tools. Additionally, the tool is extendable by adding plug-in classes under 'classes' directory.
EOF
system("#{DIALOG} --backtitle '#{APP_TITLE}' --title '#{title}' --msgbox '#{message}' #{dialog.mbox_rows} #{dialog.mbox_cols} 2>#{TEMP_FILENAME}")

# require super class
require_relative("lib/item")

# require all sub classes
sub_classes = []
class_files_sorted = Dir["classes/*.rb"].sort_by { |x| File.basename x }
class_files_sorted.each do |file|
  require_relative file
  class_name = file.sub(/classes\/\d{3}_(.*)\.rb/, '\1').camelize #<--- AptUpdate
  obj = Object.const_get(class_name).new #<--- create object with class name string
  sub_classes << obj #<-- add objects to array
end

# create string to be used for checklist parameter in dialog
checklist_str = ''
sub_classes.each do |obj|
  checklist_str << "#{obj.tag} '#{obj.item}' #{obj.status} "
end

# check list dialog. tags of checked items are added to temp.output
message = "Select the processes that you want to perform"
system("#{DIALOG} --checklist '#{message}' #{dialog.cbox_rows} #{dialog.cbox_cols} #{sub_classes.count} #{checklist_str} 2>#{TEMP_FILENAME}")

# get tag list from temp file
File.open(TEMP_FILENAME, 'r') do |file|
  begin
    file.readline.split(' ').each do |selected_tag|
      sub_classes.each do |obj|
        if obj.tag == selected_tag.gsub(/"/, '') #<-- remove double quotes from string
          obj.to_s #<---- display '### tag ###'
          obj.run #<---- perform the installation or whatever
          puts
        end
      end
    end
  rescue EOFError
    # Finished processing the file
  end
end

__END__

HOW TO CREATE SUB CLASS
1. Filename is 000_xxx_xxx.rb format (ex. 200_new_process.rb)
2. Class name is camel case (CamelCase)
3. args for initialize method are item and status which are used for checklist parameters

