class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :place
      t.date :at_date
      t.timestamps
    end
  end
end
