defmodule Day12 do

    def task01 do
        file = File.read! "lib/day12.txt"
        instructions = String.split(file, "\r\n")
        |> Enum.map(&tokenize/1)

        doIntstructions(instructions, 0, %{})
        |> IO.inspect
    end

    defp tokenize(string) do
        r = ~r/([a-z]+) (\d+|[a-z]) ?([a-z0-9\-]+)?/
        Regex.scan(r, string, capture: :all_but_first)
        |> List.first
        |> Enum.map(fn(x) -> if Regex.match?(~r/\d+/, x), do: String.to_integer(x), else: String.to_atom(x) end)
        |> List.to_tuple
        |> IO.inspect
    end

    defp doIntstructions(instructions, pos, state) do
        inst = Enum.at(instructions, pos)
        {newState, move} = doIt(inst, state)
        #IO.inspect pos
        if pos + move >= Enum.count(instructions) or pos + move < 0 do
            newState
        else
            doIntstructions(instructions, pos + move, newState)
        end
    end

    defp doIt({:cpy, what, to}, state) do 
        w = if is_integer(what) do
            what
        else 
            Map.get(state, what, 0)
        end

        {Map.put(state, to, w), 1}
    end

    defp doIt({:dec, what}, state) do
        {Map.update(state, what, 0, &(&1 - 1)), 1}
    end
    
    defp doIt({:inc, what}, state) do
        {Map.update(state, what, 0, &(&1 + 1)), 1}
    end
    
    defp doIt({:jnz, ifThis, that}, state) do
        v = if is_integer(ifThis) do
            ifThis
        else 
            Map.get(state, ifThis, 0)
        end
        jump = if v != 0, do: that, else: 1
        {state, jump}
    end
end