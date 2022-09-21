class CreatePets < ActiveRecord::Migration[6.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :breed
      t.string :sex
      t.string :size
      t.datetime :birthday
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
