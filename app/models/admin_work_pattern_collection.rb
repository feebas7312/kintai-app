class AdminWorkPatternCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection

  def initialize(work_patterns, attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        AdminWorkPattern.new(
          admin_id: value['admin_id'],
          work_pattern_id: value['work_pattern_id'],
          possibility: value['possibility']
        )
      end
    else
      pattern_num = work_patterns.length
      self.collection = pattern_num.times.map{ AdminWorkPattern.new }
    end
  end

  def persisted?
    false
  end

  def save
    collection.each do |result|
      @data = AdminWorkPattern.find_by(admin_id: result.admin_id, work_pattern_id: result.work_pattern_id)
      if result.possibility
        unless @data.present?
          result.save
        end
      elsif @data.present?
        @data.destroy
      end
    end
  end
end