class MonthController < ApplicationController

    include TaskHelper

    def month_view
        @this_year = Date.today.year
        @this_month = Date.today.month
        @particular_month = Calendar.where(:year => @this_year,:month => @this_month)
        @today = @particular_month
        algorithm_for_date
        @particular_month_datetime = DateTime.new(@particular_month.first.year,@particular_month.first.month)

        respond_to do |format|
            format.js { render "month_view.js.erb" }
            format.html
        end
    end

    def month_task_get
        @today = Calendar.where(:year => params[:date_year],:month => params[:date_month],:day => params[:date_day])
        @task = Task.new
        @todolists = Todolist.where(:user_id => current_user.id)
        respond_to do |format|
            format.js { render "month_task_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def create_task_month_view

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

            # INITIALIZERS BELOW
            @this_year = params[:date_year]
            @this_month = params[:date_month]
            
            @particular_month = Calendar.where(:year => @this_year,:month => @this_month)

            # @particular_month.each do |record|
            #     puts record.inspect
            # end
            @today = @particular_month
            algorithm_for_date
            @particular_month_datetime = DateTime.new(@particular_month.first.year,@particular_month.first.month)
            # INITIALIZERS END

            respond_to do |format|
                format.js { render "task_month_view_save_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "task_month_view_save_fail.js.erb" }
            end
        end
    end

    def month_backward
        @this_year = params[:date_year].to_i
        @this_month = params[:date_month].to_i

        if @this_month - 1 != 0
            @particular_month = Calendar.where(:year => @this_year,:month => @this_month - 1)
        else
            if @this_year - 1 == 2013
                @particular_month = Calendar.where(:year => @this_year,:month => @this_month)
            else
                @particular_month = Calendar.where(:year => @this_year - 1,:month => 12)
            end
        end

        @today = @particular_month
        algorithm_for_date
        @particular_month_datetime = DateTime.new(@particular_month.first.year,@particular_month.first.month)

        respond_to do |format|
            format.js { render "month_view.js.erb" }
            format.html
        end         
    end

    def month_forward
        @this_year = params[:date_year].to_i
        @this_month = params[:date_month].to_i
        
        if @this_month + 1 != 13
            @particular_month = Calendar.where(:year => @this_year,:month => @this_month + 1)
        else
            if @this_year + 1 == 2031
                @particular_month = Calendar.where(:year => @this_year,:month => @this_month)
            else
                @particular_month = Calendar.where(:year => @this_year + 1,:month => 1)
            end
        end

        @today = @particular_month
        algorithm_for_date
        @particular_month_datetime = DateTime.new(@particular_month.first.year,@particular_month.first.month)

        respond_to do |format|
            format.js { render "month_view.js.erb" }
            format.html
        end 
    end
end
