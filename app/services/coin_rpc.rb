require 'net/http'
require 'uri'
require 'json'

class CoinRPC

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end

  def initialize(uri)
    @uri = URI.parse(uri)
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

      else
        name = c[:handler]
      end

      # Rails.logger.info "Making class " + name + "(" + currency.to_s + ")\n"
      "::CoinRPC::#{name}".constantize.new(c.rpc)
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

    def getnewaddress(name)
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
        (open('http://192.168.0.194:8080/cgi-bin/total.cgi').read.rstrip.to_f)
      rescue
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

end
