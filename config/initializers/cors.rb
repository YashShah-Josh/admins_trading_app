Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # Allow all origins (for development)

    resource "*",
      headers: :any,
      methods: [:get, :post, :options, :put, :patch, :delete] # Allow OPTIONS requests
  end
end
