class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, index: true
      t.references :votable, polymorphic: true, index: true
      t.integer :weight

      t.timestamps null: false
    end
  end
end
