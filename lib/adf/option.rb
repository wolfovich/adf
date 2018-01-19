class ADF::Option
  include ADF::InitializedModel
  attr_accessor :optionname, :manufacturercode, :stock, :weighting, :price
  STRING_ATTRIBUTES = [:optionname, :manufacturercode, :stock, :weighting]
  HASH_ATTRIBUTES = [:price]

  def to_adf xml
    xml.option {
      STRING_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        xml.send(attr, self.send(attr))
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

    ADF::Option.new  params
  end
end
