class Admin::CpuCommentsController < Admin::ApplicationController
  before_action :set_cpu_comment, only: [:edit, :update, :destroy]

  def index
    @cpu_comments = CpuComment.all
  end

  def new
    @cpu_comment = CpuComment.new
  end

  def create
    @cpu_comment = CpuComment.new(cpu_comment_params)
    if @cpu_comment.save
      redirect_to admin_cpu_comments_path, notice: "セリフを登録しました"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @cpu_comment.update(cpu_comment_params)
      redirect_to admin_cpu_comments_path, notice: "セリフを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @cpu_comment.destroy
    redirect_to admin_cpu_comments_path, notice: "セリフを削除しました"
  end

  private

  def set_cpu_comment
    @cpu_comment = CpuComment.find(params[:id])
  end

  def cpu_comment_params
    params.require(:cpu_comment).permit(:comment_body, :category, :fixed_turn)
  end
end
