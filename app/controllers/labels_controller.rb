class LabelsController < ApplicationController
  def index
    @labels = current_user.labels
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      redirect_to labels_path, notice: 'ラベルを登録しました'
    else
      render :new
    end
  end

  def edit
    @label = Label.find(params[:id])
  end

  def update
    @label = Label.find(params[:id])
    if @label.update(label_params)
      redirect_to labels_path, notice: 'ラベルを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])
    
    # 関連する TaskLabel レコードを削除
    TaskLabel.where(label_id: @label.id).delete_all

    # ラベルを削除
    @label.destroy
    redirect_to labels_path, notice: 'ラベルを削除しました'
  end
  
  private

  def label_params
    params.require(:label).permit(:name)
  end
end
