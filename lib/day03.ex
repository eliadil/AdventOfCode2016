defmodule Day03 do

    def task01 do
        file = File.read! "lib/day03.txt"
        file
        |> String.split("\r\n")
        |> Enum.map(fn(x) -> String.split(x, " ")
                            |> Enum.filter(fn(z) -> z != "" end)
                    end )
        |> Enum.map(fn(x) -> Enum.map(x, fn(y) -> String.to_integer(y) end)
                    end )
        |> Enum.filter(fn([a,b,c]) -> a+b>c && a+c>b && b+c>a end)
        |> Enum.count()
        |> IO.inspect()
    end

    def task02 do
        file = File.read! "lib/day03.txt"
        file
        |> String.split("\r\n")
        |> Enum.map(fn(x) -> String.split(x, " ")
                            |> Enum.filter(fn(z) -> z != "" end)
                    end )
        |> Enum.map(fn(x) -> Enum.map(x, &String.to_integer/1) end )
        |> Enum.chunk(3)
        |> Enum.map(&List.zip/1)
        |> List.flatten
        |> Enum.filter(fn({a,b,c})-> a+b>c && a+c>b && b+c>a end)
        |> Enum.count()
        |> IO.inspect()
    end


end