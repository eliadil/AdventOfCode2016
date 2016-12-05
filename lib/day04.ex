defmodule Day04 do

    def task01 do
        file = File.read! "lib/day04.txt"
        
        String.split(file, "\r\n")
        |> Enum.reduce(0, fn(x, acc) -> isReal(x) + acc end)
        |> IO.puts
    end

    def isReal(roomDesc) do 
        r = ~r/([a-z\-]+)(\d+)\[([a-z]+)\]/
        [[_, encryptedName, sectorID, checksum]] = Regex.scan(r, roomDesc)
        
        woot = 
        encryptedName
        |> String.graphemes
        |> Enum.filter(fn(c) -> c =~ ~r/[a-z]/ end)
        |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, fn(k) -> k + 1 end) end)
        |> Enum.sort(fn({k, v}, {k2, v2}) -> v > v2 or v == v2 and k < k2 end) 
        |> Enum.take(5)
        |> Enum.map(fn({k, _}) -> k end)
        |> Enum.reduce("", fn(x, acc) -> acc <> x end)
        
        cond do
            woot == checksum -> String.to_integer(sectorID)
            true -> 0
        end
    end


    def task02 do
        file = File.read! "lib/day04.txt"

        String.split(file, "\r\n")
        |> Enum.map(&getName/1)
        |> Enum.filter(fn ({name, _id}) -> String.contains?(name, "northpole") end)
        |> IO.inspect
    end

    def getName(roomDesc) do 
        
        r = ~r/([a-z\-]+)(\d+)\[([a-z]+)\]/
        [[_, encryptedName, sectorID, _checksum]] = Regex.scan(r, roomDesc)
        
        intSectorId = String.to_integer(sectorID)
        
        normalName = encryptedName
        |> String.to_charlist
        |> Enum.map(fn(x) -> case [x] do
            '-' -> " "
            _ -> 97 + rem x-97+intSectorId, 26
        end end)

        
        {List.to_string(normalName), intSectorId}
    end


end