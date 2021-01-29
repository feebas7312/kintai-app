class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string     :name         , null: false
      t.time       :opening_time , null: false
      t.time       :closing_time , null: false
      t.references :admin        , foreign_key: true
      t.timestamps
    end
  end
end
