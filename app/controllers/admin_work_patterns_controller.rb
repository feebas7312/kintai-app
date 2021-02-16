class AdminWorkPatternsController < ApplicationController
  def create
    @admin = Admin.find(current_admin.id)
    @work_patterns = WorkPattern.where(company_id: @admin.company.id)
    @admin_work_patterns = AdminWorkPattern.where(admin_id: @admin.id)
    @new_pattern = AdminWorkPatternCollection.new(@work_patterns, admin_work_patterns_collection_params)
    if @new_pattern.save
      flash[:alert] = '登録しました'
      redirect_to admins_show_path
    else
      render admins_show_path
    end
  end

  private

  def admin_work_patterns_collection_params
    params.require(:admin_work_patterns)
  end
end
