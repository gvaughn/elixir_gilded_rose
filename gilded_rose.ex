# No `if` statements! \o/
defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  @max_quality 50
  @min_quality 0

  def update_quality(items) when is_list(items) do
    Enum.map(items, &update_quality/1)
  end

  def update_quality(%Item{} = item) do
    update_item(item, incrementers_for(item))
  end

  defp incrementers_for(%Item{name: "Aged Brie"}) do
    {&next_sell_in/1, &next_quality(1, &1)}
  end

  defp incrementers_for(%Item{name: "Sulfuras, Hand of Ragnaros"}) do
    {&unchanged_sell_in/1, &unchanged_quality/1}
  end

  defp incrementers_for(%Item{name: "Backstage passes to a TAFKAL80ETC concert"}) do
    {&next_sell_in/1, &next_backstage_quality/1}
  end

  defp incrementers_for(%Item{name: "Conjured" <> _}) do
    {&next_sell_in/1, &next_quality(-2, &1)}
  end

  defp incrementers_for(%Item{}) do
    {&next_sell_in/1, &next_quality(-1, &1)}
  end

  defp update_item(item, {sell_in_incrementer, quality_incrementer}) do
    %{item | sell_in: sell_in_incrementer.(item), quality: quality_incrementer.(item)}
  end

  defp next_sell_in(%Item{sell_in: si}), do: si - 1

  defp next_quality(delta, %Item{sell_in: si, quality: q}) do
    (quality_age_factor(si) * delta + q) |> bound_quality
  end

  defp bound_quality(q), do: q |> min(@max_quality) |> max(@min_quality)

  defp quality_age_factor(sell_in) when sell_in <= 0, do: 2
  defp quality_age_factor(_sell_in),                  do: 1

  defp unchanged_quality(%Item{quality: q}), do: q

  defp unchanged_sell_in(%Item{sell_in: si}), do: si

  defp next_backstage_quality(%Item{sell_in: si, quality: q}) do
    # note: I had this as guard clauses in 4 function heads originally,
    # but it felt noisier than this
    case si do
      s when s <= 0  -> 0
      s when s <= 5  -> bound_quality(q + 3)
      s when s <= 10 -> bound_quality(q + 2)
      _              -> bound_quality(q + 1)
    end
  end
end

