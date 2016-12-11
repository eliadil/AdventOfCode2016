defmodule Day08 do

    def task01 do
        file = File.read! "lib/day08.txt"
        moves = String.split(file, "\r\n")
        |> Enum.map(&(stringInstructionToTuple(&1)))

        wot = Enum.reduce(moves, MapSet.new, fn(move, state) -> doMove(move, state) end)
        wot
        |> Enum.count
        |> IO.inspect


        0..5
        |> Enum.map(fn(x) -> 
            0..49
            |> Enum.map(fn(y) -> if MapSet.member?(wot, {y,x}) do
                        "*"
                        else
                        "."
                        end  
                    end)  
         end)
         |> Enum.map(fn(x) -> 
         Enum.reduce(x, "", &(&2<>&1))
         end)
         |> IO.inspect
    end

    defp stringInstructionToTuple(string) do
        rect = ~r/rect (\d+)x(\d+)/
        row = ~r/rotate row y=(\d+) by (\d+)/
        col = ~r/rotate column x=(\d+) by (\d+)/

        [{name, regex}] = [{:rect, rect}, {:row, row}, {:col, col}]
        |> Enum.filter(fn({_name, regex}) -> Regex.match?(regex, string)  end)

        [[_,a,b]] = Regex.scan(regex, string)
        {name, String.to_integer(a), String.to_integer(b)}
    end


    defp doMove({:rect, width, height}, state) do
        0..width-1
        |> Enum.map(fn(x) -> 0..height-1 |> Enum.map(fn(y) -> {x, y} end) end)
        |> List.flatten
        |> Enum.reduce(state, fn(x, acc) -> MapSet.put(acc, x) end)
    end

    defp doMove({:col, column, moveBy}, state) do
        litElementsInColumn = Enum.filter(state, fn({x, _y}) -> x == column end)
        
        stateWithoutColumn = Enum.reduce(litElementsInColumn, state, fn(x, acc) -> MapSet.delete(acc, x) end)
        
        Enum.map(litElementsInColumn, fn({x, y}) -> {x, rem(y+moveBy, 6)}  end)
        |> Enum.reduce(stateWithoutColumn, fn(x, acc) -> MapSet.put(acc, x) end)
    end

    defp doMove({:row, row, moveBy}, state) do
        litElementsInColumn = Enum.filter(state, fn({_x, y}) -> y == row end)
        
        stateWithoutColumn = Enum.reduce(litElementsInColumn, state, fn(x, acc) -> MapSet.delete(acc, x) end)
        
        Enum.map(litElementsInColumn, fn({x, y}) -> {rem(x+moveBy, 50), y}  end)
        |> Enum.reduce(stateWithoutColumn, fn(x, acc) -> MapSet.put(acc, x) end)
    end

    def task02 do
        file = File.read! "lib/day08.txt"
    end
end