module Admin
  class DashboardController < BaseController
    skip_load_and_authorize_resource

    def aggregate_sessions(datefrom, dateto)
      sql = "select count(*) as result from (select count(*) from signup_histories where created_at >= '#{datefrom}' and created_at <= '#{dateto}' group by member_id) as t";
      res = ActiveRecord::Base.connection.exec_query(sql).first
      amount = 0
      if res != nil
        amount = res['result'].to_i
      end
      return amount
    end

    def collect_turnover_summary
      sql = "select max(slice) as result from turnover_summary group by slice order by slice desc limit 1"
      res = ActiveRecord::Base.connection.exec_query(sql).first
      slice = DateTime.now.to_i

      if res != nil
        slice = res['result'].to_i
      end

      sql = "select created_at, btc, ltc, doge, eth from turnover_summary where slice = #{slice}"
      res = ActiveRecord::Base.connection.exec_query(sql)

      @turnover = []
      res.each do |day| 
        @turnover.push ( {:date => day['created_at'].strftime("%Y-%m-%d"), :btc => day['btc'], :ltc => day['ltc'], :doge => day['doge'], :eth => day['eth']} )
      end
    end

    def collect_currencies_summary
      sql = "select max(slice) as result from currencies_summary group by slice order by slice desc limit 1"
      res = ActiveRecord::Base.connection.exec_query(sql).first
      slice = DateTime.now.to_i
      
      if res != nil
        slice = res['result'].to_i
      end

      sql = "select currency, balance, locked, balance+locked as sum, hot from currencies_summary where slice = #{slice}"
      res = ActiveRecord::Base.connection.exec_query(sql)

      @currencies_summary = []
      res.each do |ccy|
        @currencies_summary.push ( {:name => ccy['currency'], :balance => ccy['balance'], :locked => ccy['locked'], :sum => ccy['sum'], :hot => ccy['hot'], :coinable => true} )  
      end
    end

    def index
      @daemon_statuses = Global.daemon_statuses

      # @currencies_summary = []
      # collect_currencies_summary
      @currencies_summary = Currency.all.map(&:summary)
      @register_count = Member.count

      @turnover = []
      collect_turnover_summary

      @sessions = []

      date = DateTime.now
      for i in 1..7
        datefrom = date.strftime("%Y-%m-%d 00:00:00")
        dateto = date.strftime("%Y-%m-%d 23:59:59")

        sessions_count = aggregate_sessions(datefrom, dateto)

        @sessions.push ( {:date => date.strftime("%Y-%m-%d"), :sessions => sessions_count} )
        date = date.ago(60*60*24)
      end
    end
  end
end
