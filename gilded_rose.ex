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
        _ ->
          if item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert" do
            if item.quality > 0 do
              if item.name != "Sulfuras, Hand of Ragnaros" do
                item = %{item | quality: item.quality - 1}
              end
            end
          else
            if item.quality < 50 do
              item = %{item | quality: item.quality + 1}
              if item.name == "Backstage passes to a TAFKAL80ETC concert" do
                if item.sell_in < 11 do
                  if item.quality < 50 do
                    item = %{item | quality: item.quality + 1}
                  end
                end
                if item.sell_in < 6 do
                  if item.quality < 50 do
                    item = %{item | quality: item.quality + 1}
                  end
                end
              end
            end
          end
          if item.name != "Sulfuras, Hand of Ragnaros" do
            item = %{item | sell_in: item.sell_in - 1}
          end
          if item.sell_in < 0 do
            if item.name != "Aged Brie" do
              if item.name != "Backstage passes to a TAFKAL80ETC concert" do
                if item.quality > 0 do
                  if item.name != "Sulfuras, Hand of Ragnaros" do
                    item = %{item | quality: item.quality - 1}
                  end
                end
              else
                item = %{item | quality: item.quality - item.quality}
              end
            else
              if item.quality < 50 do
                item = %{item | quality: item.quality + 1}
              end
            end
          end
          item
      end
    end)
  end
end
