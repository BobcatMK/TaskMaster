class WeekController < ApplicationController

    include ApplicationHelper
    include TaskHelper
    include WeekHelper

    def week_view
        # GENERATES VIEW FOR WHOLE WEEK
        day_today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day).first
        #day_today = Calendar.where(:id => 6200).first
        week_view_calendar(day_today)
        # END

        respond_to do |format|
            format.js { render "week_view.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def add_task_week_view
        @today = Calendar.where(:year => params[:date_year],:month => params[:date_month],:day => params[:date_day])
        @task = Task.new
        @todolists = Todolist.where(:user_id => current_user.id)
        respond_to do |format|
            format.js { render "add_task_week_view.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def create_task_week_view

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

            date = Calendar.where(year: params[:date_year],month: params[:date_month],day: params[:date_day]).first
            week_view_calendar(date)

            respond_to do |format|
                format.js { render "task_week_view_save_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "task_week_view_save_fail.js.erb" }
            end
        end
    end

    def particular_day_tasks
        # GENERATES VIEW FOR WHOLE WEEK
        start_day = Calendar.where(:year => params[:year],:month => params[:month],:day => params[:day]).first
        week_view_calendar(start_day)
        # END

        # BELOW RESPONSIBLE FOR GENERATING TASKS FOR PARTICULAR DAY
        @today = Calendar.where(:year => params[:year],:month => params[:month],:day => params[:day])
        sorting_algorithm_and_initializer
        # END

        respond_to do |format|
            format.js { render "particular_day_tasks.js.erb" }
        end
    end

    def task_edit_get_week_view
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
            response.js { render "task_edit_get_week_view.js.erb" }
            response.html { redirect_to logged_signed_path }
        end
    end

    def edit_task_week_view
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
            :user_id => params[:task][:user_id])

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

            date = Calendar.where(year: params[:date_year],month: params[:date_month],day: params[:date_day]).first
            week_view_calendar(date)

            respond_to do |format|
                format.js { render "edit_task_week_view_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "edit_task_week_view_fail.js.erb" }
            end
        end
    end

    def task_completed_week_view
        @task = Task.find(params[:task][:id])
        @task.calendars.clear
        @task.update(:completed => params[:task][:completed])

        date = Calendar.where(year: params[:date][:year],month: params[:date][:month],day: params[:date][:day]).first
        week_view_calendar(date)

        respond_to do |response|
            response.js { render "task_completed_week_view.js.erb" }
            response.html { redirect_to logged_signed_path }
        end
    end

    def task_delete_week_view
        @task = Task.find(params[:task_id])
        @flash_notice = "You have deleted task. It description was #{@task.description}"
        @task.calendars.clear
        @task.destroy

        date = Calendar.where(year: params[:date_year],month: params[:date_month],day: params[:date_day]).first
        week_view_calendar(date)

        respond_to do |format|
            format.js { render "task_delete_week_view.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def week_backward
        if params[:calendar_id].to_i - 1 == 0
            render :nothing => true
        else
            day_today = Calendar.where(:id => params[:calendar_id].to_i - 1).first
            week_view_calendar(day_today)

            respond_to do |format|
                format.js { render "week_backward.js.erb" }
            end
        end
    end

    def week_forward
        if params[:calendar_id].to_i + 1 == 6210
            render :nothing => true
        else
            day_today = Calendar.where(:id => params[:calendar_id].to_i + 1).first
            week_view_calendar(day_today)

            respond_to do |format|
                format.js { render "week_forward.js.erb" }
            end
        end
    end

    # NEXT 7 DAYS VIEW BELOW ALL REQUIRED ACTIONS

    def next_seven_days

        next_seven_days_initializer

        respond_to do |format|
            format.js { render "next_seven_days.js.erb" }
            format.html { render logged_signed_path }
        end
    end

    def next_seven_days_generate_tasks
        # GENERATES VIEW FOR WHOLE WEEK
        start_day = Calendar.where(:year => params[:year],:month => params[:month],:day => params[:day]).first
        week_view_calendar(start_day)
        # END

        # BELOW RESPONSIBLE FOR GENERATING TASKS FOR PARTICULAR DAY
        @today = Calendar.where(:year => params[:year],:month => params[:month],:day => params[:day])
        sorting_algorithm_and_initializer
        # END

        respond_to do |format|
            format.js { render "next_seven_days_generate_tasks.js.erb" }
        end
    end

    def next_seven_days_add_task_get
        @today = Calendar.where(:year => params[:date_year],:month => params[:date_month],:day => params[:date_day])
        @task = Task.new
        @todolists = Todolist.where(:user_id => current_user.id)
        respond_to do |format|
            format.js { render "next_seven_days_add_task_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def next_seven_days_add_task

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

            @flash_notice = "You have added new task for #{@starting_date[0]}/#{@starting_date[1]}/#{@starting_date[2]}"

            next_seven_days_initializer

            respond_to do |format|
                format.js { render "next_seven_days_add_task_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "next_seven_days_add_task_fail.js.erb" }
            end
        end
    end

    def next_seven_days_edit_get
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
            response.js { render "next_seven_days_edit_get.js.erb" }
            response.html { redirect_to logged_signed_path }
        end
    end

    def next_seven_days_edit
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
            :user_id => params[:task][:user_id])

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

            next_seven_days_initializer

            respond_to do |format|
                format.js { render "next_seven_days_edit_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "next_seven_days_edit_fail.js.erb" }
            end
        end
    end

    def next_seven_days_completed
        @task = Task.find(params[:task][:id])
        @task.calendars.clear
        @task.update(:completed => params[:task][:completed])

        next_seven_days_initializer

        respond_to do |response|
            response.js { render "next_seven_days_completed.js.erb" }
            response.html { redirect_to logged_signed_path }
        end
    end

    def task_delete_next_seven_days
        @task = Task.find(params[:task_id])
        @flash_notice = "You have deleted task. It description was #{@task.description}"
        @task.calendars.clear
        @task.destroy

        next_seven_days_initializer

        respond_to do |format|
            format.js { render "task_delete_next_seven_days.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

end
