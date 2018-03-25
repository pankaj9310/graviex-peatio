class Product extends PeatioModel.Model
  @configure 'Product', 'name', 'description', 'asset', 'interest', 'maturation', 'amount', 'rate', 'contract', 'created_at', 'updated_at'

  @initData: (record) ->
    PeatioModel.Ajax.disable ->
      Product.create(record)

window.Product = Product
