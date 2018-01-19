class ADF::Finance
  include ADF::InitializedModel
  attr_accessor :method, :earliestdate, :latestdate, :amount, :balance
  STRING_ATTRIBUTES = [:method, :earliestdate, :latestdate]
  HASH_ATTRIBUTES = [:amount, :balance]

  def to_adf xml
    xml.finance {
      STRING_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        xml.send(attr.to_s+'_', self.send(attr))
      end
      HASH_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        self.send(attr).each do |value|
          xml.send(value[:name], value[:value], value[:attributes])
        end
      end
    }
  end

  def self.from_adf doc
    params = {}

    STRING_ATTRIBUTES.each do |attr|
      next if doc.xpath(attr.to_s).empty?
      params[attr] = doc.xpath(attr.to_s).inner_html.to_s.strip
    end

    HASH_ATTRIBUTES.each do |attr|
      nodes = doc.xpath(attr.to_s)
      next if nodes.empty?
      params[attr] = []
      nodes.each do |node|
        attributes = {}
        node.attributes.each do |name, value|
          attributes[name] = value.value
        end
        value = node.inner_html.to_s.strip
        params[attr] << {attributes: attributes, value: value, name: node.name}
      end
    end

    ADF::Finance.new  params
  end
end
