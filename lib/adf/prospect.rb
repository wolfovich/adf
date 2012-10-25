class ADF::Prospect
  include ADF::InitializedModel
  attr_accessor :id, :requestdate, :vehicle, :trade_in, :customer, :vendor, :type

  def to_adf
    xml = Builder::XmlMarkup.new :indent => 4
    xml.instruct! :ADF, :VERSION => '1.0'  #xml.instruct! :XML, :VERSION => '1.0'

    xml.adf do |adf|
      adf.prospect do |prospect|
        prospect.requestdate "#{ requestdate.iso_8601 }"
        vehicle.to_adf  prospect
        trade_in.to_adf prospect
        customer.to_adf prospect
        vendor.to_adf   prospect
      end
    end
  end

  def self.from_adf adf
    doc = ( Nokogiri::XML(adf) / :adf / :prospect )
    ADF::Prospect.new :requestdate  => DateTime.parse((doc / :requestdate ).inner_html.strip),
                      :vehicle      => ADF::Vehicle.from_adf(doc.search("vehicle[@status='new']").first),
                      :trade_in     => ADF::Vehicle.from_adf(doc.search("vehicle[@interest='Trade-In']").first),
                      :customer     => ADF::Customer.from_adf(doc / :customer),
                      :vendor       => ADF::Vendor.from_adf(doc / :vendor),
                      :type         => (doc / :type).inner_html.strip
  end
end
