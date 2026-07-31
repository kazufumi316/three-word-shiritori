class AddStatusToWords < ActiveRecord::Migration[7.0]
  def up
    add_column :words, :status, :integer, default: 0, null: false
    execute "UPDATE words SET status = 1"
  end

  def down
    remove_column :words, :status
  end
end
