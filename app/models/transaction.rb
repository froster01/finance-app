class Transaction < ApplicationRecord
  belongs_to :user

  enum transaction_type: { expense: 0, income: 1 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :transaction_type, presence: true

  scope :incomes, -> { where(transaction_type: :income) }
  scope :expenses, -> { where(transaction_type: :expense) }
end