stack = Faraday::RackBuilder.new do |builder|
  # Cache github requests to file because we make too many of them
  cache_path = Rails.root.join('cache')
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false, logger: Rails.logger, store: ActiveSupport::Cache::FileStore.new(cache_path)
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack
