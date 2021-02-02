class SearchWorkSchedulesService
  def self.search(year, month)
    WorkSchedule.where('work_date LIKE(?)', "#{year}-%#{month}-%")
  end
end