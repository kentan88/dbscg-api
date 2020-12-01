class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.references :user, null: false, foreign_key: true
      t.jsonb :data, default: '{}'
    end
  end
end
