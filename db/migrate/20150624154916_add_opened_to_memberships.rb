class AddOpenedToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :open, :boolean, default: false
  end
end
