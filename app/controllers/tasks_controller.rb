class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
    #@tasks = Task.all.order(created_at: :desc)にすると終了期限、優先度ソートが効かない
    @tasks = Task.all.sort_by_deadline if params[:sort_deadline_on]
    @tasks = Task.all.sort_by_priority if params[:sort_priority]

    if params[:search].present?
      @tasks = @tasks.search_by_title(params[:search][:title])
      @tasks = @tasks.search_by_status(params[:search][:status])
    end

    @tasks = @tasks.page(params[:page]).per(10)
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
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end
end
