class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.integer :user_id
      t.string :place
      t.float :latitude
      t.float :longitude
      t.text :address
      t.string :spot_image_id
      t.string :body
      t.string :prefecture
      t.boolean :wheather
      t.timestamps
    end
  end
end
