class CreateWorkSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :work_schedules do |t|
      t.date       :work_date       , null: false
      t.string     :work_start_time
      t.string     :work_end_time
      t.references :admin           , foreign_key: true
      t.references :employee        , foreign_key: true
      t.timestamps
    end
  end
end
