module TaskviewHelper
    def taskview_initializer
        @all_tasks_assigned ||= Task.where(:user_id => current_user.id,:completed => false)

        @sort_by = params[:sort_by]
        @sort_by ||= "start"

        @all_calendars = {}

        @all_tasks_assigned.each do |item|
            if @sort_by == "start"
                date_helper = DateTime.new(item.start.year,item.start.month,item.start.day)
            elsif @sort_by == "end"
                date_helper = DateTime.new(item.end.year,item.end.month,item.end.day)
            end
            if @all_calendars.has_key?(date_helper) == false
                @all_calendars[date_helper] = []
            end
            @all_calendars[date_helper].push(item)
        end

        @all_calendars = Hash[@all_calendars.sort]

        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)
    end
end
