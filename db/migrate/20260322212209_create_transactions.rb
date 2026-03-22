class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.date :date
      t.string :category
      t.integer :transaction_type, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :transactions, :category
    add_index :transactions, :date
  end
end
