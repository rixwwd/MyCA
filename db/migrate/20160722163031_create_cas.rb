class CreateCas < ActiveRecord::Migration[5.0]
  def change
    create_table :cas do |t|
      t.string :country, null:false
      t.string :organization, null:false
      t.string :organization_unit, null:false
      t.string :common_name, null:false
      t.string :state, null:false
      t.string :locality, null:false
      t.integer :serial, null:false
      t.datetime :not_before, null:false
      t.datetime :not_after, null:false
      t.string :signature_algorithm, null:false
      t.text :private_key, null:false
      t.text :public_key, null:false
      t.text :certificate, null:false

      t.timestamps
    end
  end
end
