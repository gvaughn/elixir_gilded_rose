defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  # DO NOT WRITE ELIXIR LIKE THIS. PLEASE!
  # This is as direct a port of the C# code as I could achieve.
  # I experienced actual physical pain in doing so.
  # You can find the original code in the reference directory.
  # Your job is to now make it beautiful.

  def update_quality(items) do
    Enum.map(items, fn(item) ->
      case item.name do
        "Aged Brie" -> update_aged_brie(item)
        "Sulfuras, Hand of Ragnaros" -> update_sulfuras(item)
        "Backstage passes to a TAFKAL80ETC concert" -> update_backstage_passes(item)
        "Conjured Mana Cake" -> update_conjured_item(item)
        _ -> update_normal_item(item)
      end
    end)
  end

  defp update_normal_item(item) do
    item
    |> Map.update!(:quality, fn(q) ->
      cond do
        item.sell_in <= 0 -> q - 2
        true -> q - 1
      end
    end)
    |> Map.update!(:quality, &(Enum.max([&1, 0])))
    |> Map.update!(:sell_in, &(&1 - 1))
  end

  defp update_aged_brie(item) do
    item
    |> Map.update!(:quality, fn(q) ->
      cond do
        item.sell_in <= 0 -> q + 2
        true -> q + 1
      end
    end)
    |> Map.update!(:quality, &(Enum.min([&1, 50])))
    |> Map.update!(:sell_in, &(&1 - 1))
  end

  defp update_sulfuras(item) do
    item
  end

  defp update_backstage_passes(item) do
    item
    |> Map.update!(:quality, fn(q) ->
      cond do
        item.sell_in <= 0 -> 0
        item.sell_in <= 5 -> q + 3
        item.sell_in <= 10 -> q + 2
        true -> q + 1
      end
    end)
    |> Map.update!(:quality, &(Enum.min([&1, 50])))
    |> Map.update!(:sell_in, &(&1 - 1))
  end

  defp update_conjured_item(item) do
    item
    |> Map.update!(:quality, fn(q) ->
      cond do
        item.sell_in <= 0 -> q - 4
        true -> q - 2
      end
    end)
    |> Map.update!(:quality, &(Enum.max([&1, 0])))
    |> Map.update!(:sell_in, &(&1 - 1))
  end
end
