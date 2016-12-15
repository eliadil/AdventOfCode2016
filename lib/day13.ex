defmodule Day13 do

    def task01 do
        
        printOffice(140,140)
        bfs([{1,1}],0,Map.new)
        |> IO.inspect
    end

    def task02 do
        bfsCount([{1,1}], 0, Map.new)
        |> Map.keys
        |> Enum.count
        |> IO.inspect
    end

    defp isWall(-1, _), do: true
    defp isWall(_, -1), do: true

    defp isWall(x, y) do
        
        numOfOnes = x*x + 3*x + 2*x*y + y + y*y  +  1358
        |> Integer.to_string(2)
        |> String.graphemes
        |> Enum.count(&(&1 == "1"))
        |> rem(2)

        1 == numOfOnes
    end

    defp printOffice(_columns, -2) do
    end

    defp printOffice(columns, rows) do
        printRow(rows, columns)
        printOffice(columns, rows-1)
    end

    defp printRow(_, -2) do
        IO.puts ""
    end

    defp printRow(row, column) do

        if row == 31 and column == 39 do 
            IO.write "X"
        else
        if isWall(row, column) do
            IO.write " "
        else 
            IO.write "█"
        end
        end
        printRow(row, column - 1)
    end 


    defp bfs(placesToLook, turn, history) do
        newHistory = Enum.reduce(placesToLook, history, fn(x, acc) -> Map.put(acc, x, turn) end)

        if Map.has_key?(newHistory, {31, 39}) do
            Map.get(newHistory, {31, 39})
        else
            wot =Enum.map(placesToLook, fn(x) -> getNeighbours(x) end)
            |> List.flatten
            |> Enum.uniq
            |> Enum.filter(fn({x,y}) -> isWall(x,y) == false end)
            |> Enum.filter(fn(x) -> Map.has_key?(newHistory, x) == false end)
            wot |> IO.inspect

            bfs(wot, turn + 1, newHistory)
        end
    end

    defp bfsCount(placesToLook, 51, history) do
        history
    end

    defp bfsCount(placesToLook, turn, history) do
        newHistory = Enum.reduce(placesToLook, history, fn(x, acc) -> Map.put(acc, x, turn) end)
        wot =Enum.map(placesToLook, fn(x) -> getNeighbours(x) end)
        |> List.flatten
        |> Enum.uniq
        |> Enum.filter(fn({x,y}) -> isWall(x,y) == false end)
        |> Enum.filter(fn(x) -> Map.has_key?(newHistory, x) == false end)
        wot |> IO.inspect

        bfsCount(wot, turn + 1, newHistory)
    end

    defp getNeighbours(p) do
        [n(p), e(p), w(p), s(p)]
    end

    defp n({x,y}), do: {x+1, y}
    defp e({x,y}), do: {x, y+1}
    defp w({x,y}), do: {x, y-1}
    defp s({x,y}), do: {x-1, y}

end