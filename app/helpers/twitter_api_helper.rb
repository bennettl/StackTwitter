module TwitterApiHelper

    class TwitterApi
        
        @@count = 25

        @@client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "Ibg0OhwIYx7sh2tOgXBpUYE0l"
            config.consumer_secret     = "8y8BdxFvP6Hv4LNlX0nPNWOb2Aohxy6BXCwrx5KGAofZ2zGBHB"
            config.access_token        = "153720299-cLBjBQ7sykHTo4tGmt2OvisbZny3LkmcynugFHjp"
            config.access_token_secret = "KyZrUF3qm1LRCkKVEzgmfWQoCgUpP0OzHlQl5B4u3M7Oc"
        end

        def self.get_tweets_for_handle(handle)
            return @@client.search("to:#{handle}", result_type: "recent").take(@@count)
        end
    end

end