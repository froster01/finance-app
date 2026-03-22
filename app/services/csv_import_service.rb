# frozen_string_literal: true

#
# Service object for importing transactions from CSV files
# Handles CSV parsing, validation, and transaction creation
#
class CsvImportService
  RequiredHeaders = %w[date description amount].freeze

  attr_reader :user, :file_path, :errors, :imported_count, :failed_rows

  def initialize(user, file_path)
    @user = user
    @file_path = file_path
    @errors = []
    @imported_count = 0
    @failed_rows = []
  end

  def call
    validate_headers

    return failure if errors.any?

    process_csv_rows

    success
  rescue CSV::MalformedCSVError => e
    errors << "Invalid CSV format: #{e.message}"
    failure
  end

  private

  def validate_headers
    return unless File.exist?(file_path)

    headers = CSV.open(file_path, &:readline)

    missing = RequiredHeaders - headers
    errors << "Missing required columns: #{missing.join(', ')}" if missing.any?
  end

  def process_csv_rows
    CSV.foreach(file_path, headers: true).with_index(2) do |row, line_number|
      process_row(row, line_number)
    end
  end

  def process_row(row, line_number)
    transaction = build_transaction(row)

    if transaction.save
      @imported_count += 1
    else
      @failed_rows << { line: line_number, errors: transaction.errors.full_messages }
    end
  end

  def build_transaction(row)
    Transaction.new(
      date: parse_date(row['date']),
      description: row['description']&.strip,
      amount: parse_amount(row['amount']),
      category: row['category']&.strip || 'Uncategorized',
      transaction_type: determine_transaction_type(row),
      user: user
    )
  end

  def parse_date(date_string)
    Date.parse(date_string)
  rescue ArgumentError, TypeError
    nil
  end

  def parse_amount(amount_string)
    return nil if amount_string.nil?

    # Remove currency symbols and commas, convert to float
    cleaned = amount_string.to_s.gsub(/[$,]/, '').strip
    cleaned.to_f
  end

  def determine_transaction_type(row)
    # Check if transaction_type is provided in CSV
    provided_type = row['transaction_type']&.strip&.downcase
    return :income if provided_type == 'income'
    return :expense if provided_type == 'expense'

    # Default: if amount is negative, it's an expense, otherwise income
    amount = parse_amount(row['amount'])
    amount&.negative? ? :income : :expense
  end

  def success
    Result.new(success: true, imported_count: imported_count, failed_rows: failed_rows)
  end

  def failure
    Result.new(success: false, errors: errors, imported_count: imported_count, failed_rows: failed_rows)
  end

  # Immutable result object
  Result = Struct.new(:success, :imported_count, :failed_rows, :errors, keyword_init: true) do
    def success? = success
  end
end
