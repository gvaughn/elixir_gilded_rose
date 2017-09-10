defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  def update_quality(items) do
    Enum.map( items, &(update_item(&1) ) )
  end

  defp update_item(item) do
    item
    |> update_quality_before_aging
    |> age_item
    |> update_quality_after_aging
    |> enforce_quality_constraints
  end

  defp update_quality_before_aging( item = %Item{} ) do
    item = %{item | quality: item.quality + quality_modifier(item) }
  end

  defp quality_modifier( item = %Item{ name: "Sulfuras, Hand of Ragnaros" } ),                                                    do: 0
  defp quality_modifier( item = %Item{ name: "Aged Brie" } ),                                                                     do: 1
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in } ) when sell_in <  0, do: -item.quality
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in } ) when sell_in <  6, do: 3
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in } ) when sell_in < 11, do: 2
  defp quality_modifier( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert" } ),                                     do: 1
  defp quality_modifier( item = %Item{ name: "Conjured Mana Cake" } ),                                                            do: -2
  defp quality_modifier( item = %Item{} ),                                                                                        do: -1

  defp age_item( item = %Item{ name: "Sulfuras, Hand of Ragnaros" } ) do
    item
  end
  defp age_item( item = %Item{ sell_in: sell_in } ) do
    %{item | sell_in: item.sell_in - 1}
  end

  defp update_quality_after_aging( item = %Item{ sell_in: sell_in } ) when sell_in < 0 do
    %{item | quality: item.quality + quality_modifier(item) }
  end
  defp update_quality_after_aging( item = %Item{} ) do
    item
  end

  defp enforce_quality_constraints(item = %Item{ name: "Sulfuras, Hand of Ragnaros" } ), do: %{ item | quality: 80 }
  defp enforce_quality_constraints(item = %Item{ quality: quality } ) when quality > 50, do: %{ item | quality: 50 }
  defp enforce_quality_constraints(item = %Item{ quality: quality } ) when quality <  0, do: %{ item | quality: 0 }
  defp enforce_quality_constraints(item = %Item{} ),                                     do: item
end
