module WeekHelper
    def week_view_calendar(today)
        @particular_week ||= []

        day_today = today
        
        if day_today == nil
            return
        end

        today_in_wday ||= DateTime.new(day_today.year,day_today.month,day_today.day).wday

        calendar_id ||= day_today.id

        if today_in_wday > 1
            @starter = calendar_id
            @iterator = @starter
            record = Calendar.find(@starter)
            check = DateTime.new(record.year,record.month,record.day)
            while check.wday >= 1
                @particular_week.unshift(record)
                @iterator -= 1
                begin
                    record = Calendar.find(@iterator)
                rescue
                    break
                end
                check = DateTime.new(record.year,record.month,record.day)
            end
            begin 
                record = Calendar.find(@starter + 1)
            rescue
                array_constructor
                return
            end
            check = DateTime.new(record.year,record.month,record.day)
            @iterator = record.id
            while check.wday <= 6 && check.wday != 0
                @particular_week.push(record)
                @iterator += 1
                begin
                    record = Calendar.find(@iterator)
                rescue
                    array_constructor
                    return
                end
                check = DateTime.new(record.year,record.month,record.day)
            end
            @particular_week.push(record)
        elsif today_in_wday == 1
            @starter = calendar_id
            @iterator = @starter
            record = Calendar.find(@starter)
            check = DateTime.new(record.year,record.month,record.day)
            while check.wday <= 6 && check.wday != 0
                @particular_week.push(record)
                @iterator += 1
                begin
                    record = Calendar.find(@iterator)
                rescue
                    array_constructor
                    return
                end
                check = DateTime.new(record.year,record.month,record.day)
            end
            @particular_week.push(record)
        elsif today_in_wday == 0
            @starter = calendar_id
            @iterator = @starter - 1
            record = Calendar.find(@starter)
            @particular_week.unshift(record)
            begin
                for_while_loop = Calendar.find(@iterator)
            rescue
                array_constructor
                return
            end
            check = DateTime.new(for_while_loop.year,for_while_loop.month,for_while_loop.day)
            while check.wday >= 1
                @particular_week.unshift(for_while_loop)
                @iterator -= 1
                begin
                    for_while_loop = Calendar.find(@iterator)
                rescue
                    array_constructor
                    return
                end
                check = DateTime.new(for_while_loop.year,for_while_loop.month,for_while_loop.day)                
            end
        end

        array_constructor
    end

    def next_seven_days_initializer
        @today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day).first

        if @today == nil
            return
        end

        @today_id = @today.id

        @iterator = 7
        @iterator_id = @today_id

        @next_seven_days = []
        @next_seven_days_datetime = []

        while @iterator > 0
            begin
                @for_push_calendar = Calendar.find(@iterator_id)
            rescue
                break
            end
            @next_seven_days.push(@for_push_calendar)
            @next_seven_days_datetime.push(DateTime.new(@for_push_calendar.year,@for_push_calendar.month,@for_push_calendar.day))
            @iterator_id += 1
            @iterator -= 1
        end
    end

    private

        def array_constructor
            @particular_week_datetime = []
            @particular_week.each do |calendar_record|
                datetime = DateTime.new(calendar_record.year,calendar_record.month,calendar_record.day)
                @particular_week_datetime.push(datetime)
            end
        end
end
