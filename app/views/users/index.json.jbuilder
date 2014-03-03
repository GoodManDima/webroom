json.array!(@users) do |user|
  json.extract! user, :id, :name, :surname, :age
  json.url user_url(user, format: :json)
end
