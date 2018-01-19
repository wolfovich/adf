class ADF::Contact
  include ADF::InitializedModel
  attr_accessor :attributes, :name, :email, :phone, :addresses
  HASH_ATTRIBUTES = [:name, :email, :phone]
  ATTRIBUTES = ['primarycontact']

  # def full_name
  #   @full_name.present? ? @full_name : "#{first_name} #{last_name}"
  # end
  #
  # def first_name
  #   @first_name.present? ? @first_name : @full_name.split(" ").first
  # end
  #
  # def last_name
  #   @last_name.present? ? @last_name : @full_name.split(" ").last
  # end

  def to_adf xml
    xml.contact(@attributes) {
      HASH_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        self.send(attr).each do |value|
          xml.send(value[:name], value[:value], value[:attributes])
        end
      end
      addresses.each do |address|
        address.to_adf(xml)
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
    params[:addresses] = []
    doc.xpath('address').each do |node|
      params[:addresses] << ADF::Address.from_adf(node)
    end
    ADF::Contact.new  params

  end
end
