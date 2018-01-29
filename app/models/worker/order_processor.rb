module Worker
  class OrderProcessor

    def initialize
      @cancel_queue = []
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
      member_rand = rand(10)
      member1 = 2
      member2 = 3
      if member_rand >= 5
        member1 = 3
        member2 = 2
      end
      order_bid = OrderBid.new(
        source:        'APIv2',
        state:         ::Order::WAIT,
        member_id:     member1,
        ask:           'gio',
        bid:           'btc',
        currency:      4,
        ord_type:      'limit',
        price:         1+rand(100)/10.0,
        volume:        0.01,
        origin_volume: 0.01
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
        price:         1+rand(100)/10.0,
        volume:        0.01,
        origin_volume: 0.01
      )
      Ordering.new(order_ask).submit
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
          sleep 5
          create_test_order
        end
      end
    end

  end
end
