class DiagnosesController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def result
    case params[:answer].to_s
    when "0"
      render "result_type_a"
    when "1"
      render "result_type_b"
    when "2"
      render "result_type_c"
    else
      redirect_to diagnoses_new_path, alert: "診断を選択してください"
    end
  end
end
