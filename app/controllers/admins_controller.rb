class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @admin = Admin.find(current_admin.id)
    @work_patterns = WorkPattern.where(company_id: @admin.company.id)
    @admin_work_patterns = AdminWorkPattern.where(admin_id: @admin.id)
    @new_pattern = AdminWorkPatternCollection.new(@work_patterns)
  end
end
