class ADF::Vendor
  include ADF::InitializedModel
  attr_accessor :contacts, :ids, :vendorname, :url
  STRING_ATTRIBUTES = [:vendorname, :url]
  ARRAY_ATTRIBUTES = [:ids]

  def to_adf xml
    xml.vendor {
      ARRAY_ATTRIBUTES.each do |attr|
        send(attr).each do |key|
          xml.send(key[:name], key[:value], key[:attributes])
        end
      end
      STRING_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        xml.send(attr, self.send(attr))
      end
      contacts.each do |contact|
        contact.to_adf(xml)
      end
    }
  end

  def self.from_adf doc
    params = {}

    STRING_ATTRIBUTES.each do |attr|
      next if doc.xpath(attr.to_s).empty?
      params[attr] = doc.xpath(attr.to_s).inner_html.to_s.strip
    end

    params[:contacts] = []
    doc.xpath('contact').each do |node|
      params[:contacts] << ADF::Contact.from_adf(node)
    end

    params[:ids] = []
    doc.xpath('id').each do |node|
      value = node.inner_html.to_s.strip
      next if value.empty?
      attributes = {}
      node.attributes.each do |name, value|
        attributes[name] = value.value
      end

      params[:ids] << {attributes: attributes, value: value, name: node.name}
    end

    ADF::Vendor.new params
  end
end
