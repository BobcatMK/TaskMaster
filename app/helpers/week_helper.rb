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

    private

        def array_constructor
            @particular_week_datetime = []
            @particular_week.each do |calendar_record|
                datetime = DateTime.new(calendar_record.year,calendar_record.month,calendar_record.day)
                @particular_week_datetime.push(datetime)
            end
        end
end
