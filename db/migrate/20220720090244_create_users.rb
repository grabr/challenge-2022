class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.integer :balance_cents, default: 0, null: false
      t.string :balance_currency, null: false
      t.string :pending_balance_cents, default: 0, null: false

      t.string :external_id

      t.timestamps
    end
  end
end
