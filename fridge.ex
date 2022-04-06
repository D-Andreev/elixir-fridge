defmodule Fridge do
  use GenServer

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{isOpened: false})
  end

  def open(pid) do
    GenServer.call(pid, :open)
  end

  def close(pid) do
    GenServer.call(pid, :close)
  end

  def put(pid, item) do
    GenServer.cast(pid, item);
  end

  def pull(pid, name) do
    GenServer.call(pid, {:pull, name});
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal, :infininty)
  end

  # Server API

  # Put a product in the fridge
  def handle_cast(item, state) do
    if !state.isOpened do
      IO.puts("Fridge is closed")
      {:noreply, state}
    else
      updated_map = Map.update(state, item[:name], item[:count], &(&1 + item[:count]))
      updated_map = %{ updated_map | :isOpened => false}
      {:noreply, updated_map}
    end
  end

  # Pull a product from the fridge
  def handle_call({:pull, name}, _from, state) do
    if !state.isOpened do
      IO.puts("Fridge is closed")
      {:reply, state, state}
   else
      count = state[name]
      updated_map = %{ state | name => count - 1}
      updated_map = %{ updated_map | :isOpened => false}
      if (updated_map[name] == 0) do
        updated_map = Map.delete(updated_map, name)
        {:reply, %{name: name, count: 0}, updated_map}
      else
        {:reply, %{name: name, count: count - 1}, updated_map}
      end
   end
  end

  # Open the fridge
  def handle_call(:open, _from, state) do
    updated_map = Map.put(state, :isOpened, true)
    {:reply, updated_map, updated_map}
  end

  # Close the fridge
  def handle_call(:close, _from, state) do
    updated_map = Map.put(state, :isOpened, false)
    {:reply, updated_map, updated_map}
  end

  # View the contents of the fridge
  def handle_call(:view, _from, state) do
    {:reply, state, state}
  end

  # Init process
  def init(state) do
    {:ok, state}
  end

  # Stpo the process
  def terminate(_reason, state) do
    {:ok, state}
  end
end
