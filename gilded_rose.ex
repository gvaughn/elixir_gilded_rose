defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  # DO NOT WRITE ELIXIR LIKE THIS. PLEASE!
  # This is as direct a port of the C# code as I could achieve.
  # I experienced actual physical pain in doing so.
  # You can find the original code in the reference directory.
  # Your job is to now make it beautiful.

  def update_quality(items) do
    Enum.map( items, &(update_item(&1) ) )
  end

  defp update_item( item = %Item{ name: "Sulfuras, Hand of Ragnaros" } ) do
    item
  end

  defp update_item( item = %Item{ name: "Aged Brie" } ) do
    item = %{item | quality: item.quality + quality_modifier(item) }
    item = age_item(item)
    if item.sell_in < 0, do: item = %{item | quality: item.quality + 1}

    item
    |> enforce_quality_constraints
  end
  defp quality_modifier( item = %Item{ name: "Aged Brie", sell_in: sell_in } ) when sell_in < 0, do: 1
  defp quality_modifier( item = %Item{ name: "Aged Brie" } ),                                    do: 1

  defp update_item( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert" } ) do
    item = %{item | quality: item.quality + quality_modifier(item) }
    item = age_item(item)
    if item.sell_in < 0, do: item = %{item | quality: item.quality - item.quality}

    item
    |> enforce_quality_constraints
  end
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in } ) when sell_in <  6, do: 3
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in } ) when sell_in < 11, do: 2
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert" } ),                                     do: 1

  defp update_item(item) do
    item = %{item | quality: item.quality + quality_modifier(item) }
    item = age_item(item)
    if item.sell_in < 0, do: item = %{item | quality: item.quality - 1}

    item
    |> enforce_quality_constraints
  end
  defp quality_modifier( item = %Item{} ), do: -1

  defp age_item( item = %Item{ sell_in: sell_in } ) do
    %{item | sell_in: item.sell_in - 1}
  end

  defp enforce_quality_constraints(item = %Item{ quality: quality } ) when quality > 50, do: %{ item | quality: 50 }
  defp enforce_quality_constraints(item = %Item{ quality: quality } ) when quality <  0, do: %{ item | quality: 0 }
  defp enforce_quality_constraints(item = %Item{} ),                                     do: item
end
