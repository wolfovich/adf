class ADF::Colorcombination
  include ADF::InitializedModel
  attr_accessor :interiorcolor, :exteriorcolor, :preference
  STRING_ATTRIBUTES = [:interiorcolor, :exteriorcolor, :preference]

  def to_adf xml
    xml.colorcombination {
      STRING_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        xml.send(attr, self.send(attr))
      end
    }
  end

  def self.from_adf doc
    params = {}

    STRING_ATTRIBUTES.each do |attr|
      next if doc.xpath(attr.to_s).empty?
      params[attr] = doc.xpath(attr.to_s).inner_html.to_s.strip
    end

    ADF::Colorcombination.new  params
  end
end
