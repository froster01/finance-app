class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.date :date
      t.string :category
      t.integer :transaction_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
