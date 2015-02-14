class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :key
      t.integer :times_used, default: 0
      t.belongs_to :user
      t.integer :requests, default: 0
      t.time

      t.timestamps
    end
  end
end
