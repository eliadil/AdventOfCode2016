defmodule Day09 do

    def task01 do
        file = File.read! "lib/day09.txt"
        
        file
        |> processString
        |> String.length
        |> IO.puts
    end

    defp processStringMultiple(string) do

        if String.contains?(string, "(") do
            wot = string
            |> processString
            wot
            |> String.length
            |> IO.inspect

            wot
            |> processStringMultiple
        else
            string
        end

    end

    defp processString(string) do
        {endString, _, _, times, toRepeat} = string
        |> String.graphemes
        |> Enum.reduce({"", :normal, "", "", ""}, fn(x, acc) -> handleCharacter(x, acc) end)
         if is_integer(times) do
            1..times
            |> Enum.reduce(endString, fn(_x, acc) -> acc <> toRepeat end )
        else
            endString
        end
    end

    defp handleCharacter("(", {endString, :normal, "", "", _}) do
        {endString, :num01, "", "", ""}
    end

    defp handleCharacter(c, {endString, :normal, "", "", _}) do
        {endString <> c, :normal, "", "", ""}
    end

    defp handleCharacter("x",{endString, :num01, num01, "", _}) do
        {endString, :num02, num01, "", ""}
    end

    defp handleCharacter(c,{endString, :num01, num01, "", _}) do
        {endString, :num01, num01 <> c, "", ""}
    end
    
    defp handleCharacter(")",{endString, :num02, num01, num02, _}) do
        {endString, :repeat, String.to_integer(num01), String.to_integer(num02), ""}
    end

    defp handleCharacter(c,{endString, :num02, num01, num02, _}) do
        {endString, :num02, num01, num02 <> c, ""}
    end



    defp handleCharacter(c,{endString, :repeat, 0, num02, toRepeat}) do
        newEnd = 1..num02
        |> Enum.reduce(endString, fn(_x, acc) -> acc <> toRepeat end )
        handleCharacter(c, {newEnd, :normal, "", "", ""})
    end

    defp handleCharacter(c,{endString, :repeat, num01, num02, toRepeat}) do
        {endString, :repeat, num01 - 1, num02, toRepeat <> c}
    end

    def task02 do
        file = File.read! "lib/day09.txt"
        
        inst = tokenizeString(file)

        doMagicMultiple(inst)
        |> Enum.map(fn(x) -> getLength(x) end )
        |> Enum.sum
        |> IO.inspect

        
    end

    defp doMagicMultiple(inst) do 
        result = doMagic(inst, [])
        if Enum.count(result, fn({a,b}) -> a != :c end) > 0 do
            IO.puts "woot"
            doMagicMultiple(result)
        else
            result
        end
    end

    defp tokenizeString(string) do 
        Regex.scan(~r/(?:\(\d+x\d+\))|(?:[A-Z]+)/, string)
        |> List.flatten
        |> Enum.map(fn(x) -> 
            if String.starts_with?(x, "(") do
                [_, a, b] = Regex.scan(~r/(\d+)x(\d+)/, x) |> List.first
                {String.to_integer(a), String.to_integer(b)}
            else
                {:c, String.length(x)}
            end
            end)
    end

    defp doMagic([], accList) do
        accList
    end 

    defp doMagic([x = {:c, _length} | rest ], accList) do
        #IO.puts "1"
        doMagic(rest, accList ++ [x])

    end

    defp doMagic([{length, times} | rest ], accList) do
        {newRest, toRepeat} = takeLength(length, rest, [])
        inner = doMagic(toRepeat, [])
        |> Enum.map(fn(x) -> getLength(x) end )
        |> Enum.sum
        doMagic(newRest, [{:c, times * inner}] ++ accList)       
    end

    defp takeLength(x, list, repeatList) when x < 0 do
        {[{:c, -x}] ++ list, repeatList}
    end

    defp takeLength(0, list, repeatList) do
        {list, repeatList}
    end
    
    defp takeLength(_, [], repeatList) do
        {[], repeatList}
    end

    defp takeLength(length, list, repeatList) do
        [h | t] = list
        elemLen = getLength(h)
        if(elemLen > length) do
            {a, _b} = h
            newRep = repeatList ++ [{:c, length}]
            takeLength(length - elemLen, t, newRep)
        else
            newRep = repeatList ++ [h]
            takeLength(length - elemLen, t, newRep)
        end
                
    end

    defp getLength({:c, b}) do
        b
    end 

    defp getLength({a, b}) do
        aL = a |> to_string |> String.length
        bL = b |> to_string |> String.length
        3 + aL + bL
    end 
end    