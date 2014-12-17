class TaskController < ApplicationController
    def add_task_get
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        @task = Task.new
        respond_to do |format|
            format.js { render "add_task_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def create_task
        @task = Task.new(create_task_params)
        if @task.save
            redirect_to logged_signed_path
        else
            redirect_to logged_signed_path
        end
    end

    private

        # def create_task_params
        #     params.require(:task).permit(:start,:end,:description,:user_id,:completed,:todolist_id)
        # end
end
