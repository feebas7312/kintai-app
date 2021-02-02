class CreateWorkSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :work_schedules do |t|
      t.date       :work_date       , null: false
      t.time       :work_start_time , null: false
      t.time       :work_end_time   , null: false
      t.references :admin
      t.references :employee
      t.timestamps
    end
  end
end
