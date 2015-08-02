class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.string :email
      t.string :uid
      t.string :provider
      t.string :token

      t.timestamps null: false
    end


  end
end
