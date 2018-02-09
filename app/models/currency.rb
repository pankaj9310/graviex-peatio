require 'date'

class Currency < ActiveYamlBase
  include International
  include ActiveHash::Associations

  field :visible, default: true

  @last_blocks = 0
  @local_time = 0

  self.singleton_class.send :alias_method, :all_with_invisible, :all
  def self.all
    all_with_invisible.select &:visible
  end

  def self.enumerize
    all_with_invisible.inject({}) {|memo, i| memo[i.code.to_sym] = i.id; memo}
  end

  def self.codes
    @keys ||= all.map &:code
  end

  def self.ids
    @ids ||= all.map &:id
  end

  def self.assets(code)
    find_by_code(code)[:assets]
  end

  def precision
    self[:precision]
  end

  def api
    raise unless coin?
    CoinRPC[code]
  end

  def fiat?
    not coin?
  end

  def is_online_cache_key
    "peatio:hotwallet:#{code}:online"
  end

  def balance_cache_key
    "peatio:hotwallet:#{code}:balance"
  end

  def blocks_count_cache_key
    "peatio:hotwallet:#{code}:blocks"
  end

  def headers_count_cache_key
    "peatio:hotwallet:#{code}:headers"
  end

  def blocktime_cache_key
    "peatio:hotwallet:#{code}:blocktime"
  end

  def balance
    Rails.cache.read(balance_cache_key) || 0
  end

  def blocks
    Rails.cache.read(blocks_count_cache_key) || 0
  end

  def headers
    Rails.cache.read(headers_count_cache_key) || 0
  end

  def blocktime
    Rails.cache.read(blocktime_cache_key) || Time.at(1).to_datetime.strftime("%Y-%m-%d %H:%M:%S")
  end

  def is_online
    Rails.cache.read(is_online_cache_key) || "offline"
  end

  def decimal_digit
    self.try(:default_decimal_digit) || (fiat? ? 2 : 4)
  end

  def refresh_balance
    Rails.cache.write(balance_cache_key, api.safe_getbalance) if coin?
  end

  def refresh_status
    begin
      @local_status = api.getblockchaininfo
      Rails.cache.write(is_online_cache_key, "online")
    rescue => e
      Rails.logger.error "[hotwallet/refresh_status/#{code}]: " + e.message + "\n"
      Rails.cache.write(is_online_cache_key, "offline")
    end

    if @local_status
      Rails.logger.info @local_status

      if !@last_blocks
        @last_blocks = 0
      end

      if !@local_time
        @local_time = 0
      end 

      if @local_status[:mediantime] > 0
        @local_time = @local_status[:mediantime]
      end

      if @local_status[:mediantime] == 0 && @local_status[:blocks] > @last_blocks
        @last_blocks = @local_status[:blocks]
        @local_time = Time.now.to_i
      end

      #Rails.logger.info @local_time
      Rails.cache.write(blocks_count_cache_key, @local_status[:blocks]) if coin?
      Rails.cache.write(headers_count_cache_key, @local_status[:headers]) if coin?
      Rails.cache.write(blocktime_cache_key, Time.at(@local_time).to_datetime.strftime("%Y-%m-%d %H:%M:%S")) if coin?
    end
  end

  def blockchain_url(txid)
    raise unless coin?
    blockchain.gsub('#{txid}', txid.to_s)
  end

  def address_url(address)
    raise unless coin?
    self[:address_url].try :gsub, '#{address}', address
  end

  def quick_withdraw_max
    @quick_withdraw_max ||= BigDecimal.new self[:quick_withdraw_max].to_s
  end

  def as_json(options = {})
    {
      key: key,
      code: code,
      coin: coin,
      blockchain: blockchain
    }
  end

  def summary
    locked = Account.locked_sum(code)
    balance = Account.balance_sum(code)
    sum = locked + balance

    coinable = self.coin?
    hot = coinable ? self.balance : nil

    {
      name: self.code.upcase,
      sum: sum,
      balance: balance,
      locked: locked,
      coinable: coinable,
      is_online: is_online,
      blocks: blocks,
      headers: headers,
      blocktime: blocktime,
      hot: hot
    }
  end
end
