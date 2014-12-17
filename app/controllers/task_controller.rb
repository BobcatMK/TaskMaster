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
        @start = params[:dupa][:poczatek]
        @start_array = @start.split("/")
        puts @start_array
        @end = params[:dupa][:koniec]
        @end_array = @end.split("/")
        puts @end_array

        @task = Task.new(:start => DateTime.new(@start_array[0].to_i,@start_array[1].to_i,@start_array[2].to_i,@start_array[3].to_i,@start_array[4].to_i),:end => DateTime.new(@end_array[0].to_i,@end_array[1].to_i,@end_array[2].to_i,@end_array[3].to_i,@end_array[4].to_i),:description => params[:task][:description],:completed => params[:task][:completed],:todolist_id => params[:task][:todolist_id],:user_id => params[:task][:user_id])
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
