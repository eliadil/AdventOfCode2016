defmodule Day13 do

    def task01 do
        
        "┌" |> IO.puts
        #printOffice(31,39)
    end

    defp isWall(x, y) do
        
        numOfOnes = x*x + 3*x + 2*x*y + y + y*y  +  1358
        |> Integer.to_string(2)
        |> String.graphemes
        |> Enum.count(&(&1 == "1"))
        |> rem(2)

        1 == numOfOnes
    end

    defp printOffice(columns, -1) do
    end

    defp printOffice(columns, rows) do
        printRow(rows, columns)
        printOffice(columns, rows-1)
    end

    defp printRow(_, -1) do
        IO.puts ""
    end

    defp printRow(row, column) do
        if isWall(row, column) do
            IO.write "┌"
        else 
            IO.write "."
        end
        printRow(row, column - 1)
    end 
end