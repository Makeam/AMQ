class CreateSubscribes < ActiveRecord::Migration
  def change
    create_table :subscribes do |t|
      t.references :user, index: true
      t.references :question, index: true

      t.timestamps null: false
    end
  end
end
