class TaskviewController < ApplicationController
    
    include TaskHelper
    include ApplicationHelper
    include TaskviewHelper

    def task_view

        taskview_initializer

        @action ||= params[:action]

        respond_to do |format|
            format.js { render "task_view.js.erb" }
            format.js { render logged_signed_path }
        end
    end

    def task_view_edit_get
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
            response.js { render "task_view_edit_get.js.erb" }
            response.html { redirect_to logged_signed_path }
        end
    end

    def task_view_edit

        @todolists = Todolist.where(:user_id => current_user.id)

        @begin_date = params[:begin][:date]
        @end_date = params[:end][:date]
        @begin_time = params[:begin][:time]
        @end_time = params[:end][:time]

        @go_back_to = params[:controller_action_forward]

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

            if @go_back_to == "task_view"
                taskview_initializer
            elsif @go_back_to == "task_view_unassigned"
                @all_tasks_assigned = Task.where(:user_id => current_user.id,:completed => true)
                taskview_initializer
            elsif @go_back_to == "task_view_all"
                @all_tasks_assigned = Task.where(:user_id => current_user.id)
                taskview_initializer
            end

            respond_to do |format|
                format.js { render "task_view_edit_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "task_view_edit_fail.js.erb" }
            end
        end
    end

    def task_view_create_get
        @today = Calendar.where(:year => params[:date_year],:month => params[:date_month],:day => params[:date_day])
        @task = Task.new
        @todolists = Todolist.where(:user_id => current_user.id)

        @action = params[:controller_action]

        respond_to do |format|
            format.js { render "task_view_create_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def task_view_create
        @todolists = Todolist.where(:user_id => current_user.id)

        @begin_date = params[:begin][:date]
        @end_date = params[:end][:date]
        @begin_time = params[:begin][:time]
        @end_time = params[:end][:time]

        @begin_date_split = @begin_date.split("/")
        @end_date_split = @end_date.split("/")
        @begin_time_split = @begin_time.split(":")
        @end_time_split = @end_time.split(":")

        @go_back_to = params[:controller_action_forward]

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

            @flash_notice = "You have added new task for #{@starting_date[0]}/#{@starting_date[1]}/#{@starting_date[2]}"

            if @go_back_to == "task_view"
                taskview_initializer
            elsif @go_back_to == "task_view_unassigned"
                @all_tasks_assigned = Task.where(:user_id => current_user.id,:completed => true)
                taskview_initializer
            elsif @go_back_to == "task_view_all"
                @all_tasks_assigned = Task.where(:user_id => current_user.id)
                taskview_initializer
            end

            respond_to do |format|
                format.js { render "task_view_create.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "task_view_create_fail.js.erb" }
            end
        end
    end

    def task_view_completed
        @task = Task.find(params[:task][:id])
        @task.calendars.clear
        @task.update(:completed => params[:task][:completed])

        @go_back_to = params[:controller_action]

        if @go_back_to == "task_view"
            taskview_initializer
        elsif @go_back_to == "task_view_unassigned"
            @all_tasks_assigned = Task.where(:user_id => current_user.id,:completed => true)
            taskview_initializer
        elsif @go_back_to == "task_view_all"
            @all_tasks_assigned = Task.where(:user_id => current_user.id)
            taskview_initializer
        end

        respond_to do |response|
            response.js { render "task_view_completed_success.js.erb",:locals => {:@remove_this => @task.id} }
            response.html { redirect_to logged_signed_path }
        end
    end

    def task_view_unassigned
        @all_tasks_assigned = Task.where(:user_id => current_user.id,:completed => true)
        taskview_initializer

        @action ||= params[:action]

        respond_to do |format|
            format.js { render "task_view_unassigned.js.erb" }
            format.js { render logged_signed_path }
        end
    end

    def task_view_all
        @all_tasks_assigned = Task.where(:user_id => current_user.id)
        taskview_initializer

        @action ||= params[:action]

        respond_to do |format|
            format.js { render "task_view_all.js.erb" }
            format.js { render logged_signed_path }
        end
    end
end
