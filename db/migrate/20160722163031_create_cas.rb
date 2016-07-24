class CreateCas < ActiveRecord::Migration[5.0]
  def change
    create_table :cas do |t|
      t.string :country, null:false
      t.string :organization
      t.string :organization_unit
      t.string :common_name, null:false
      t.string :state
      t.string :locality
      t.integer :serial, null:false
      t.datetime :not_before, null:false
      t.datetime :not_after, null:false
      t.text :private_key, null:false
      t.text :certificate, null:false

      t.timestamps
    end
  end
end
