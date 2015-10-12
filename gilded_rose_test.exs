defmodule NormalItemTest do
  use GildedRoseContext
  @moduletag item_name: "normal"

  test "before sell date", context, do: assert_quality_delta(context, -1)

  @tag sell_date: :on
  test "on sell date", context, do: assert_quality_delta(context, -2)

  @tag sell_date: :after
  test "after sell date", context, do: assert_quality_delta(context, -2)

  @tag quality: 0
  test "of zero quality", context, do: assert_quality_delta(context, 0)
end

defmodule AgedBrieTest do
  use GildedRoseContext
  @moduletag item_name: "Aged Brie"

  @tag sell_date: :before
  @tag quality: 50
  test "before sell date with max quality", context, do: assert context.item.quality == 50

  @tag sell_date: :on
  @tag quality: 10
  test "on sell date", context, do: assert_quality_delta(context, 2)

  @tag quality: 49
  test "on sell date near max quality", context, do: assert context.item.quality == 50

  @tag quality: 50
  test "on sell date with max quality", context, do: assert context.item.quality == 50

  @tag sell_date: :after
  @tag quality: 10
  test "after sell date", context, do: assert_quality_delta(context, 2)

  @tag quality: 50
  test "after sell date with max quality", context, do: assert context.item.quality == 50
end

defmodule SulfurasTest do
  use GildedRoseContext
  @moduletag item_name: "Sulfuras, Hand of Ragnaros"
  @moduletag sell_in_assertion: false

  def assert_unchanged_sell_in_and_quality(context) do
    assert context.item.sell_in == context.original_item.sell_in
    assert context.item.quality == context.original_item.quality
  end

  @tag sell_date: :before
  test "before sell date", context, do: assert_unchanged_sell_in_and_quality(context)

  @tag sell_date: :on
  test "on sell date", context, do: assert_unchanged_sell_in_and_quality(context)

  @tag sell_date: :after
  test "after sell date", context, do: assert_unchanged_sell_in_and_quality(context)
end

defmodule BackstagePassTest do
  use GildedRoseContext
  @moduletag item_name: "Backstage passes to a TAFKAL80ETC concert"

  @tag sell_date: 11
  @tag quality: 10
  test "long before sell date", context, do: assert_quality_delta(context, 1)

  @tag quality: 50
  test "long before sell date at max quality", context, do: assert_quality_delta(context, 0)

  @tag sell_date: 10
  @tag quality: 10
  test "medium close to sell date (upper bound)", context, do: assert_quality_delta(context, 2)

  @tag quality: 50
  test "medium close to sell date (upper bound) at max quality", context, do: assert_quality_delta(context, 0)

  @tag sell_date: 6
  @tag quality: 10
  test "medium close to sell date (lower bound)", context, do: assert_quality_delta(context, 2)

  @tag quality: 50
  test "medium close to sell date (lower bound) at max quality", context, do: assert_quality_delta(context, 0)

  @tag sell_date: 5
  @tag quality: 10
  test "very close to sell date (upper bound)", context, do: assert_quality_delta(context, 3)

  @tag quality: 50
  test "very close to sell date (upper bound) at max quality", context, do: assert_quality_delta(context, 0)

  @tag sell_date: 1
  @tag quality: 10
  test "very close to sell date (lower bound)", context, do: assert_quality_delta(context, 3)

  @tag quality: 50
  test "very close to sell date (lower bound) at max quality", context, do: assert_quality_delta(context, 0)

  @tag sell_date: :on
  test "on sell date", context, do: assert context.item.quality == 0

  @tag sell_date: :after
  test "after sell date", context, do: assert context.item.quality == 0
end

defmodule ConjuredItemTest do
  use GildedRoseContext
  @moduletag item_name: "Conjured Mana Cake"

  @tag sell_date: :before
  @tag quality: 10
  test "before sell date", context, do: assert_quality_delta(context, -2)

  @tag quality: 0
  test "before sell date at zero quality", context, do: assert context.item.quality == 0

  @tag sell_date: :on
  @tag quality: 10
  test "on sell date", context, do: assert_quality_delta(context, -4)

  @tag quality: 0
  test "on sell date at zero quality", context, do: assert context.item.quality == 0

  @tag sell_date: :after
  @tag quality: 10
  test "after sell date", context, do: assert_quality_delta(context, -4)

  @tag quality: 0
  test "after sell date at zero quality", context, do: assert context.item.quality == 0
end

defmodule MultipleItemTest do
  use ExUnit.Case

  test "with multiple items" do
    [normal, brie] = GildedRose.update_quality([
      %Item{name: "Normal Item", sell_in: 5, quality: 10},
      %Item{name: "Aged Brie",   sell_in: 3, quality: 10}
    ])

    assert normal.sell_in == 4
    assert normal.quality == 9

    assert brie.sell_in == 2
    assert brie.quality == 11
  end
end
