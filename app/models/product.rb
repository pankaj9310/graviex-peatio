class Product < ActiveRecord::Base
  validates_presence_of :name
  has_many :dividends, :conditions => "aasm_state = 'accepted'"

  def as_json(options = {})
    super(options).merge({
      "ruby" => "true"
    })
  end

end
