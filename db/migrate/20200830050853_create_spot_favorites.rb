class CreateSpotFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :spot_favorites do |t|
      t.integer :spot_id
      t.integer :user_id
      t.timestamps
    end
  end
end
