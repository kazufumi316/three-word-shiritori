class RemoveFixedTurnFromCpuComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :cpu_comments, :fixed_turn, :integer
  end
end
