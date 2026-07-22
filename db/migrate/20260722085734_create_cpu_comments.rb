class CreateCpuComments < ActiveRecord::Migration[7.0]
  def change
    create_table :cpu_comments do |t|
      t.string :comment_body
      t.string :category
      t.integer :fixed_turn

      t.timestamps
    end
  end
end
