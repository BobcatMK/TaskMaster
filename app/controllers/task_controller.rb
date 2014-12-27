class TaskController < ApplicationController

    include TaskHelper
    include ApplicationHelper

    before_action :set_current_date, only: [
        :change_year_forward,
        :change_year_backward,
        :change_month_forward,
        :change_month_backward,
        :change_year_forward_end,
        :change_year_backward_end,
        :change_month_forward_end,
        :change_month_backward_end
    ]
    

    def add_task_get
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        @task = Task.new
        @todolists = Todolist.where(:user_id => current_user.id)
        respond_to do |format|
            format.js { render "add_task_get.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def create_task

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

            main_page_initializer  # This method is placed in ApplicationHelper it initializes every object that is needed for new ajax generate page.

            respond_to do |format|
                format.js { render "task_save_success.js.erb" }
            end
        else
            respond_to do |format|
                format.js { render "task_save_fail.js.erb" }
            end
        end

    end

    def task_completed
        @task = Task.find(params[:task][:id])
        @task.calendars.clear
        @task.update(:completed => params[:task][:completed])

        main_page_initializer

        respond_to do |response|
            response.js { render "task_completed_success.js.erb",:locals => {:@remove_this => @task.id} }
            response.html { redirect_to logged_signed_path }
        end
    end






# BELOW ARE ACTIONS USED BY ADD_TASK_GET TO GENERATE PROPER START AND END DATES FOR NEWLY ADDED TASK

    # FIRSTLY YOU CAN SEE START DATE
    def start_date
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        algorithm_for_date

        respond_to do |format|
            format.js { render "start_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_year_forward
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_year == 2030
            @change_record = Calendar.where(:year => 2030,:month => @records_month)
        else
            @change_record = Calendar.where(:year => (@records_year + 1),:month => @records_month)
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "start_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_year_backward
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_year == 2014
            @change_record = Calendar.where(:year => 2014,:month => @records_month)
        else
            @change_record = Calendar.where(:year => (@records_year - 1),:month => @records_month)
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "start_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_month_forward
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_month == 12
            @change_record = Calendar.where(:year => @records_year,:month => 12)
        else
            @change_record = Calendar.where(:year => @records_year,:month => (@records_month + 1))
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "start_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_month_backward
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_month == 1
            @change_record = Calendar.where(:year => @records_year,:month => 1)
        else @records_month != 1
            @change_record = Calendar.where(:year => @records_year,:month => (@records_month - 1))
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "start_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    # SECONDLY YOU CAN SEE END DATE
    def end_date
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
        algorithm_for_date

        respond_to do |format|
            format.js { render "end_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_year_forward_end
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_year == 2030
            @change_record = Calendar.where(:year => 2030,:month => @records_month)
        else
            @change_record = Calendar.where(:year => (@records_year + 1),:month => @records_month)
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "end_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_year_backward_end
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_year == 2014
            @change_record = Calendar.where(:year => 2014,:month => @records_month)
        else
            @change_record = Calendar.where(:year => (@records_year - 1),:month => @records_month)
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "end_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_month_forward_end
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_month == 12
            @change_record = Calendar.where(:year => @records_year,:month => 12)
        else
            @change_record = Calendar.where(:year => @records_year,:month => (@records_month + 1))
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "end_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    def change_month_backward_end
        @records_year = @current_date.first.year
        @records_month = @current_date.first.month
        if @records_month == 1
            @change_record = Calendar.where(:year => @records_year,:month => 1)
        else @records_month != 1
            @change_record = Calendar.where(:year => @records_year,:month => (@records_month - 1))
        end

        @today = @change_record
        algorithm_for_date

        respond_to do |format|
            format.js { render "end_date.js.erb" }
            format.html { redirect_to logged_signed_path }
        end
    end

    private

        def set_current_date
            @current_date = Calendar.where(:year => params[:date_year],:month => params[:date_month])
        end

end
