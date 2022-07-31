class Producer
    
    def self.send(data)
        rMQConnection = Bunny.new "amqp://guest:guest@rabbitmq:5672"
        # rMQConnection = Bunny.new
        
        # rMQConnection = Bunny.new(host: "rabbitmq",
        #     port:  '5672',
        #     vhost: '/',
        #     user:  'guest',
        #     pass:  'guest')

        rMQConnection.start

        channel = rMQConnection.create_channel
        queue = channel.queue('InstabugQueue',durable: true)
        
        channel.default_exchange.publish(data, routing_key: queue.name)

        rMQConnection.close
    end

end