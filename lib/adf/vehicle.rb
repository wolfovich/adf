class ADF::Vehicle
  include ADF::InitializedModel
  attr_accessor :attributes, :ids, :year, :make, :model, :trim, :vin, :stock, :doors, :bodystyle, :condition,
                :transmission, :pricecomments, :comments, :odometer, :imagetag, :price, :colorcombinations,
                :options, :finances, :odometer, :imagetag
  STRING_ATTRIBUTES = [:year, :make, :model, :trim, :vin, :stock, :doors, :bodystyle, :condition, :transmission, :pricecomments, :comments]
  HASH_ATTRIBUTES = [:odometer, :imagetag, :price]
  ARRAY_ATTRIBUTES = [:ids]
  ATTRIBUTES = ['interest', 'status']

  def to_adf xml
    xml.vehicle(@attributes) {
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
      colorcombinations.each do |colorcombination|
        colorcombination.to_adf(xml)
      end
      options.each do |option|
        option.to_adf(xml)
      end
      finances.each do |finance|
        finance.to_adf(xml)
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

    params[:colorcombinations] = []
    doc.xpath('colorcombination').each do |node|
      params[:colorcombinations] << ADF::Colorcombination.from_adf(node)
    end
    params[:options] = []
    doc.xpath('option').each do |node|
      params[:options] << ADF::Option.from_adf(node)
    end
    params[:finances] = []
    doc.xpath('finance').each do |node|
      params[:finances] << ADF::Finance.from_adf(node)
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

    ADF::Vehicle.new params
  end

end
