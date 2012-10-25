class ADF::Contact
  include ADF::InitializedModel
  attr_accessor :full_name, :first_name, :last_name, :cell_phone, :day_phone, :evening_phone, :email, :address

  def full_name
    @full_name.present? ? @full_name : "#{first_name} #{last_name}"
  end

  def first_name
    @first_name.present? ? @first_name : @full_name.split(" ").first
  end

  def last_name
    @last_name.present? ? @last_name : @full_name.split(" ").last
  end

  def to_adf node
    node.contact do |contact|
      contact.name  name.to_s, :part => 'full'
      contact.phone phone.to_s unless phone.to_s.empty?
    end
  end

  def self.from_adf doc
    ADF::Contact.new  :full_name  => doc.search("name[@part='full']").inner_html.strip,
                      :first_name => doc.search("name[@part='first']").inner_html.strip,
                      :last_name  => doc.search("name[@part='last']").inner_html.strip,
                      :cell_phone    => doc.search("phone[@type='cellphone']").inner_html,
                      :day_phone     => doc.search("phone[@time='day']").inner_html,
                      :evening_phone => doc.search("phone[@time='evening']").inner_html,
                      :email      => (doc / :email).inner_html,
                      :address    => ADF::Address.from_adf(doc / :address)

  end
end
