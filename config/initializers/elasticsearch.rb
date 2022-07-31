Elasticsearch::Model.client = Elasticsearch::Client.new({
    log: true,
    host: "es"
    }
  )

# Elasticsearch::Model.client = Elasticsearch::Client.new({
#   log: true
#   }
# )