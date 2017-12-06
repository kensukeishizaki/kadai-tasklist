class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    if logged_in?
      @user = current_user
      @tasks = current_user.tasks.order('created_at DESC')
    end
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクは正常に登録されました！'
      redirect_to root_url
    else
      #@tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクが正常に登録されませんでした！'
      render :new
    #@task = current_user.tasks.build(task_params)
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました！'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが正常に更新されませんでした！'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = 'タスクが正常に削除されました！'
    redirect_to tasks_url
  end  

  private

  #Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def set_task
    @task = Task.find(params[:id])
    redirect_to root_url if @task.user != current_user
  end
end