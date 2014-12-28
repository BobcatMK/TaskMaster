module ApplicationHelper

    def sorting_algorithm_and_initializer
        @actually_today = Calendar.where(:year => Date.today.year,:month => Date.today.month,:day => Date.today.day)

        @tasks_for_today = @today.first.tasks

        @today_datetime = DateTime.new(@today.first.year,@today.first.month,@today.first.day)
        @actually_today_datetime = DateTime.new(@actually_today.first.year,@actually_today.first.month,@actually_today.first.day)


        @sorted = @tasks_for_today.sort do |a,b| 
            a.start <=> b.start
        end

        @counter = 0
        @temp_sorter = []
        @start_from = 0

        while @counter < @sorted.length
            @start_from += @temp_sorter.length
            @temp_sorter.clear
            @i = @start_from

            while @sorted[@start_from].start == @sorted[@i].start
                @temp_sorter.push(@sorted[@i])
                if @i == @sorted.rindex(@sorted.last)
                    break
                end
                @i += 1
            end

            @sorted.slice!(@start_from,@temp_sorter.length)

            #@temp_sorter.sort { |a,b| a.end <=> b.end } This standard sorting algorithm is not working properly.

            @checker = 0
            @iterate = 0
            @sorted_uniq = []

            while @iterate <= (@temp_sorter.length - 1)
              @temp_sorter.each do |item|
                if @temp_sorter[@iterate].end > item.end
                  @checker += 1
                end
              end
              @sorted_uniq.push(@checker)
              @iterate += 1
              @checker = 0
            end

            @result = {}

            @temp_sorter.each.with_index do |item,index|
                @result[item] = @sorted_uniq[index]
            end

            @result.each_pair do |key,value|
                @temp_holder = @temp_sorter.slice!(@temp_sorter.index(key))
                @temp_sorter.insert(value,@temp_holder)
            end

            @temp_sorter = @temp_sorter.reverse

            @temp_sorter.each do |item|
                @sorted.insert(@start_from,item)
            end
            @counter += @temp_sorter.length
        end
    end




end
