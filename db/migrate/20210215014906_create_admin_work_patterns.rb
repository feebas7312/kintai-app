class CreateAdminWorkPatterns < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_work_patterns do |t|
      t.references :admin        , foreign_key: true
      t.references :work_pattern , foreign_key: true
      t.boolean    :possibility  , null: false, default: false
      t.timestamps
    end
  end
end
