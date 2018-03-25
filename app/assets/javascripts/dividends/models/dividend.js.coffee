class Dividend extends PeatioModel.Model
  @configure 'Dividend', 'member_id', 'product_id', 'aasm_state', 'created_at', 'updated_at'

  @initData: (record) ->
    PeatioModel.Ajax.disable ->
      Dividend.create(record)

window.Dividend = Dividend
