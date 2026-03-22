class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order(date: :desc)
  end

  def import
    if params[:file].present?
      service = CsvImportService.new(params[:file], current_user)
      result = service.call

      if result[:success]
        redirect_to transactions_path, notice: "Successfully imported #{result[:imported_count]} transactions."
      else
        redirect_to transactions_path, alert: "Import failed: #{result[:error]}"
      end
    else
      redirect_to transactions_path, alert: "Please select a CSV file."
    end
  end
end