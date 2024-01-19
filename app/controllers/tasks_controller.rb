class TasksController < ApplicationController
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = t('flash.tasks.create_success')
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = t('flash.tasks.create_update')
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.destroy(params[:id])
    flash[:notice] = t('flash.tasks.create_destroy')
    redirect_to root_path
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content)
    end
end
