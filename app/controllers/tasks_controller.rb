class TasksController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]


  def index
    @tasks = current_user.tasks.order(created_at: :desc)
    @tasks = Task.all.sort_by_deadline if params[:sort_deadline_on]
    @tasks = Task.all.sort_by_priority if params[:sort_priority]

    if params[:search].present?
      @tasks = @tasks.search_by_title(params[:search][:title])
      @tasks = @tasks.search_by_status(params[:search][:status])
      if params[:search][:label_id].present?
        @tasks = @tasks.joins(:labels).where(labels: { id: params[:search][:label_id] })
      end
    end

    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:notice] = t('flash.tasks.create_success')
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = t('flash.tasks.create_update')
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.destroy(params[:id])
    flash[:notice] = t('flash.tasks.create_destroy')
    redirect_to root_path
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
    end

    def correct_user
      unless current_user?(@task.user)
        redirect_to tasks_path, alert: 'アクセス権限がありません'
      end
    end
end
