class Item
  attr_accessor :tag, :item, :status, :error_msg
  def initialize(item, status)
    @tag        = self.class.name
    @item       = item
    @status     = status
    @error_msg  = ''
  end
  def to_s
    puts "[+] #{@tag}"
  end
end