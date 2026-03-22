class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order(date: :desc)
  end

  def import
    if params[:file].present?
      file_path = save_file_temporarily(params[:file])
      ImportTransactionsJob.perform_later(current_user.id, file_path)

      redirect_to transactions_path, notice: "Import started. You will be notified when it's complete."
    else
      redirect_to transactions_path, alert: "Please select a CSV file."
    end
  end

  private

  def save_file_temporarily(uploaded_file)
    directory = Rails.root.join("tmp", "imports")
    FileUtils.mkdir_p(directory)

    timestamp = Time.current.to_i
    filename = "#{timestamp}_#{uploaded_file.original_filename}"
    File.join(directory, filename).tap do |path|
      File.open(path, "wb") do |file|
        file.write(uploaded_file.read)
      end
    end
  end
end