# frozen_string_literal: true

json.extract! league, :id, :created_at, :updated_at
json.url league_url(league, format: :json)
