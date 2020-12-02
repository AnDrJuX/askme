class AddIndexToUsername < ActiveRecord::Migration[6.0]
  change_table :users do |t|
    t.index :username, unique: true
  end
end
