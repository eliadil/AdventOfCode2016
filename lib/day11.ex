defmodule Day11 do

    def task01 do
        file = File.read! "lib/day11.txt"
        {state, _} = file
        |> String.split("\r\n")
        |> Enum.map(fn(x) -> tokenize(x) end)
        |> Enum.reduce({%{}, 1} , fn(onThisFloor, {map, floor}) ->

                {Map.put(map, floor, onThisFloor), floor+1}
            end)


        loop([{{state, 1},[]}], 0, [])
        |> IO.inspect
    end


    defp tokenize(string) do
        r = ~r/((?:[a-z]+ generator)|(?:[a-z]+-compatible))/

        Regex.scan(r, string, capture: :all_but_first)
        |> List.flatten
        |> Enum.map(fn(x) ->
            [which, type] = String.replace(x, "-", " ")
            |> String.split(" ")    
            atomType = if type == "generator", do: :generator, else: :chip
            {atomType, String.to_atom(which)}
        end)
    end

    defp loop(states, movesDone, statesAny) do
        nextStatesAll = Enum.reduce(states, [], fn({{state, floor}, history}, acc) ->
                possibleMoves = getPossibleMoves(state, floor)
                #possibleMoves |> Enum.count |> IO.inspect
                newStuff = possibleMoves
                |> Enum.map(fn({whatToMove, toFloor}) -> 
                    newState = Map.update(state, toFloor, [], fn(x) -> x ++ whatToMove end)
                    newState2 = Map.update(newState, floor, [], fn(x) -> whatToMove |> Enum.reduce(x, &(List.delete(&2,&1))) end)
                    {{newState2, toFloor}, history}
                end)
                acc ++ newStuff
            end)
        |> Enum.uniq_by(fn({a, _history}) -> a end)
        
        nextStates = nextStatesAll -- statesAny
        IO.inspect(nextStates == nextStatesAll)

        if Enum.count(nextStates, fn({{state, _}, _history}) -> isDone(state) end) > 0  do
            Enum.filter(nextStates, fn({{state, _}, _history}) -> isDone(state) end) |> IO.inspect
            movesDone + 1
        else 
            
            #if movesDone < 2 do
            
            #nextStates |> Enum.count |> IO.puts
            loop(nextStates, movesDone + 1, statesAny ++ nextStates)
        #end
        end
    end

    defp getPossibleMoves(state, floorAt) do
        floorContent = Map.get(state, floorAt)
        list = for x <- floorContent,
            y <- List.delete(floorContent, x) do
            [x, y] 
        end
        pairs = Enum.reduce(list, [], fn([x,y], acc) -> 
            if Enum.filter(acc, fn([a,b]) -> a == y and b == x end) == [] do
                acc ++ [[x, y]]
            else
                acc
            end 
        end)

        allPairs = pairs ++ Enum.map(floorContent, &([&1]))

        maybePossible = for pair <- allPairs,
            toFloor <- [(floorAt-1), (floorAt + 1)] do
            {pair, toFloor}        
        end

        Enum.filter(maybePossible, fn(x) -> isMovePossible(state, x) end)
    end

    defp isMovePossible(_state, {_whatToMove, 0}) do
        false
    end

    defp isMovePossible(_state, {_whatToMove, 5}) do
        false
    end

    defp isMovePossible(state, {whatToMove, toFloor}) do
        wot = Map.get(state, toFloor) ++whatToMove

        howManyGens = Enum.filter(wot, fn({what, _}) -> what == :generator end) |> Enum.count

        if howManyGens == 0 do
            true
        else
        
        howManyChipsToMove = Enum.filter(whatToMove, fn({what, _}) -> what == :chip end) |> Enum.count
        if howManyChipsToMove == 0 do
            false
        else
            avNames = Enum.map(wot, fn({_, name}) -> name end)
            Enum.count(Enum.uniq(avNames)) != Enum.count(avNames)
        end
        
        end
    end

    defp isDone(state) do
        on3 = Map.get(state, 3) |> Enum.count
        on2 = Map.get(state, 2) |> Enum.count
        on1 = Map.get(state, 1) |> Enum.count
        on3+on2+on1 == 0
    end
end