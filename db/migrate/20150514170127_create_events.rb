class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :source_name, index: true
      t.text    :name, index: true
      t.json    :data

      t.timestamps null: false
    end
  end
end
