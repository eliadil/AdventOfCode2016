defmodule Day02 do

    #1 2 3
    #4 5 6
    #7 8 9

    def task01 do
        file = File.read! "lib/day02.txt"
        file
        |> String.split("\n")
        |> task01Int([])
        |> IO.inspect()
    end

    def task02 do
        file = File.read! "lib/day02.txt"
        file
        |> String.split("\n")
        |> task02Int([])
        |> IO.inspect()
    end

    defp task01Int([], number), do: number

    defp task01Int([h | t], number) do
        task01Int(t, number ++ [findDigit(5, h)])
    end 

    defp findDigit(position, ""), do: position
    defp findDigit(position, directions) do
        where = String.at(directions, 0)
        rest = String.slice(directions, 1..1000000)
        findDigit(nextDigit(position, where), rest)
    end

    defp task02Int([], number), do: number

    defp task02Int([h | t], number) do
        task02Int(t, number ++ [findNumber(5, h)]) end

    defp findNumber(position, ""), do: position
    defp findNumber(position, directions) do
        where = String.at(directions, 0)
        rest = String.slice(directions, 1..1000000)
        findNumber(nextNumber(position, where), rest)
    end


    defp nextDigit(1, "R"), do: 2
    defp nextDigit(1, "D"), do: 4
    defp nextDigit(2, "L"), do: 1
    defp nextDigit(2, "R"), do: 3
    defp nextDigit(2, "D"), do: 5
    defp nextDigit(3, "L"), do: 2
    defp nextDigit(3, "D"), do: 6

    defp nextDigit(4, "U"), do: 1
    defp nextDigit(4, "R"), do: 5
    defp nextDigit(4, "D"), do: 7
    defp nextDigit(5, "L"), do: 4
    defp nextDigit(5, "U"), do: 2
    defp nextDigit(5, "R"), do: 6
    defp nextDigit(5, "D"), do: 8
    defp nextDigit(6, "L"), do: 5
    defp nextDigit(6, "U"), do: 3
    defp nextDigit(6, "D"), do: 9

    defp nextDigit(7, "R"), do: 8
    defp nextDigit(7, "U"), do: 4
    defp nextDigit(8, "L"), do: 7
    defp nextDigit(8, "R"), do: 9
    defp nextDigit(8, "U"), do: 5
    defp nextDigit(9, "L"), do: 8
    defp nextDigit(9, "U"), do: 6

    defp nextDigit(d, _), do: d



    defp nextNumber(1, "D"), do: 3
    defp nextNumber(5, "R"), do: 6
    defp nextNumber(9, "L"), do: 8
    defp nextNumber(13, "U"), do: 11

    defp nextNumber(2, "R"), do: 3
    defp nextNumber(2, "D"), do: 6
    defp nextNumber(3, "L"), do: 2
    defp nextNumber(3, "U"), do: 1
    defp nextNumber(3, "R"), do: 4
    defp nextNumber(3, "D"), do: 7
    defp nextNumber(4, "L"), do: 3
    defp nextNumber(4, "D"), do: 8

    defp nextNumber(6, "L"), do: 5
    defp nextNumber(6, "U"), do: 2
    defp nextNumber(6, "R"), do: 7
    defp nextNumber(6, "D"), do: 10
    defp nextNumber(7, "L"), do: 6
    defp nextNumber(7, "U"), do: 3
    defp nextNumber(7, "R"), do: 8
    defp nextNumber(7, "D"), do: 11
    defp nextNumber(8, "L"), do: 7
    defp nextNumber(8, "U"), do: 4
    defp nextNumber(8, "R"), do: 9
    defp nextNumber(8, "D"), do: 12

    defp nextNumber(10, "R"), do: 11
    defp nextNumber(10, "U"), do: 6
    defp nextNumber(11, "L"), do: 10
    defp nextNumber(11, "R"), do: 12
    defp nextNumber(11, "U"), do: 7
    defp nextNumber(11, "D"), do: 13
    defp nextNumber(12, "L"), do: 11
    defp nextNumber(12, "U"), do: 8
    
    defp nextNumber(d, _), do: d

end