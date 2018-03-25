class Asset extends PeatioModel.Model
  @configure 'Asset', 'member_id', 'currency', 'balance', 'locked', 'created_at', 'updated_at', 'in', 'out', 'deposit_address', 'name_text', 'is_online', 'blocks', 'headers', 'blocktime', 'gio_discount', 'coin_home', 'coin_btt', 'coin_be'

  @initData: (record) ->
    PeatioModel.Ajax.disable ->
      Asset.create(record)

window.Asset = Asset
