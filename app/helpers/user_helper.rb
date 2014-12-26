module UserHelper
    def looping
        while @sorted[@start_from].start.eql?(@sorted[@i].start)
            @temp_sorter.push(@sorted[@i])
            @i += 1
        end
        @sorted.slice!(@start_from,@temp_sorter.length)
        @temp_sorter.sort { |a,b| a.end <=> b.end }
        @temp_sorter.each do |item|
            @sorted.insert(@start_from,item)
        end
        @counter += @temp_sorter.length
    end
end
