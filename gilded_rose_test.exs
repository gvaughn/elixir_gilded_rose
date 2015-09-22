# These tests follow Jim Weirich's test cases in Ruby. His original is
# available in the reference directory.
defmodule GildedRoseTest do
  use ExUnit.Case
  import GildedRose

  @spec age(String.t, integer, non_neg_integer) :: %Item{}
  def age(name, sell_in, quality) do
    [item] = update_quality([%Item{name: name, sell_in: sell_in, quality: quality}])
    assert item.sell_in == sell_in - 1
    item
  end

  test "normal item before sell date" do
    item = age("normal", 5, 10)
    assert item.quality == 9
  end

  test "normal item on sell date" do
    item = age("normal", 0, 10)
    assert item.quality == 8
  end

  test "normal item after sell date" do
    item = age("normal", -10, 10)
    assert item.quality == 8
  end

  test "normal item of zero quality" do
    item = age("normal", 5, 0)
    assert item.quality == 0
  end

  test "aged brie before sell date with max quality" do
    item = age("Aged Brie", 5, 50)
    assert item.quality == 50
  end

  test "aged brie on sell date" do
    item = age("Aged Brie", 0, 10)
    assert item.quality == 12
  end

  test "aged brie on sell date near max quality" do
    item = age("Aged Brie", 0, 49)
    assert item.quality == 50
  end

  test "aged brie on sell date with max quality" do
    item = age("Aged Brie", 0, 50)
    assert item.quality == 50
  end

  test "aged brie after sell date" do
    item = age("Aged Brie", -10, 10)
    assert item.quality == 12
  end

  test "aged brie after sell date with max quality" do
    item = age("Aged Brie", -10, 50)
    assert item.quality == 50
  end

  test "Sulfuras before sell date" do
    [item] = update_quality([%Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 5, quality: 80}])
    assert item.sell_in == 5
    assert item.quality == 80
  end

  test "Sulfuras on sell date" do
    [item] = update_quality([%Item{name: "Sulfuras, Hand of Ragnaros", sell_in: 0, quality: 80}])
    assert item.sell_in == 0
    assert item.quality == 80
  end

  test "Sulfuras after sell date" do
    [item] = update_quality([%Item{name: "Sulfuras, Hand of Ragnaros", sell_in: -10, quality: 80}])
    assert item.sell_in == -10
    assert item.quality == 80
  end

  test "Backstage pass long before sell date" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 11, 10)
    assert item.quality == 11
  end

  test "Backstage pass long before sell date at max quality" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 11, 50)
    assert item.quality == 50
  end

  test "Backstage pass medium close to sell date (upper boun)" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 10, 10)
    assert item.quality == 12
  end

  test "Backstage pass medium close to sell date (upper bound) at max quality" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 10, 50)
    assert item.quality == 50
  end

  test "Backstage pass medium close to sell date (lower bound)" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 6, 10)
    assert item.quality == 12
  end

  test "Backstage pass medium close to sell date (lower bound) at max quality" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 6, 50)
    assert item.quality == 50
  end

  test "Backstage pass very close to sell date (upper bound)" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 5, 10)
    assert item.quality == 13
  end

  test "Backstage pass very close to sell date (upper bound) at max quality" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 5, 50)
    assert item.quality == 50
  end

  test "Backstage pass very close to sell date (lower bound)" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 1, 10)
    assert item.quality == 13
  end

  test "Backstage pass very close to sell date (lower bound) at max quality" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 1, 50)
    assert item.quality == 50
  end

  test "Backstage pass on sell date" do
    item = age("Backstage passes to a TAFKAL80ETC concert", 0, 10)
    assert item.quality == 0
  end

  test "Backstage pass after sell date" do
    item = age("Backstage passes to a TAFKAL80ETC concert", -10, 10)
    assert item.quality == 0
  end

  test "conjured item before sell date" do
    item = age("Conjured Mana Cake", 5, 10)
    assert item.quality == 8
  end

  test "conjured item before sell date at zero quality" do
    item = age("Conjured Mana Cake", 5, 0)
    assert item.quality == 0
  end

  test "conjured item on sell date" do
    item = age("Conjured Mana Cake", 0, 10)
    assert item.quality == 6
  end

  test "conjured item on sell date at zero quality" do
    item = age("Conjured Mana Cake", 0, 0)
    assert item.quality == 0
  end

  test "conjured item after sell date" do
    item = age("Conjured Mana Cake", -10, 10)
    assert item.quality == 6
  end

  test "conjured item after sell date at zero quality" do
    item = age("Conjured Mana Cake", -10, 0)
    assert item.quality == 0
  end

  test "with multiple items" do
    [normal, brie] = update_quality([
      %Item{name: "Normal Item", sell_in: 5, quality: 10},
      %Item{name: "Aged Brie",   sell_in: 3, quality: 10}
    ])

    assert normal.sell_in == 4
    assert normal.quality == 9

    assert brie.sell_in == 2
    assert brie.quality == 11
  end
end

