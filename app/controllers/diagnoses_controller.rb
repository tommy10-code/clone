class DiagnosesController < ApplicationController
  def new
  end

  def result
    if current_user.nil?
      # 未ログインならログインページへ
      redirect_to new_user_session_path, alert: "ログインが必要です"
    else
      # ログイン済みなら診断結果に応じて遷移
      case params[:answer].to_i
      when 0
        redirect_to "result_path_0_path"
      when 1
        redirect_to "result_path_1_path"
      else
        redirect_to "default_result_path"
      end
    end
  end
end
