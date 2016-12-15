defmodule Day15 do

    def task01 do
        {_, discMap} = File.read!("lib/day15v2.txt")
        |> String.split("\r\n")
        |> Enum.map(fn(x) -> tokenize(x) end)
        |> Enum.reduce({0, %{}}, fn(disc, {i, map}) -> 
                {i+ 1, Map.put(map, i, disc)}
        end)
        discMap
        |> IO.inspect

        time = Stream.iterate(0, &(&1 + 1))
        |> Stream.filter(fn(x) -> 
            discMap
            |> Enum.reduce(true, fn({i, disc}, acc) ->     
                acc and (getPosAt(disc, x + i + 1) == 0)
            end)
        end)
        |> Enum.take(1)
        |> IO.inspect


    end

    defp tokenize(string) do
        r = ~r/has (\d+) positions; at time=0, it is at position (\d+)/
        Regex.scan(r, string, capture: :all_but_first)
        |> List.flatten
        |> Enum.map(&(String.to_integer(&1)))
        |> List.to_tuple
        
    end

    defp getPosAt(disc = {stops, zeroPos}, at) do
        #IO.inspect {disc, at}
        rem(zeroPos + at, stops)
    end
end