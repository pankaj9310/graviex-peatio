require 'net/http'
require 'uri'
require 'json'

class CoinRPC

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end

  def initialize(coin)
    @uri = URI.parse(coin.rpc)
    @rest = coin.rest
    @coin = coin
  end

  def self.[](currency)
    c = Currency.find_by_code(currency.to_s)
    if c && c.rpc
      if c.proto == 'ETH'
        name = 'ETH'
      elsif c.proto == 'BTC'
        name = 'BTC'
      elsif c.proto == 'OLD_BTC'
        name = 'OLD_BTC'
      elsif c.proto == 'WOA_BTC'
        name = 'WOA_BTC'
      elsif c.proto == 'LISK'
        name = 'LISK'
      elsif c.proto == 'CNT'
        name = 'CNT'
      elsif c.proto == 'FNT'
        name = 'FNT'
      elsif c.proto == 'TOU'
	name = 'TOU'
      else
        name = c[:handler]
      end

      Rails.logger.info "Making class " + name + "(" + currency.to_s + ")\n"
      "::CoinRPC::#{name}".constantize.new(c)
    end
  end

  def method_missing(name, *args)
    handle name, *args
  end

  def handle
    raise "Not implemented"
  end

  class BTC < self
    def handle(name, *args)
      post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']

      result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      @reply = http.request(request).body
      # Rails.logger.info @reply
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def getnewaddress(name, digest)
      @newaddress = handle("getnewaddress", name)
    end

    def sendtoaddress(from, address, amount)
      handle("sendtoaddress", address, amount)
    end

    def safe_getblockchaininfo
      begin
        getblockchaininfo
      rescue
        'N/A'
      end
    end

    def safe_getbalance
      begin
        getbalance
      rescue
        'N/A'
      end
    end
  end

  class OLD_BTC < self
    def handle(name, *args)
      post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
      Rails.logger.info "OLD_BTC " +  post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info resp
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']

      result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      # Rails.logger.info post_body
      @reply = http.request(request).body
      # Rails.logger.info @reply
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def sendtoaddress(from, address, amount)
      handle("sendtoaddress", address, amount)
    end

    def getnewaddress(name, digest)
      @newaddress = handle("getnewaddress", name)
    end

    def getblockchaininfo
      @getinfo = getinfo()
      {
        blocks: Integer(@getinfo[:blocks]),
        headers: 0,
        mediantime: 0
      }
    end

    def safe_getbalance
      begin
        getbalance
      rescue
        'N/A'
      end
    end
  end

 class WOA_BTC < self
    def handle(name, *args)
      post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
      Rails.logger.info "WOA_BTC " +  post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info resp
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']

      result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      #Rails.logger.info post_body
      @reply = http.request(request).body
      #Rails.logger.info @reply
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def sendtoaddress(from, address, amount)
      handle("sendtoaddress", address, amount)
    end

    def getnewaddress(name, digest)
      @newaddress = handle("getnewaddress", "")
    end

    def getblockchaininfo
      @getinfo = getinfo()
      {
        blocks: Integer(@getinfo[:blocks]),
        headers: 0,
        mediantime: 0
      }
    end

    def safe_getbalance
      begin
        getbalance
      rescue
        'N/A'
      end
    end
  end


  class ETH < self
    def handle(name, *args)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => args, 'id' => '1' }.to_json
      Rails.logger.info "ETH " +  post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info resp
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      if result == nil 
        return result
      end
      result.symbolize_keys! if result.is_a? Hash
      result
    end
    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      @reply = http.request(request).body
      # Rails.logger.info @reply
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def safe_getbalance
      begin
        #Rails.logger.info @rest + " -> " + "#{@rest}/cgi-bin/total.cgi"
        (open("#{@rest}/cgi-bin/total.cgi").read.rstrip.to_f)
      rescue => ex
        Rails.logger.info  "[error]: " + ex.message + "\n" + ex.backtrace.join("\n") + "\n"
        'N/A'
      end
    end

    def getblockchaininfo
      @lastBlock = eth_getBlockByNumber("latest", true)
      #Rails.logger.info @lastBlock
      #Rails.logger.info "number = " + Integer(@lastBlock[:number]).to_s + ", timestamp = " + Integer(@lastBlock[:timestamp]).to_s

      {
        blocks: Integer(@lastBlock[:number]),
        headers: 0,
        mediantime: Integer(@lastBlock[:timestamp])
      }
    end
  end

  class TOU < self
    def handle(name, *args)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => args, 'id' => '1' }.to_json
      Rails.logger.info "TOU " +  post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info resp
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      if result == nil 
        return result
      end
      result.symbolize_keys! if result.is_a? Hash
      result
    end
    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      @reply = http.request(request).body
      # Rails.logger.info @reply
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def safe_getbalance
      begin
        #Rails.logger.info @rest + " -> " + "#{@rest}/cgi-bin/total.cgi"
        (open("#{@rest}/cgi-bin/total.cgi").read.rstrip.to_f)
      rescue => ex
        Rails.logger.info  "[error]: " + ex.message + "\n" + ex.backtrace.join("\n") + "\n"
        'N/A'
      end
    end

    def getblockchaininfo
      @lastBlock = eth_getBlockByNumber("latest", true)
      #Rails.logger.info @lastBlock
      #Rails.logger.info "number = " + Integer(@lastBlock[:number]).to_s + ", timestamp = " + Integer(@lastBlock[:timestamp]).to_s

      {
        blocks: Integer(@lastBlock[:number]),
        headers: 0,
        mediantime: Integer(@lastBlock[:timestamp])
      }
    end
  end
  class LISK < self
    def handle(name, *args)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => args, 'id' => '1' }.to_json
      Rails.logger.info "LISK -> " + post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info "LISK <- " + resp.to_json
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      @reply = http.request(request).body
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def http_post_request_body(post_url, post_body)
      Rails.logger.info "LISK -> " + post_url + " / " + post_body
      uri     = URI.parse(post_url)
      http    = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth uri.user, uri.password
      request.content_type = 'application/json'
      request.body = post_body
      reply = JSON.parse(http.request(request).body)
      raise JSONRPCError, reply['error'] if reply['error']
      Rails.logger.info "LISK <- " + reply.to_json
      return reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def http_get_request(get_url)
      Rails.logger.info "LISK -> " + get_url
      uri     = URI.parse(get_url)
      http    = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth uri.user, uri.password
      request.content_type = ""
      request.body = ""
      reply = http.request(request).body
      result = JSON.parse(reply)
      raise JSONRPCError, result['error'] if result['error']
      Rails.logger.info "LISK <- " + result.to_json
      return result
    end

    def http_put_request_body(post_url, post_body)
      Rails.logger.info "LISK -> " + post_url + " / " + post_body
      uri     = URI.parse(post_url)
      http    = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Put.new(uri.request_uri)
      request.basic_auth uri.user, uri.password
      request.content_type = 'application/json'
      request.body = post_body
      reply = JSON.parse(http.request(request).body)
      raise JSONRPCError, reply['error'] if reply['error']
      Rails.logger.info "LISK <- " + reply.to_json
      return reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def safe_getbalance
      begin
        getbalance
      rescue => ex
        Rails.logger.info  "[error]: " + ex.message + "\n" + ex.backtrace.join("\n") + "\n"
        'N/A'
      end
    end

    def getbalance
      result = http_get_request("#{@rest}/api/accounts/getBalance?address=#{@coin.base_account}")
      balance = result['balance'].to_f / 100000000.0
      return balance
    end

    def gettransaction(txid)
      transaction = http_get_request("#{@rest}/api/transactions/get?id=#{txid}")

      {
        confirmations: transaction['transaction']['confirmations'],
        time: Time.now.to_i,
        details:
        [
          address: transaction['transaction']['recipientId'],
          amount: transaction['transaction']['amount'].to_f / 100000000.0,
          category: "receive"
        ]
      }
    end
  
    def settxfee
    end

    def sendtoaddress(from, address, amount)
      parameters = 
      {
        secret: from,
        amount: Integer(amount * 100000000.0),
        recipientId: address
      }.to_json

      result = http_put_request_body("#{@rest}/api/transactions", parameters)
      return result['transactionId']
    end

    # digest - simple form usermail & number
    def getnewaddress(base_account, digest)
      parameters =
      {
        secret: digest
      }.to_json

      result = http_post_request_body("#{@rest}/api/accounts/open", parameters)
      return result['account']['address']
    end

    def getfee(size)
      return (12000000.0/100000000.0).to_f
    end

    def validateaddress(address)
    end

    def getblockchaininfo

      result = http_get_request("#{@rest}/api/blocks/getStatus")

      {
        blocks: Integer(result['height']),
        headers: 0,
        mediantime: 0
      }
    end
  end

  class CNT < self
    def handle(name, *args)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => args, 'id' => '1' }.to_json
      Rails.logger.info "CNT -> " + post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info "CNT <- " + resp.to_json
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      #result.symbolize_keys! if result.is_a? Hash
      result
    end

    def handle_one(name, arg)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => arg, 'id' => '1' }.to_json
      Rails.logger.info "CNT -> " + post_body
      resp = JSON.parse( http_post_request(post_body) )
      Rails.logger.info "CNT <- " + resp.to_json
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      #result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      #request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      @reply = http.request(request).body
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end


    def safe_getbalance
      begin
        getbalance
      rescue => ex
        Rails.logger.info  "[error]: " + ex.message + "\n" + ex.backtrace.join("\n") + "\n"
        'N/A'
      end
    end

    def getbalance
      result = handle("getbalance")
      balance = result['balance'].to_f / 1000000000.0
      return balance
    end

    def gettransaction(txid)
      parameters =
      {
        txid: txid
      }
      transaction = handle_one("get_transfer_by_txid", parameters)
      confirmations = Integer(transaction['transfer']['height'])
      if confirmations > 0
        result = handle("getheight", "")
        confirmations = Integer(result['height']) - confirmations
      end
      result =  {
          confirmations: confirmations,
          time: Time.now.to_i,
          details:[]
        }
      if transaction['transfer']['destinations'] == nil
        return result
      end
      transaction['transfer']['destinations'].each do |destination|
        tx = {
            address: destination['address'],
            amount: destination['amount'].to_f / 1000000000.0,
            category: "receive"
          }
        result[:details].push(tx)
      end
      return result
    end

    def settxfee
    end

    def sendtoaddress(from, address, amount)
      parameters =
      {
        account_index: 0,
        destinations:
        [
          {
            amount: Integer(amount * 1000000000.0),
            address: address
          }
        ],
        get_tx_key: true
      }

      result = handle_one("transfer", parameters)
      return result['tx_hash']
    end

    def getnewaddress(name, digest)
      parameters =
      {
        account_index: 0,
        label: ""
      }.to_json

      result = handle_one("create_address", parameters)
      return result['address']
    end

    def getfee(size)
      return (30000000.0/1000000000.0).to_f
    end

    def validateaddress(address)
    end

    def getblockchaininfo

      result = handle("getheight", "")

      {
        blocks: Integer(result['height']),
        headers: 0,
        mediantime: 0
      }
    end
  end

  class FNT < self
    def handle(name, *args)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => args, 'id' => '1' }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      puts "FNT <- " + resp.to_json
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      #result.symbolize_keys! if result.is_a? Hash
      result
    end

    def handle_one(name, arg)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'params' => arg, 'id' => '1' }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      #result.symbolize_keys! if result.is_a? Hash
      result
    end

    def handle_only(name, arg)
      post_body = {"jsonrpc" => "2.0", 'method' => name, 'id' => '1' }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      result = resp['result']
      #result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.content_type = 'application/json'
      #request.basic_auth uri.user, uri.password
      request.body = post_body
      puts post_body
      @reply = http.request(request).body
      puts @reply
      return @reply
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def safe_getbalance
      begin
        getbalance
      rescue => ex
        puts  "[error]: " + ex.message + "\n" + ex.backtrace.join("\n") + "\n"
        'N/A'
      end
    end

    def getbalance
      result = handle_only("getBalance", "")
      balance = result['availableBalance'].to_f / 1000000000000.0
      return balance
    end

    def gettransaction(txid)
      parameters =
      {
        transactionHash: txid
      }
      transaction = handle_one("getTransaction", parameters)
      confirmations = Integer(transaction['transaction']['blockIndex'])
      if confirmations > 0
        result = handle_only("getStatus", "")
        confirmations = Integer(result['blockCount']) - confirmations
      end
      result =  {
          confirmations: confirmations,
          time: Time.now.to_i,
          details:[]
        }
      if transaction['transaction']['transfers'] == nil
        return result
      end
      transaction['transaction']['transfers'].each do |destination|
        tx = {
            address: destination['address'],
            amount: destination['amount'].to_f / 1000000000000.0,
            category: "receive"
          }
        result[:details].push(tx)
      end
      return result
    end

    def settxfee
    end

    def sendtoaddress(from, address, amount)
      parameters =
      {
        anonymity: 0,
        fee: 1000000,
        unlockTime: 0,
        transfers:
        [
          {
            amount: Integer(amount * 1000000000000.0),
            address: address
          }
        ],
        changeAddress: "BHuoqU2fRnQ6Cjot9nXbvDKw6y3vpjYA8dTQR9tKMVvxbYDm1w895eGRrKZrrc9q7x5kfiJTBTn8zEx7CWxDVLPMBzKGDYf"
      }

      result = handle_one("sendTransaction", parameters)
      return result['transactionHash']
    end

    def getnewaddress(base_account, digest)
      parameters =
      {
      }.to_json

      result = handle_only("createAddress", "")
      return result['address']
    end

    def getnewaddress(base_account, digest)
      parameters =
      {
      }.to_json

      result = handle_only("createAddress", "")
      return result['address']
    end

    def getfee(size)
      return (30000000.0/1000000000.0).to_f
    end

    def validateaddress(address)
    end

    def getblockchaininfo

      result = handle_only("getStatus", "")

      {
        blocks: Integer(result['blockCount']),
        headers: 0,
        mediantime: 0
      }
    end
  end
end

