class CreateWorkPatterns < ActiveRecord::Migration[6.0]
  def change
    create_table :work_patterns do |t|
      t.string     :start_time , null: false
      t.string     :end_time   , null: false
      t.references :company    , foreign_key: true
      t.timestamps
    end
  end
end
