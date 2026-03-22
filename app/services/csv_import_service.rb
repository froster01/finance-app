require 'csv'

class CsvImportService
  def initialize(file, user)
    @file = file
    @user = user
  end

  def call
    imported_count = 0
    errors = []

    CSV.foreach(@file.path, headers: true) do |row|
      transaction = Transaction.new(
        date: row['date'],
        description: row['description'],
        amount: row['amount'],
        user: @user,
        # Default to expense, AI will update this later
        transaction_type: :expense,
        category: 'Uncategorized'
      )

      if transaction.save
        imported_count += 1
      else
        errors << "Row #{$.}: #{transaction.errors.full_messages.join(', ')}"
      end
    end

    { success: true, imported_count: imported_count, errors: errors }
  rescue StandardError => e
    { success: false, error: e.message }
  end
end