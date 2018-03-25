class Interest extends PeatioModel.Model
  @configure 'Interest', 'member_id', 'currency', 'balance', 'locked', 'created_at', 'updated_at', 'in', 'out', 'deposit_address', 'name_text', 'is_online', 'blocks', 'headers', 'blocktime', 'gio_discount', 'coin_home', 'coin_btt', 'coin_be'

  @initData: (record) ->
    PeatioModel.Ajax.disable ->
      Interest.create(record)

window.Interest = Interest
