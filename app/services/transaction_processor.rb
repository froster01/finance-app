# frozen_string_literal: true

#
# Service object for processing transactions
# Handles transaction validation, enrichment, and AI categorization triggering
#
class TransactionProcessor
  attr_reader :transaction, :errors

  def initialize(transaction)
    @transaction = transaction
    @errors = []
  end

  def call
    return failure unless transaction.valid?

    enrich_transaction
    trigger_ai_categorization

    success
  end

  private

  def enrich_transaction
    # Add any automatic enrichment logic here
    # For example: normalize descriptions, detect merchants, etc.
    transaction.description = normalize_description(transaction.description)
  end

  def normalize_description(description)
    return nil if description.nil?

    # Remove extra whitespace and convert to title case
    description.strip.split.map(&:capitalize).join(' ')
  end

  def trigger_ai_categorization
    # This will be implemented in Step 7 when we add AI categorization
    # For now, we'll just set a default category
    transaction.category ||= 'Uncategorized'
  end

  def success
    Result.new(success: true, transaction: transaction)
  end

  def failure
    errors.concat(transaction.errors.full_messages)
    Result.new(success: false, errors: errors)
  end

  # Immutable result object
  Result = Struct.new(:success, :transaction, :errors, keyword_init: true) do
    def success? = success
  end
end
