class AdminsHomeController < ApplicationController

  def index
    @admin = Admin.find(current_admin.id)
    @employees = Employee.where(admin_id: @admin.id)
  end

end
