defmodule Day06 do

    def task01 do
        file = File.read! "lib/day06.txt"

        String.split(file, "\r\n")
        |> Enum.map(&String.to_charlist/1)
        |> List.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&List.to_string/1)
        |> Enum.map(&String.graphemes/1)
        |> Enum.map(&Enum.sort/1)
        |> Enum.map(fn (x) -> 
            Enum.reduce(x, {"1", 0, "1", 0}, 
                fn (letter, {currentLetter, currentCount, maxLetter, maxCount}) -> 
                    if letter == currentLetter do
                        {currentLetter, currentCount + 1, maxLetter, maxCount}    
                    else
                        if currentCount > maxCount do
                            {letter, 1, currentLetter, currentCount}
                        else
                            {letter, 1, maxLetter, maxCount}
                        end
                    end 
                end) 
            end)
        |> Enum.map(fn({_, _, letter, _}) -> letter end)
        |> Enum.reduce("", &(&2 <> &1))
        |> IO.inspect
    end


    def task02 do
        file = File.read! "lib/day06.txt"

        String.split(file, "\r\n")
        |> Enum.map(&String.to_charlist/1)
        |> List.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&List.to_string/1)
        |> Enum.map(&String.graphemes/1)
        |> Enum.map(&Enum.sort/1)
        |> Enum.map(fn (x) -> 
            Enum.reduce(x, {"1", 100000, "1", 100000}, 
                fn (letter, {currentLetter, currentCount, minLetter, minCount}) -> 
                    if letter == currentLetter do
                        {currentLetter, currentCount + 1, minLetter, minCount}    
                    else
                        if currentCount < minCount do
                            {letter, 1, currentLetter, currentCount}
                        else
                            {letter, 1, minLetter, minCount}
                        end
                    end 
                end) 
            end)
        |> Enum.map(fn({_, _, letter, _}) -> letter end)
        |> Enum.reduce("", &(&2 <> &1))
        |> IO.inspect
    end
end