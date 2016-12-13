defmodule Day07 do

    def task01 do
        file = File.read! "lib/day07.txt"
        
        String.split(file, "\r\n")
        |> Enum.map(&(findCandidates(&1)))
        |> Enum.filter(fn(result) -> result end )
        |> Enum.count
        
        |> IO.puts
    end

    def task02 do
        file = File.read! "lib/day07.txt"
        
        String.split(file, "\r\n")
        |> Enum.map(&(splitToTwo(&1)))
        |> Enum.map(fn({o, i}) -> {findABA(o), findABA(i)} end)
        |> Enum.map(fn({oABA, iABA}) -> 
            woot = Enum.map(oABA, fn([a,b,_]) -> [b,a,b] end)
            list3 = woot -- iABA
            final_list = woot -- list3
            IO.inspect final_list
            Enum.count(final_list) > 0
            
         end)
        |> Enum.filter(&(&1))
        |> Enum.count
        |> IO.inspect
    end

    defp splitToTwo(string) do
        r = ~r/\[[a-z]+\]/
        inside = Regex.scan(r, string)
        |> List.flatten
        |> Enum.reduce(&(&2 <> &1))
        outside = String.replace(string, r, "=")
        {outside, inside}
    end

    defp findABA(string) do
        {allFound, _} = string
        |> String.graphemes
        |> Enum.reduce({[], []}, 
            fn(x, {allFound, list}) -> 
                newList = if (Enum.count(list) == 3) do
                    [_h | t] = list
                    t ++ [x]
                else
                    list ++ [x]
                end
                if isABA(newList) do 
                    {allFound ++ [newList], newList}
                else
                    {allFound, newList}
                end 
            end)
        allFound
    end

    defp findCandidates(ip) do
        r = ~r/\[[a-z]+\]/
        inside = Regex.scan(r, ip)
        |> List.flatten
        |> Enum.reduce(&(&2 <> &1))
        
        outside = String.replace(ip, r, "=")
        hasAbba(outside) && !hasAbba(inside)
    end

    defp hasAbba(string) do
        {woot, _ } = string
        |> String.graphemes
        |> Enum.reduce_while({false, []}, 
            fn(x, {_found, list}) -> 
                newList = if (Enum.count(list) == 4) do
                    [_h | t] = list
                    t ++ [x]
                else
                    list ++ [x]
                end
                if isAbba(newList) do 
                    IO.inspect newList
                    {:halt, {true, newList}}
                else
                    {:cont, {false, newList}}
                end 
            end)
        woot
    end
    defp isABA([a,b,c]), do: a == c && a =~ ~r/[a-z]/ && b =~ ~r/[a-z]/ && c =~ ~r/[a-z]/
    defp isABA(_), do: false
    defp isAbba([a,b,c,d]), do: a == d and b == c and b != a and a != "=" and b != "=" and a != "]" and b != "]" and a != "=" and b != "="
    
    defp isAbba(_), do: false
end    