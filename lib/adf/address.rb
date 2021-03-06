class ADF::Address
  include ADF::InitializedModel
  attr_accessor :attributes, :streets, :city, :regioncode, :postalcode, :country, :apartment
  STRING_ATTRIBUTES = [:apartment, :city, :regioncode, :postalcode, :country]
  ATTRIBUTES = ['type']

  def to_adf xml
    xml.address(@attributes) {
      STRING_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        xml.send(attr, self.send(attr))
      end
      @streets.each do |street|
        xml.street street
      end
    }
  end

  def self.from_adf doc
    params = {}
    params[:attributes] = {}
    doc.attributes.each do |name, value|
      next unless ATTRIBUTES.include?(name)
      params[:attributes][name] = value.value
    end

    STRING_ATTRIBUTES.each do |attr|
      next if doc.xpath(attr.to_s).empty?
      params[attr] = doc.xpath(attr.to_s).inner_html.to_s.strip
    end

    params[:streets] = []
    doc.xpath('street')[0..4].each do |node|
      params[:streets] << node.inner_html.to_s.strip
    end

    ADF::Address.new  params
  end
end
