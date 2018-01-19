class ADF::Timeframe
  include ADF::InitializedModel
  attr_accessor :description, :earliestdate, :latestdate
  STRING_ATTRIBUTES = [:description, :earliestdate, :latestdate]
  ATTRIBUTES = ['type']

  def to_adf xml
    xml.timeframe(@attributes) {
      STRING_ATTRIBUTES.each do |attr|
        next if self.send(attr).nil?
        xml.send(attr, self.send(attr))
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

    ADF::Timeframe.new  params
  end
end
