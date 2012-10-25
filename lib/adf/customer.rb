class ADF::Customer
  include ADF::InitializedModel
  attr_accessor :contact, :comments

  def to_adf prospect
    prospect.customer do |customer|
      contact.to_adf customer
    end
  end

  def self.from_adf doc
    ADF::Customer.new :contact => ADF::Contact.from_adf( doc / :contact ),
                      :comments => (doc / :comments).inner_html.strip
  end
end
