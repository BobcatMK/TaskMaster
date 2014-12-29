class WeekController < ApplicationController

    def week_view
        @particular_week = []
        day_today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day).first
        today_in_wday = Date.today.wday

        calendar_id = day_today.id

        if today_in_wday > 1
            @starter = calendar_id
            @iterator = @starter
            record = Calendar.find(@starter)
            check = DateTime.new(record.year,record.month,record.day)
            while check.wday >= 1
                @particular_week.unshift(record)
                @iterator -= 1
                record = Calendar.find(@iterator)
                check = DateTime.new(record.year,record.month,record.day)
            end
            record = Calendar.find(@starter + 1)
            check = DateTime.new(record.year,record.month,record.day)
            @iterator = record.id
            while check.wday <= 6 && check.wday != 0
                @particular_week.push(record)
                @iterator += 1
                record = Calendar.find(@iterator)
                check = DateTime.new(record.year,record.month,record.day)
            end
            if check.wday == 0
                @particular_week.push(record)
            end
        elsif today_in_wday == 1
            @starter = calendar_id
            @iterator = @starter
            record = Calendar.find(@starter)
            check = DateTime.new(record.year,record.month,record.day)
            while check.wday <= 6 && check.wday != 0
                @particular_week.push(record)
                @iterator += 1
                record = Calendar.find(@iterator)
                check = DateTime.new(record.year,record.month,record.day)
            end
            if check.wday == 0
                @particular_week.push(record)
            end
        elsif today_in_wday == 0
            @starter = calendar_id
            @iterator = @starter - 1
            record = Calendar.find(@starter)
            @particular_week.unshift(record)
            for_while_loop = Calendar.find(@iterator)
            check = DateTime.new(for_while_loop.year,for_while_loop.month,for_while_loop.day)
            while check.wday >= 1
                @particular_week.unshift(for_while_loop)
                @iterator -= 1
                for_while_loop = Calendar.find(@iterator)
                check = DateTime.new(for_while_loop.year,for_while_loop.month,for_while_loop.day)                
            end
        end

        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        puts @particular_week.inspect
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

        render :nothing => true

        # respond_to do |format|
        #     format.js { render "week_view.js.erb" }
        #     format.html { redirect_to logged_signed_path }
        # end
    end

end
