class ADF::Address
  include ADF::InitializedModel
  attr_accessor :street1, :street2, :city, :regioncode, :postalcode, :country

  def self.from_adf doc
    ADF::Address.new  :street1    => doc.search("street[@line='1']").inner_html,
                      :street2    => doc.search("street[@line='2']").inner_html,
                      :city       => (doc / :city).inner_html,
                      :regioncode => (doc / :regioncode).inner_html,
                      :postalcode => (doc / :postalcode).inner_html,
                      :country    => (doc / :country).inner_html

  end
end
