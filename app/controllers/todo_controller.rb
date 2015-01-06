class TodoController < ApplicationController

    include ApplicationHelper

    def todo_add_get
        @todo_list = Todolist.new

        respond_to do |format|
            format.js { render "todo_add_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def todo_add
        @todo_list = Todolist.new(todo_add_params)

        if @todo_list.save
            respond_to do |format|
                format.js { render "todo_add_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "todo_add_fail.js.erb" }
            end
        end
    end

    def todo_edit_get
        @todo_list = Todolist.find(params[:todolist][:id])

        respond_to do |format|
            format.js { render "todo_edit_get.js.erb" }
        end
    end

    def todo_edit
        @todo_list = Todolist.find(params[:todolist][:id])

        if @todo_list.update(:title => params[:todolist][:title])
            respond_to do |format|
                format.js { render "todo_edit_success.js.erb" }
            end
        else 
            respond_to do |format|
                format.js { render "todo_edit_fail.js.erb" }
            end            
        end           
    end

    def todo_add_cancel
        respond_to do |format|
            format.js { render "todo_add_cancel.js.erb" }
        end
    end

    def todo_delete
        @todo_list = Todolist.find(params[:todolist_id])
        @all_tasks = Task.where(:todolist_id => @todo_list.id,:user_id => current_user.id,:completed => false)

        @all_tasks.each do |task|
            task.update(:todolist_id => 0)
        end

        @todo_list.destroy

        respond_to do |format|
            format.js { render "todo_delete.js.erb" }
        end
    end

    def todo_show
        @todo_list = Todolist.find(params[:todolist_id])
        @tasks_for_today = Task.where(:user_id => current_user.id,:todolist_id => @todo_list.id)
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)

        sorting_algorithm_and_initializer

        respond_to do |format|
            format.js { render "todo_show.js.erb" }
        end
    end

    def todo_task_add_get
        @todo_list = Todolist.find(params[:todolist_id])
        @today = Calendar.where(:year => params[:date_year],:month => params[:date_month],:day => params[:date_day])
        @task = Task.new
        @todolists = Todolist.where(:user_id => current_user.id)
        respond_to do |format|
            format.js { render "todo_task_add_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def todo_task_add
        @todolists = Todolist.where(:user_id => current_user.id)

        @begin_date = params[:begin][:date]
        @end_date = params[:end][:date]
        @begin_time = params[:begin][:time]
        @end_time = params[:end][:time]

        @begin_date_split = @begin_date.split("/")
        @end_date_split = @end_date.split("/")
        @begin_time_split = @begin_time.split(":")
        @end_time_split = @end_time.split(":")

        @task = Task.new(
            :start => DateTime.new(@begin_date_split[0].to_i,@begin_date_split[1].to_i,@begin_date_split[2].to_i,@begin_time_split[0].to_i,@begin_time_split[1].to_i),
            :end => DateTime.new(@end_date_split[0].to_i,@end_date_split[1].to_i,@end_date_split[2].to_i,@end_time_split[0].to_i,@end_time_split[1].to_i),
            :description => params[:task][:description],
            :completed => params[:task][:completed],
            :todolist_id => params[:task][:todolist_id],
            :user_id => params[:task][:user_id]
        )

        if @task.save
            @starting_date = [@task.start.year,@task.start.month,@task.start.day]
            @ending_date = [@task.end.year,@task.end.month,@task.end.day]

            @find_starting_calendar = Calendar.where(:year => @starting_date[0],:month => @starting_date[1],:day => @starting_date[2])
            @find_ending_calendar = Calendar.where(:year => @ending_date[0],:month => @ending_date[1],:day => @ending_date[2])

            @difference = (@find_ending_calendar.first.id - @find_starting_calendar.first.id) + 1

            a = 0
            iteration_array = []

            while a < @difference do
                iteration_array.push(@find_starting_calendar.first.id + a)
                a += 1
            end

            iteration_array.each do |calendar_id|
                @task.calendars << Calendar.find(calendar_id)
            end

            #flash[:notice] = "You have added new task for #{@starting_date[0]}/#{@starting_date[1]}/#{@starting_date[2]}"

            @flash_notice = "You have added new task for #{@starting_date[0]}/#{@starting_date[1]}/#{@starting_date[2]}"

            @todo_list = Todolist.find(params[:todolist_id])
            @tasks_for_today = Task.where(:user_id => current_user.id,:todolist_id => @todo_list.id)
            @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)

            sorting_algorithm_and_initializer

            respond_to do |format|
                format.js { render "todo_task_add_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "todo_task_add_fail.js.erb" }
            end
        end
    end

    def todo_task_edit_get
        @task = Task.find(params[:task][:id])
        @todolists = Todolist.where(:user_id => current_user.id)
        @today = Calendar.where(:year => params[:date_year],:month => params[:date_month],:day => params[:date_day])

        @task_start_year = @task.start.year
        @task_start_month = @task.start.month
        @task_start_day = @task.start.day

        @task_end_year = @task.end.year
        @task_end_month = @task.end.month
        @task_end_day = @task.end.day 

        @task_start_time = @task.start.strftime("%-k:%M")
        @task_end_time = @task.end.strftime("%-k:%M")

        respond_to do |response|
            response.js { render "todo_task_edit_get.js.erb" }
            response.html { redirect_to logged_signed_path }
        end
    end

    def todo_task_edit

        @todolists = Todolist.where(:user_id => current_user.id)

        @begin_date = params[:begin][:date]
        @end_date = params[:end][:date]
        @begin_time = params[:begin][:time]
        @end_time = params[:end][:time]

        @begin_date_split = @begin_date.split("/")
        @end_date_split = @end_date.split("/")
        @begin_time_split = @begin_time.split(":")
        @end_time_split = @end_time.split(":")

        @task = Task.find(params[:task][:id])

        if @task.update(
            :start => DateTime.new(@begin_date_split[0].to_i,@begin_date_split[1].to_i,@begin_date_split[2].to_i,@begin_time_split[0].to_i,@begin_time_split[1].to_i),
            :end => DateTime.new(@end_date_split[0].to_i,@end_date_split[1].to_i,@end_date_split[2].to_i,@end_time_split[0].to_i,@end_time_split[1].to_i),
            :description => params[:task][:description],
            :todolist_id => params[:task][:todolist_id],
            :user_id => params[:task][:user_id],
            :completed => false)

            @starting_date = [@task.start.year,@task.start.month,@task.start.day]
            @ending_date = [@task.end.year,@task.end.month,@task.end.day]

            @find_starting_calendar = Calendar.where(:year => @starting_date[0],:month => @starting_date[1],:day => @starting_date[2])
            @find_ending_calendar = Calendar.where(:year => @ending_date[0],:month => @ending_date[1],:day => @ending_date[2])

            @difference = (@find_ending_calendar.first.id - @find_starting_calendar.first.id) + 1

            @task.calendars.clear

            a = 0
            iteration_array = []

            while a < @difference do
                iteration_array.push(@find_starting_calendar.first.id + a)
                a += 1
            end

            iteration_array.each do |calendar_id|
                @task.calendars << Calendar.find(calendar_id)
            end

            @flash_notice = "You have edited task. It starts at #{@starting_date[0]}/#{@starting_date[1]}/#{@starting_date[2]} and ends at #{@ending_date[0]}/#{@ending_date[1]}/#{@ending_date[2]}"

            @todo_list = Todolist.find(params[:todolist_id])
            @tasks_for_today = Task.where(:user_id => current_user.id,:todolist_id => @todo_list.id)
            @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)

            sorting_algorithm_and_initializer

            respond_to do |format|
                format.js { render "todo_task_edit_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "todo_task_edit_fail.js.erb" }
            end
        end

    end

    def todo_task_complete
        @task = Task.find(params[:task][:id])
        @task.calendars.clear
        @task.update(:completed => params[:task][:completed])

        @todo_list = Todolist.find(params[:todolist_id])
        @tasks_for_today = Task.where(:user_id => current_user.id,:todolist_id => @todo_list.id)
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)

        sorting_algorithm_and_initializer

        respond_to do |response|
            response.js { render "todo_task_complete.js.erb",:locals => {:@remove_this => @task.id} }
            response.html { redirect_to logged_signed_path }
        end
    end

    def todo_task_delete
        @task = Task.find(params[:task_id])
        @list_id = @task.todolist_id
        @flash_notice = "You have deleted task. It description was #{@task.description}"
        @task.calendars.clear
        @task.destroy

        @todo_list = Todolist.find(@list_id)
        @tasks_for_today = Task.where(:user_id => current_user.id,:todolist_id => @todo_list.id)
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)

        sorting_algorithm_and_initializer

        respond_to do |format|
            format.js { render "todo_task_delete.js.erb" }
            format.html { redirect_to logged_signed_path }
        end        
    end


    private
        def todo_add_params
            params.require(:todolist).permit(:title,:user_id)
        end

end