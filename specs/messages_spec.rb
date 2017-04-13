require_relative './spec_helper'

describe 'Testing Configuration resource routes' do
  before do
    Message.dataset.delete
    Public_Key.dataset.delete
  end

  describe 'Create a new message' do
    it 'Happy: should create new message in db'do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    req_body = { body: 'bla bla bla testing test'}.to_json
    post "/api/v1/messages/",
          req_body, req_header
    _(last_response.status).must_equal 201
  end

    it 'SAD: should not add a message for non-existant variable' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { body2: 'bla bla bla testing test'}.to_json
      post "/api/v1/messages/",
            req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting messages' do
    it 'HAPPY: should find existing messages' do
      message = Message.create(from: 'me', to:'you',title:'a title',about:'an about',
                               expire_date:'some value',status:'good',body: 'Demo message')
      get "/api/v1/messages/#{message.id}"
      _(last_response.status).must_equal 200
      parsed_config = JSON.parse(last_response.body)['data']['body']
      _(parsed_config['type']).must_equal 'message'
    end

    it 'SAD: should not find non-existant message' do
      message_id = invalid_id(Message)
      get "/api/v1/messages/#{message_id}"
      _(last_response.status).must_equal 404
    end
  end
end
