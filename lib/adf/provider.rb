class ADF::Provider
  include ADF::InitializedModel
  attr_accessor :attributes, :name, :email, :phone, :ids, :contacts, :service, :url
  HASH_ATTRIBUTES = [:name, :email, :phone]
  STRING_ATTRIBUTES = [:service, :url]
  ARRAY_ATTRIBUTES = [:ids]

  def to_adf xml
    xml.provider(@attributes) {
      ARRAY_ATTRIBUTES.each do |attr|
        send(attr).each do |key|
          xml.send(key[:name], key[:value], key[:attributes])
        end
      end
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
    params[:contacts] = []
    doc.xpath('contact').each do |node|
      params[:contacts] << ADF::Contact.from_adf(node)
    end

    params[:ids] = []
    doc.xpath('id').each do |node|
      attributes = {}
      node.attributes.each do |name, value|
        attributes[name] = value.value
      end
      value = node.inner_html.to_s.strip
      params[:ids] << {attributes: attributes, value: value, name: node.name}
    end

    ADF::Provider.new  params
  end
end
