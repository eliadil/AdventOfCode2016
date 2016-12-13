defmodule Day12 do

    def task01 do
        file = File.read! "lib/day12.txt"
        instructions = String.split(file, "\r\n")
        |> Enum.map(&tokenize/1)


    end

    defp tokenize(string) do
        IO.puts "wot"
    end


    defp inc(state, key) do
        Map.update(state, key, 0, &(&1 + 1))
    end

    defp dec(state, key) do
        Map.update(state, key, 0, &(&1 - 1))
    end


    defp cpy(state, key) do
        
    end
end