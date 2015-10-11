ExUnit.start()

defmodule ModuleContext do
  use ExUnit.Case

  defmacro __using__(module_ctx) do
    quote do
      use ExUnit.Case
      import ModuleContext

      setup test_ctx do
        merged_context = %{} |> Dict.merge(unquote(module_ctx)) |> Dict.merge(test_ctx)
        master_setup(merged_context)
      end
    end
  end

  def master_setup(context) do
    sell_in_assertion = Map.get(context, :sell_in_assertion, true)

    sell_in = case context[:sell_date] do
      x when is_integer(x) -> x
      :on                  -> 0
      :after               -> -10
      _                    -> 5
    end
    quality = context[:quality] || 10
    original_item = %Item{name: context[:item_name], sell_in: sell_in, quality: quality}
    updated_item = GildedRose.update_quality(original_item)
    if sell_in_assertion, do: assert updated_item.sell_in - original_item.sell_in == -1
    {:ok, %{item: updated_item, original_item: original_item}}
  end

  def assert_quality_delta(%{item: item, original_item: original_item}, delta) do
    assert delta == (item.quality - original_item.quality)
  end
end
