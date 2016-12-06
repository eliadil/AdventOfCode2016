defmodule Day05 do

    def task01 do
        pass = File.read! "lib/day05.txt"

        0..100000000
        |> Stream.map( &(:crypto.hash(:md5, [String.to_charlist(pass), Integer.to_string(&1)])) )
        |> Stream.map( &(Base.encode16(&1, case: :lower)) )
        |> Stream.filter( fn(x) -> String.starts_with?(x, "00000") end )
        |> Stream.take(8)
        |> Enum.map( fn(x) -> String.at(x, 5) end )
        |> IO.inspect
    end


    
    def task02 do
        pass = File.read! "lib/day05.txt"

        0..100000000
        |> Stream.map( &(:crypto.hash(:md5, [String.to_charlist(pass), Integer.to_string(&1)])) )
        |> Stream.map( &(Base.encode16(&1, case: :lower)) )
        |> Stream.filter( fn(x) -> String.starts_with?(x, "00000") end )
        |> Stream.map( fn(x) -> String.slice(x, 5, 2) end )
        |> Enum.reduce_while(%{}, 
            fn(x, acc) ->

                {place, char} = {String.at(x, 0), String.at(x, 1)}
                newAcc = if Map.has_key?(acc, place) == false and String.contains?("01234567", place) do
                    Map.put(acc, place, char)
                    else 
                        acc
                end

                if Map.keys(newAcc) |> Enum.count == 8 do
                    {:halt, newAcc}
                else
                    {:cont, newAcc}
                end
            end)
        |> IO.inspect
    end
end