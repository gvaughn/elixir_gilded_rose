# I couldn't stop at my first solution, so I refactored into this
# data driven approach, which I think I like better. My only complaint
# is that I had to make things public to use with `apply`.
# Let me know what you think.
defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  @max_quality 50
  @min_quality 0
  @incrementers %{
    default:   {[:next_sell_in],      [:next_quality, -1]},
    brie:      {[:next_sell_in],      [:next_quality, 1]},
    sulfuras:  {[:unchanged_sell_in], [:unchanged_quality]},
    backstage: {[:next_sell_in],      [:next_backstage_quality]},
    conjured:  {[:next_sell_in],      [:next_quality, -2]},
  }

  def update_quality(items) when is_list(items) do
    Enum.map(items, &update_quality/1)
  end

   def update_quality(%Item{} = item) do
     key = case item.name do
       "Aged Brie" -> :brie
       "Sulfuras, Hand of Ragnaros" -> :sulfuras
       "Backstage passes to a TAFKAL80ETC concert" -> :backstage
       "Conjured" <> _ -> :conjured
       _ -> :default
     end

     {[sell_in_incrementer | si_params], [quality_incrementer | q_params]} = Map.get(@incrementers, key)

     %{item |
       sell_in: apply(__MODULE__, sell_in_incrementer, [item | si_params]),
       quality: apply(__MODULE__, quality_incrementer, [item | q_params])
     }
   end

  def next_sell_in(%Item{sell_in: si}), do: si - 1

  def next_quality(%Item{sell_in: si, quality: q}, delta) do
    (quality_age_factor(si) * delta + q) |> bound_quality
  end

  def unchanged_quality(%Item{quality: q}), do: q

  def unchanged_sell_in(%Item{sell_in: si}), do: si

  def next_backstage_quality(%Item{sell_in: si, quality: q}) do
    case si do
      s when s <= 0  -> 0
      s when s <= 5  -> bound_quality(q + 3)
      s when s <= 10 -> bound_quality(q + 2)
      _              -> bound_quality(q + 1)
    end
  end

  defp bound_quality(q), do: q |> min(@max_quality) |> max(@min_quality)

  defp quality_age_factor(sell_in) when sell_in <= 0, do: 2
  defp quality_age_factor(_sell_in),                  do: 1
end

