# elixir-fridge
Fridge implementation with Elixir

# Requirements
Create a GenServer that would act as a Fridge. It should hold the following functionalities:
    1. Open the fridge (this would put the fridge in the open state)
    2. Close the fridge (this would put the fridge in the close state)
    3. Put products in a fridge. You can only put one product in the fridge at a time. A product should have the following attributes: [:name, :count]. Putting more products of the same name, should just increase the counter of the product that is already in the fridge.
    4. Pull a product out of the fridge. This functionality should return the Product with count being one less than what it is in the fridge.
      Example> If you pull for "tomato" and you have 5 tomatoes in the fridge, the function should return %Product{name: "tomato", count: 4}.
      NB. Make sure you update the state of the fridge when pulling out a product. The fridge should be closed after each pull/put call


  Additional details:
    1. You cannot pull/put a fridge that is closed. You first have to open the fridge (like you would in real life :))
    2. You can pull only one item at a time.
    3. After either of the following actions pull/put the fridge should end in a closed state. Basically you cannot pull a product 2 times in a row. You would have to do:
       - open fridge
       - pull item
       - open fridge
       - pull item
       ...
    3. You cannot have a product with a count equal to 0 in the fridge. If the count of a product goes to 0 when pulling it out of the fridge, it should be removed from the fridge.



# Example usage
```
iex(1)> {:ok, pid} = Fridge.start_link()
{:ok, #PID<0.114.0>}
iex(2)> Fridge.view(pid)
%{isOpened: false}
iex(3)> Fridge.open(pid)
%{isOpened: true}
iex(4)> Fridge.put(pid, %{name: "Eggs", count: 2}) 
:ok
iex(5)> Fridge.view(pid)
%{:isOpened => false, "Eggs" => 2}
iex(6)> Fridge.open(pid)
%{:isOpened => true, "Eggs" => 2}
iex(7)> Fridge.pull(pid, "Eggs")
%{count: 1, name: "Eggs"}
iex(8)> Fridge.view(pid)
%{:isOpened => false, "Eggs" => 1}
```