defmodule Day01 do



    def task01 do
        {:ok, file} = File.read "lib/day01.txt"
        directions = String.split(file, ", ")

        endPos = getEndPosition(directions, {0, 0, :north})

        IO.inspect endPos

        {a, b} = endPos
        dist = abs(a) + abs(b)
        IO.puts dist
    end

    def task02 do
        {:ok, file} = File.read "lib/day01.txt"
        directions = String.split(file, ", ")

        endPos = getFirstPositionVisitedTwice(directions, {0, 0, :north}, MapSet.new([{0, 0}]))
        IO.inspect endPos

        {a, b} = endPos
        dist = abs(a) + abs(b)
        IO.puts dist

        #IO.inspect posSet
    end

    defp getEndPosition([], {posX, posY, _}), do: {posX, posY}

    defp getEndPosition([h | t], {posX, posY, direction}) do 
        
        turn = String.slice(h, 0..0)
        steps = String.to_integer(String.slice(h, 1..1000))
        
        newDirection = getNewDirection(direction, turn)
        
        newPos = cond do 
            newDirection == :west ->
                {posX - steps, posY, newDirection}
            newDirection == :east ->
                {posX + steps, posY, newDirection}
            newDirection == :north ->
                {posX, posY + steps, newDirection}
            newDirection == :south ->
                {posX, posY - steps, newDirection}
        end

       getEndPosition(t, newPos)
    end

    defp getNewDirection(:north, "R"), do: :east
    defp getNewDirection(:east, "R"), do: :south
    defp getNewDirection(:south, "R"), do: :west
    defp getNewDirection(:west, "R"), do: :north
    defp getNewDirection(:north, "L"), do: :west
    defp getNewDirection(:west, "L"), do: :south
    defp getNewDirection(:south, "L"), do: :east
    defp getNewDirection(:east, "L"), do: :north

    defp getFirstPositionVisitedTwice([], {posX, posY, _}, _), do: :none

    defp getFirstPositionVisitedTwice([h | t], {posX, posY, direction}, pSet) do
        turn = String.slice(h, 0..0)
        steps = String.to_integer(String.slice(h, 1..1000))
        newDirection = getNewDirection(direction, turn)
        
        littleStep = cond do 
            newDirection == :west ->
                {-1, 0}
            newDirection == :east ->
                {1, 0}
            newDirection == :north ->
                {0, 1}
            newDirection == :south ->
                {0, -1}
        end

        newPSet = addPositions(littleStep, steps, {posX, posY}, pSet)

        newPos = cond do 
            newDirection == :west ->
                {posX - steps, posY, newDirection}
            newDirection == :east ->
                {posX + steps, posY, newDirection}
            newDirection == :north ->
                {posX, posY + steps, newDirection}
            newDirection == :south ->
                {posX, posY - steps, newDirection}
        end

        cond do 
            is_tuple(newPSet) ->
                IO.inspect newPSet
                newPSet
            true ->
                getFirstPositionVisitedTwice(t, newPos, newPSet)
        end
    end

    defp addPositions(_, 0, _, pSet), do: pSet

    defp addPositions({movX, movY}, times, {posX, posY}, pSet) do
        newPos = {posX + movX, posY + movY}
        cond do 
            Set.member?(pSet, newPos) ->
                newPos
            true ->
                addPositions({movX, movY}, times - 1, newPos, Set.put(pSet, newPos))
        end
    end
end
