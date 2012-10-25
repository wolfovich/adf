class ADF::Vehicle
  include ADF::InitializedModel
  attr_accessor :year, :make, :model, :trim

  def to_adf prospect
    prospect.vehicle do |vehicle|
      vehicle.year  self.year.to_s
      vehicle.make  self.make.to_s
      vehicle.model self.model.to_s
    end
  end

  def self.from_adf doc
    ADF::Vehicle.new  :year =>  ( doc / :year  ).inner_html.to_i,
                      :make =>  ( doc / :make  ).inner_html.strip,
                      :model => ( doc / :model ).inner_html.strip,
                      :trim => (doc / :trim).inner_html.strip
  end
end
