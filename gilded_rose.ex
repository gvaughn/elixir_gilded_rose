defmodule Item do
  defstruct [
    name: nil,
    sell_in: nil,
    quality: nil,
  ]
end

defmodule GildedRose do

  @moduledoc """
  Solution for Gilded Rose Kata.

  By eksperimental
  https://github.com/eksperimental/elixir_gilded_rose/blob/master/gilded_rose.ex
  """

  @aged_brie "Aged Brie"
  @backstage_passes "Backstage passes to a TAFKAL80ETC concert"
  @sulfuras "Sulfuras, Hand of Ragnaros"

  @doc """
  Updates quality of products

  It accepts a list of multiple items, and it will update :quality
  and :sell_in.

  It should be run once, it the end of each day.
  """
  @spec update_quality([%Item{}]) :: [%Item{}]
  def update_quality(items) when is_list(items) do
    for %Item{name: name, sell_in: sell_in, quality: quality} <- items do
      update_item(name, sell_in, quality)
    end
  end

  @spec update_item(String.t, integer, non_neg_integer) :: %Item{}
  defp update_item(name, sell_in, quality)
    when is_bitstring(name) and is_integer(sell_in)
    and is_integer(quality) and quality >= 0 do
    %Item{
      name: name,
      sell_in: do_sell_in(name, sell_in),
      quality: do_quality(name, sell_in, quality)
    }
  end

  @spec do_quality(String.t, integer, non_neg_integer) :: non_neg_integer
  defp do_quality(@sulfuras, _sell_in, _quality) do
    80
  end

  # items that increase value closer to expiriration date
  defp do_quality(@backstage_passes, sell_in, _quality) when sell_in <= 0,
    do: 0 |> quality_limit
  defp do_quality(@backstage_passes, sell_in, quality)  when sell_in <= 5,
    do: quality + 3 |> quality_limit
  defp do_quality(@backstage_passes, sell_in, quality)  when sell_in <= 10,
    do: quality + 2 |> quality_limit
  defp do_quality(@backstage_passes, _sell_in, quality),
    do: quality + 1 |> quality_limit

  # NOTE: it is never stated that the value increases double passed
  # the expiriation date
  defp do_quality(name = @aged_brie, sell_in, quality) do
    quality + ( 1 |> expired_factor(sell_in) |> conjured_factor(name) )
    |> quality_limit
  end

  # decrease quality
  defp do_quality(name, sell_in, quality) do
    quality - ( 1 |> expired_factor(sell_in) |> conjured_factor(name) )
    |> quality_limit
  end

  @spec quality_limit(integer) :: non_neg_integer
  defp quality_limit(quality) do
    quality
    |> max(0)
    |> min(50)
  end

  @spec do_sell_in(String.t, integer) :: integer
  defp do_sell_in(@sulfuras, sell_in),
    do: sell_in
  defp do_sell_in(_name, sell_in),
    do: sell_in - 1

  @spec conjured_factor(integer, String.t) :: integer
  defp conjured_factor(value, name) do
    if conjured?(name), do: value * 2, else: value
  end

  @spec conjured?(String.t) :: boolean
  defp conjured?(name) do
    name
    |> String.downcase
    |> String.starts_with?("conjured")
  end

  @spec expired_factor(integer, integer) :: integer
  defp expired_factor(value, sell_in) when sell_in <= 0,
    do: value * 2
  defp expired_factor(value, _sell_in),
    do: value

end
