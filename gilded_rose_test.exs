defmodule NormalItemTest do
  use ModuleContext, item_name: "normal"

  test "before sell date", context, do: assert_quality_delta(context, -1)

  @tag sell_date: :on
  test "on sell date", context, do: assert_quality_delta(context, -2)

  @tag sell_date: :after
  test "after sell date", context, do: assert_quality_delta(context, -2)

  @tag quality: 0
  test "of zero quality", context, do: assert_quality_delta(context, 0)
end

defmodule AgedBrieTest do
  use ModuleContext, item_name: "Aged Brie"

  @tag quality: 50
  test "before sell date with max quality", context, do: assert context.item.quality == 50

  defmodule AgedBrieTest.OnSellDate do
    use ModuleContext, item_name: "Aged Brie", sell_date: :on

    test "on sell date", context, do: assert_quality_delta(context, 2)

    @tag quality: 49
    test "near max quality", context, do: assert context.item.quality == 50

    @tag quality: 50
    test "with max quality", context, do: assert context.item.quality == 50
  end

  defmodule AgedBrieTest.AfterSellDate do
    use ModuleContext, item_name: "Aged Brie", sell_date: :after

    test "after sell date", context, do: assert_quality_delta(context, 2)

    @tag quality: 50
    test "with max quality", context, do: assert context.item.quality == 50
  end
end

defmodule SulfurasTest do
  use ModuleContext, item_name: "Sulfuras, Hand of Ragnaros", sell_in_assertion: false

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
  use ModuleContext, item_name: "Backstage passes to a TAFKAL80ETC concert"

  defmodule BackstagePassTest.LongBeforeSellDate do
    use ModuleContext, item_name: "Backstage passes to a TAFKAL80ETC concert", sell_date: 11

    test "long before sell date", context, do: assert_quality_delta(context, 1)

    @tag quality: 50
    test "at max quality", context, do: assert_quality_delta(context, 0)
  end

  defmodule BackstagePassTest.MediumCloseUpperBound do
    use ModuleContext, item_name: "Backstage passes to a TAFKAL80ETC concert", sell_date: 10

    test "medium close to sell date (upper bound)", context, do: assert_quality_delta(context, 2)

    @tag quality: 50
    test "at max quality", context, do: assert_quality_delta(context, 0)
  end

  defmodule BackstagePassTest.MediumCloseLowerBound do
    use ModuleContext, item_name: "Backstage passes to a TAFKAL80ETC concert", sell_date: 6

    test "medium close to sell date (lower bound)", context, do: assert_quality_delta(context, 2)

    @tag quality: 50
    test "at max quality", context, do: assert_quality_delta(context, 0)
  end

  defmodule BackstagePassTest.VeryCloseUpperBound do
    use ModuleContext, item_name: "Backstage passes to a TAFKAL80ETC concert", sell_date: 5

    test "very close to sell date (upper bound)", context, do: assert_quality_delta(context, 3)

    @tag quality: 50
    test "at max quality", context, do: assert_quality_delta(context, 0)
  end

  defmodule BackstagePassTest.VeryCloseLowerBound do
    use ModuleContext, item_name: "Backstage passes to a TAFKAL80ETC concert", sell_date: 1

    test "very close to sell date (lower bound)", context, do: assert_quality_delta(context, 3)

    @tag quality: 50
    test "at max quality", context, do: assert_quality_delta(context, 0)
  end

  @tag sell_date: :on
  test "on sell date", context, do: assert context.item.quality == 0

  @tag sell_date: :after
  test "after sell date", context, do: assert context.item.quality == 0
end

defmodule ConjuredItemTest do

  defmodule ConjuredItemTest.BeforeSellDate do
    use ModuleContext, item_name: "Conjured Mana Cake", sell_date: :before

    test "before sell date", context, do: assert_quality_delta(context, -2)

    @tag quality: 0
    test "at zero quality", context, do: assert context.item.quality == 0
  end

  defmodule ConjuredItemTest.OnSellDate do
    use ModuleContext, item_name: "Conjured Mana Cake", sell_date: :on

    test "on sell date", context, do: assert_quality_delta(context, -4)

    @tag quality: 0
    test "at zero quality", context, do: assert context.item.quality == 0
  end

  defmodule ConjuredItemTest.AfterSellDate do
    use ModuleContext, item_name: "Conjured Mana Cake", sell_date: :after

    test "after sell date", context, do: assert_quality_delta(context, -4)

    @tag quality: 0
    test "at zero quality", context, do: assert context.item.quality == 0
  end
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
