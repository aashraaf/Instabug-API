require 'elasticsearch/model'

class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name "message_index"

    message_es_settings = {
        max_ngram_diff: 2,
        analysis: {
          analyzer: {
            my_analyzer: {
              tokenizer: "my_tokenizer"
            }
          },
          tokenizer: {
            my_tokenizer: {
              type: "ngram",
              min_gram: 1,
              max_gram: 3,
              token_chars: [
                "letter",
                "digit"
              ]
            }
          }
        } 
      }
    
      settings message_es_settings do
        mapping dynamic: false do
          indexes :body, analyzer: "my_analyzer"
          indexes :token, type: "keyword"
          indexes :chatNumber, type: "keyword"
          indexes :number, type: "keyword"
  
  
      end
    end

    def self.search(query, application_id, chat_id)
        bodySearch = __elasticsearch__.search(

          {
            query: {
              match: {
                body: {
                  query: query, 
                  operator: "and"
              }
            }
          },
            
          }
        )

        result = []
        bodySearch.each do |b|
            if b._source.token.to_s == application_id.to_s && b._source.chatNumber.to_s == chat_id.to_s
                result.push(b._source)
            end
        end
        result
        
    end
    
    def as_indexed_json(options = nil)
        self.as_json( only: [ :body, :token, :chatNumber, :number ] )
    end
end
