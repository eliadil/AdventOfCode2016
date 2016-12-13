defmodule Day10 do

    def task01 do
        file = File.read! "lib/day10.txt"

        moves = file
        |> String.split("\r\n")
        |> Enum.map(fn(x) -> tokenize(x) end)
        state = doMoves(moves, %{})
        |> IO.inspect

        [Map.get(state, 0), Map.get(state, -1), Map.get(state, -2)]
        |> List.flatten
        |> Enum.reduce(1, &(&1*&2))
        |> IO.inspect
        
    end

    def tokenize(string) do
        b = ~r/bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
        s = ~r/value (\d+) goes to bot (\d+)/

        if(Regex.match?(b, string)) do
            [[_, a,b,c,d,e]] = Regex.scan(b, string)

            {:move, {String.to_integer(a),String.to_atom(b),String.to_integer(c),String.to_atom(d),String.to_integer(e)}}
        else
            [[_, a,b]] = Regex.scan(s, string)
            {:start, {String.to_integer(a),String.to_integer(b)}}
        end
    end

    defp doMoves([], botState) do
        botState
    end

    defp doMoves(moves, botState) do
        doNow = moves
        |> Enum.filter(fn(x) -> canDoMove(x, botState) end)
        doLater = moves
        |> Enum.filter(fn(x) -> !canDoMove(x, botState) end)
        
        #IO.inspect doNow
        newState = doNow
        |> Enum.reduce(botState, &doMove/2)
        
        doMoves(doLater, newState)
    end

    defp canDoMove({:move, {a, _, _, _, _}}, botState) do
        if Map.has_key?(botState, a) do
            ile = Map.get(botState, a)
            |> Enum.count
            ile == 2
        else
            false
        end
    end

    defp canDoMove({:start, _}, _) do
        true
    end

    defp doMove({:start, {value, botNumber}}, botState) do
        Map.update(botState, botNumber, [value], fn(x) -> x ++ [value] end)
    end

    defp doMove({:move, {botNumber, lowWhat, lowWhere, highWhat, highWhere}}, botState) do
        {[a,b], newState} = Map.pop(botState, botNumber)
        [sa,sb] = [a,b]
        |> Enum.sort

        if sa == 17 and sb == 61, do: IO.inspect {botNumber, {sa,sb}}

        newerState = if lowWhat == :bot do
            Map.update(newState, lowWhere, [sa], fn(x) -> x ++ [sa] end)
        else
            Map.update(newState, -lowWhere, [sa], fn(x) -> x ++ [sa] end)
        end
        
        if highWhat == :bot do
            Map.update(newerState, highWhere, [sb], fn(x) -> x ++ [sb] end)
        else
            Map.update(newerState, -highWhere, [sb], fn(x) -> x ++ [sb] end)
        end

    end
end