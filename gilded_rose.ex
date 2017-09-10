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

  def update_item( item = %Item{ name: "Sulfuras, Hand of Ragnaros" } ) do
    item
  end

  def update_item( item = %Item{ name: "Aged Brie" } ) do
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
    item = %{item | sell_in: item.sell_in - 1}
    if item.sell_in < 0 do
      if item.quality < 50 do
        item = %{item | quality: item.quality + 1}
      end
    end
    item
  end

  def update_item( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert" } ) do
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
    item = %{item | sell_in: item.sell_in - 1}
    if item.sell_in < 0 do
      item = %{item | quality: item.quality - item.quality}
    end
    item
  end

  def update_item(item) do
    if item.quality > 0 do
      item = %{item | quality: item.quality - 1}
    end
    item = %{item | sell_in: item.sell_in - 1}
    if item.sell_in < 0 do
      if item.quality > 0 do
        item = %{item | quality: item.quality - 1}
      end
    end
    item
  end
end
