module Admin
  class DashboardController < BaseController
    skip_load_and_authorize_resource

    def aggregate(currency, datefrom, dateto)
      sql = "select sum(fee*500.0) as result from account_versions where currency = #{currency} and reason = 110 and created_at >= '#{datefrom}' and created_at <= '#{dateto}' group by currency, reason"
      res = ActiveRecord::Base.connection.exec_query(sql).first
      amount = 0.0
      if res != nil
        amount = res['result'].to_f
      end
      return amount
    end

    def aggregate_sessions(datefrom, dateto)
      sql = "select count(*) as result from (select count(*) from signup_histories where created_at >= '#{datefrom}' and created_at <= '#{dateto}' group by member_id) as t";
      res = ActiveRecord::Base.connection.exec_query(sql).first
      amount = 0
      if res != nil
        amount = res['result'].to_i
      end
      return amount
    end

    def index
      @daemon_statuses = Global.daemon_statuses
      @currencies_summary = Currency.all.map(&:summary)
      @register_count = Member.count
      @turnover = []
      @sessions = []
      date = DateTime.now
      for i in 1..7
        datefrom = date.strftime("%Y-%m-%d 00:00:00")
        dateto = date.strftime("%Y-%m-%d 23:59:59")

        btc  = aggregate(2, datefrom, dateto)
        ltc  = aggregate(51, datefrom, dateto)
        doge = aggregate(3, datefrom, dateto)
        eth  = aggregate(52, datefrom, dateto)

        sessions_count = aggregate_sessions(datefrom, dateto)

        @turnover.push ( {:date => date.strftime("%Y-%m-%d"), :btc => btc, :ltc => ltc, :doge => doge, :eth => eth} )
        @sessions.push ( {:date => date.strftime("%Y-%m-%d"), :sessions => sessions_count} )
        date = date.ago(60*60*24)
      end
      #@turnover = { :date => date.strftime("%Y-%m-%d"), :btc => btc, :ltc => ltc, :doge => doge, :eth => eth}
    end
  end
end
