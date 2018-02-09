module Worker
  class OrderProcessor
    def initialize
      @cancel_queue = []
      @is_pump = true
      @price = 10.0/1000000000.0;
      create_cancel_thread
      #create_test_thread
    end

    def process(payload, metadata, delivery_info)
      case payload['action']
      when 'cancel'
        unless check_and_cancel(payload['order'])
          @cancel_queue << payload['order']
        end
      else
        raise ArgumentError, "Unrecogonized action: #{payload['action']}"
      end
    rescue
      SystemMailer.order_processor_error(payload, $!.message, $!.backtrace.join("\n")).deliver
      raise $!
    end

    def check_and_cancel(attrs)
      retry_count = 5
      begin
        order = Order.find attrs['id']
        if order.volume == attrs['volume'].to_d # all trades has been processed
          Ordering.new(order).cancel!
          puts "Order##{order.id} cancelled."
          true
        end
      rescue ActiveRecord::StatementInvalid
        # in case: Mysql2::Error: Lock wait timeout exceeded
        if retry_count > 0
          sleep 0.5
          retry_count -= 1
          puts $!
          puts "Retry order.cancel! (#{retry_count} retry left) .."
          retry
        else
          puts "Failed to cancel order##{order.id}"
          raise $!
        end
      end
    rescue Ordering::CancelOrderError
      puts "Skipped: #{$!}"
      true
    end

    def process_cancel_jobs
      queue = @cancel_queue
      @cancel_queue = []

      queue.each do |attrs|
        unless check_and_cancel(attrs)
          @cancel_queue << attrs
        end
      end

      Rails.logger.info "Cancel queue size: #{@cancel_queue.size}"
    rescue
      Rails.logger.debug "Failed to process cancel job: #{$!}"
      Rails.logger.debug $!.backtrace.join("\n")
    end

    def create_test_order
      Rails.logger.info "Try to create test order"
      member_rand = rand(10)
      member1 = 2
      member2 = 3
      if member_rand >= 5
        member1 = 3
        member2 = 2
      end
      Rails.logger.info "Creating test order"
      price1 = @price + rand(10)/1000000000.0
      volume1 = rand(10)*0.1
      if price1*volume1*0.001 < 0.000000001
        volume1 = 0.000000002 / (price1 * 0.001)
      end
      price2 = @price + rand(10)/1000000000.0
      volume2 = rand(10)*0.1
      if price2*volume2*0.001 < 0.000000001
        volume2 = 0.000000002 / (price2 * 0.001)
      end
      Rails.logger.info "Price " + price1.to_s + " volume " + volume1.to_s + " price " + price2.to_s + " volume " + volume2.to_s
      order_bid = OrderBid.new(
        source:        'APIv2',
        state:         ::Order::WAIT,
        member_id:     member1,
        ask:           'gio',
        bid:           'btc',
        currency:      4,
        ord_type:      'limit',
        price:         price1,
        volume:        volume1,
        origin_volume: rand(10)*0.1
      )
      Ordering.new(order_bid).submit
      order_ask = OrderAsk.new(
        source:        'APIv2',
        state:         ::Order::WAIT,
        member_id:     member2,
        ask:           'gio',
        bid:           'btc',
        currency:      4,
        ord_type:      'limit',
        price:         price2,
        volume:        volume2,
        origin_volume: volume2
      )
      Ordering.new(order_ask).submit
      if @is_pump
        @price = @price + 5.0/1000000000.0
      else
        @price = @price - 5.0/1000000000.0
      end
      if @price >= 600.0/1000000000.0
        @is_pump = false
      end
      if @price <= 10.0/1000000000.0
        @is_pump = true
      end
    rescue
      Rails.logger.debug "Failed to create test order \n"
      Rails.logger.debug $!.backtrace.join("\n")
    end

    def create_cancel_thread
      Thread.new do
        loop do
          sleep 5
          process_cancel_jobs
        end
      end
    end

    def create_test_thread
      Thread.new do
        loop do
          sleep 15
          create_test_order
        end
      end
    end

  end
end
