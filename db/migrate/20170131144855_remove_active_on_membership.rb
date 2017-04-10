class RemoveActiveOnMembership < ActiveRecord::Migration[5.0]
  def change
    remove_column :memberships, :active
  end
end
