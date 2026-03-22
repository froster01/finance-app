# frozen_string_literal: true

class ImportTransactionsJob < ApplicationJob
  queue_as :default

  def perform(user_id, file_path)
    user = User.find(user_id)

    # Use CsvImportService for proper CSV parsing and validation
    result = CsvImportService.new(user, file_path).call

    # Log results
    if result.success?
      Rails.logger.info("Imported #{result.imported_count} transactions for user #{user_id}")
      Rails.logger.warn("Failed to import #{result.failed_rows.size} rows") if result.failed_rows.any?
    else
      Rails.logger.error("CSV import failed: #{result.errors.join(', ')}")
    end

  ensure
    # Clean up temporary file
    File.delete(file_path) if File.exist?(file_path)
  end
end