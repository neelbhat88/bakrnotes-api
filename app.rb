require "sinatra/base"

class BakrNotes < Sinatra::Base
  get "/" do
    "Welcome to BakrNotes!"
  end

  get "/users" do
    "List of users"
  end

  post "/users" do
    "Creating User!"
  end
end
