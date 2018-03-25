class Member extends PeatioModel.Model
  @configure 'Member', 'sn', 'display_name', 'created_at', 'updated_at', 'state',
    'country_code', 'phone_number', 'name', 'app_activated', 'sms_activated', 'has_gio_deposite_50', 'two_fa_require_signin'

  @initData: (records) ->
    PeatioModel.Ajax.disable ->
      $.each records, (idx, record) ->
        Member.create(record)

window.Member = Member
