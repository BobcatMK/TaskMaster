module TaskHelper
    def algorithm_for_date
        @this_month = Calendar.all.where(:year => @today.first.year,:month => @today.first.month)
        @today_in_datetime = DateTime.new(@today.first.year,@today.first.month,@today.first.day)
        @days_in_month = @this_month.length
        @month_array = []
        @days_array_to_push = []
        @duplicated_days_array_to_push = []
        @this_month.each do |dzien|
            @weekday = DateTime.new(dzien.year,dzien.month,dzien.day)
            @weekday_in_number = @weekday.wday
            if @weekday_in_number == 1 && @days_array_to_push.length > 0
                @duplicated_days_array_to_push = @days_array_to_push.clone
                @month_array.push(@duplicated_days_array_to_push)
                @days_array_to_push.clear
            end
            @days_array_to_push.push(dzien)
            if @this_month.length == (@this_month.index(dzien) + 1)
                @duplicated_days_array_to_push = @days_array_to_push.clone
                @month_array.push(@duplicated_days_array_to_push)
                @days_array_to_push.clear
            end
        end     
        if @month_array.first.length < 7
            @items_to_unshift = 7 - @month_array.first.length
            @items_to_unshift.times do
                @month_array.first.unshift("0")
            end
        end
        if @month_array.last.length < 7
            @items_to_push = 7 - @month_array.last.length
            @items_to_push.times do
                @month_array.last.push("0")
            end
        end
    end
end
