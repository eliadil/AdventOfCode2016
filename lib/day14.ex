defmodule Day14 do

    def task01 do
        input = File.read! "lib/day14.txt"

        (nil != [])
        |> IO.inspect

        Stream.iterate(0, &(&1 + 1))
        |> Stream.map(fn(x) -> {x, input <> Integer.to_string(x)} end)
        |> Stream.map(fn({id, phrase}) -> {id, getMD5(phrase)} end)
        |> Stream.map(fn({id, md5}) -> {id, parseMD5(md5)} end)
        |> Stream.filter(fn({_id, {triple, fives}}) -> triple != nil or fives != [] end)
        |> Enum.take(10)
        
        |> IO.inspect
    end

    defp getMD5(input) do
        :crypto.hash(:md5, String.to_charlist(input))
        |> Base.encode16(case: :lower)
    end

    defp parseMD5(input) do
        {getFirstTriple(input), getAllFives(input)}
    end

    defp getFirstTriple(input) do
        Regex.run(~r/(.)\1{2}/, input, capture: :first)
    end

    defp getAllFives(input) do
        Regex.scan(~r/(.)\1{4}/, input)
    end
end