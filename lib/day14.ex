defmodule Day14 do

    def task01 do
        input = File.read! "lib/day14.txt"
        
        fives = Stream.iterate(0, &(&1 + 1))
        |> Stream.map(fn(x) -> {x, input <> Integer.to_string(x)} end)
        |> Stream.map(fn({id, phrase}) -> {id, getMD5(phrase, 1)} end)
        |> Stream.map(fn({id, md5}) -> {id, getAllFives(md5)} end)
        |> Stream.filter(fn({_id, fives}) -> fives != [] end)
        |> Stream.map(fn({id, x}) -> {id, List.first(x)} end)
        |> Enum.take(64)
        #|> Enum.each(fn(x) -> IO.inspect(x) end)

        Stream.iterate(0, &(&1 + 1))
        |> Stream.map(fn(x) -> {x, input <> Integer.to_string(x)} end)
        |> Stream.map(fn({id, phrase}) -> {id, getMD5(phrase, 1)} end)
        |> Stream.map(fn({id, md5}) -> {id, getFirstTriple(md5)} end)
        |> Stream.filter(fn({_id, x}) -> x != nil end)
        |> Stream.filter(fn({id, x}) -> 
                rr = Enum.filter(fives, fn({idF, xF}) -> idF > id and idF <= id + 1000 and x == xF end)
                #IO.inspect(rr)

                Enum.count(rr) != 0

            end)
        |> Enum.take(64)
        |> Enum.each(fn(x) -> IO.inspect(x) end)
    end


    defp getMD5(input, 0) do
        input
    end

    defp getMD5(input, times) do
        :crypto.hash(:md5, String.to_charlist(input))
        |> Base.encode16(case: :lower)
        |> getMD5(times - 1)
    end

    

    defp parseMD5(input) do
        {getFirstTriple(input), getAllFives(input)}
    end

    defp getFirstTriple(input) do
        v = Regex.run(~r/(.)\1{2}/, input, capture: :first)
        if v != nil, do: String.at(List.first(v), 0)
    end

    defp getAllFives(input) do
        v = Regex.scan(~r/(.)\1{4}/, input, capture: :all_but_first)
        if v != [], do: List.flatten(v), else: []
    end


    def task02 do
        
        input = File.read! "lib/day14.txt"
        k  =  find64th(input, 1, [], [])
        k
        |> Enum.sort_by(fn({k,v}) -> k end)
        #|> Enum.each(fn(x) -> IO.inspect(x) end)
        |> Enum.at(63)
        |> IO.inspect
    end

    def find64th(input, at, state, found) do
        if shouldEnd(at,found)  do
            found
        else
            md5 = getMD5(input <> to_string(at), 2017)
            triple = getFirstTriple(md5)
            if triple == nil do
                find64th(input, at + 1, state, found)    
            else
                newState = state ++ [{at, triple}]
                justFound = getAllFives(md5)
                |> Enum.reduce([], fn(x, acc) -> 
                    all = acc ++ Enum.filter(state, fn({k, v}) -> k > at - 1000 && v == x end)
                    Enum.uniq(all)
                end)
                
                find64th(input, at + 1, newState -- justFound, Enum.sort_by(found ++ justFound, fn({k,v}) -> -k end))  
            end
        end
    end

    def shouldEnd(at, found) do
        a = Enum.sort_by(found, fn({k,v}) -> k end)
        |> Enum.at(63)
            
        if a != nil  do
            {k64, v64} = a
            if(at - 1500 > k64) do
                true
            else
                false
            end 
        else
            false
        end        
    end
end