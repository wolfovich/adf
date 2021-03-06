class ADF::Prospect
  include ADF::InitializedModel
  attr_accessor :ids, :requestdate, :vehicle, :customer, :vendor, :provider
  ARRAY_ATTRIBUTES = [:ids]

  def to_adf
    builder = Nokogiri::XML::Builder.new do |xml|
      adf_version = Nokogiri::XML::ProcessingInstruction.new(xml.doc, "adf",'version="1.0"')
      xml.doc.add_child(adf_version)
      xml.adf {
        xml.prospect {
          xml.requestdate requestdate.iso8601
          ARRAY_ATTRIBUTES.each do |attr|
            send(attr).each do |key|
              next if key[:value].empty?
              xml.send(key[:name], key[:value], key[:attributes])
            end
          end
          vehicle.to_adf(xml)
          customer.to_adf(xml)
          vendor.to_adf(xml)
          provider.to_adf(xml)
        }
      }
    end
    builder.to_xml
  end

  def self.from_adf adf
    params = {}
    doc = ( Nokogiri::XML(adf) / :adf / :prospect )

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

    params[:requestdate] = DateTime.parse(doc.xpath('requestdate').inner_html.strip)
    params[:vehicle] = ADF::Vehicle.from_adf(doc.xpath('//vehicle').first)
    params[:customer] = ADF::Customer.from_adf(doc.xpath('//customer').first)
    params[:provider] = ADF::Provider.from_adf(doc.xpath('//provider').first)
    params[:vendor] = ADF::Vendor.from_adf(doc.xpath('//vendor').first)

    ADF::Prospect.new params
  end
end
