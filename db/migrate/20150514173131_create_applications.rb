class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications, id: :uuid do |t|
      t.string :name
      t.string :api_key, unique: true, index: true
      t.string :api_secret

      t.timestamps null: false
    end
  end
end
