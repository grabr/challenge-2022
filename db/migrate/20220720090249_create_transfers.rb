class CreateTransfers < ActiveRecord::Migration[6.1]
  def change
    create_table :transfers, id: :uuid do |t|
      t.references :receiver, foreign_key: { to_table: :users }, null: false, index: true, type: :uuid
      t.references :sender, foreign_key: { to_table: :users }, null: false, index: true, type: :uuid

      t.integer :amount_cents, null: false
      t.float :rate, default: 1.0, null: false

      t.string :external_id, null: false, index: true
      t.string :status, default: 'pending', null: false

      t.timestamps
    end
  end
end
