class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :sex
      t.string :description
      t.integer :age

      t.timestamps
    end
  end
end
