json.array!(@events) do |event|
  json.extract! event, :id
  json.title event.place
  json.date event.at_date
  json.url event_url(event)

   if event.at_date > Time.now
    json.color ""
  else
    json.color "gray"
  end
end