require_relative './spec_helper'

describe 'Testing Message resource routes' do
  before do
    Public_key.dataset.destroy
    Message.dataset.destroy
    Chat.dataset.destroy
    Account.dataset.destroy
    @from_account = CreateAccount.call(
      username: 'odilon',
      password: 'mypass',
      email: 'odilon@nthu.edu.tw.com'
    )
    @to_account = CreateAccount.call(
      username: 'kai',
      password: 'mypass',
      email: 'kai@nthu.edu.tw.com'
    )
  end

  describe 'Send a new message' do
    before do
      message_data = {
        from_id: @from_account.id,
        to_id: @to_account.id,
        title: 'Hello',
        about: 'All about greeting',
        expire_date: '2017/05/20',
        status: 'UNREAD',
        body: 'Hello Kai. We need to work harder on the project'
      }
      @req_body = message_data.to_json
    end
    it 'Happy: should create new message in db' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/v1/accounts/#{@from_account.id}/send_message/",
           @req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not send a message with a non-existant variable' do
      message_data = {
        from_id: @from_account.id,
        to_id: @to_account.id,
        body: 'Hello everyone'
      }
      @req_body = message_data.to_json
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "/api/v1/accounts/#{@from_account.id}/send_message/",
           @req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting messages' do
    before do
      @new_message = SendMessage.call(
        from_id: @from_account.id,
        to_id: @to_account.id,
        title: 'Hello',
        about: 'All about greeting',
        expire_date: 'Test',
        status: 'NO',
        body: 'Hello everyone'
      )
    end
    it 'HAPPY: should find an existing message' do
      auth = AuthenticateAccount.call(username: 'odilon',
                                      password: 'mypass')
      auth_headers = { 'HTTP_AUTHORIZATION' => "Bearer #{auth[:auth_token]}" }
      get "/api/v1/messages/#{@new_message.id}", nil, auth_headers
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['id']).must_equal @new_message.id
    end

    it 'SAD: should not find non-existant message' do
      get "/api/v1/messages/#{invalid_id(Message)}"
      _(last_response.status).must_equal 401
    end
  end

  describe 'Get all messages (sent and received) for an account' do
    before do
      @other_account = CreateAccount.call(
        username: 'noble',
        email: 'noble@nthu.edu.tw.com',
        password: 'noblass'
      )
      @my_messages = []
      3.times do |i|
        @new_message = SendMessage.call(
          from_id: @from_account.id,
          to_id: @to_account.id,
          title: "Message #{i} title",
          about: "Message #{i} about",
          expire_date: '2017/05/19',
          status: 'UNREAD',
          body: "Operation #{i} on schedule"
        )
        @my_messages << @new_message
      end
      2.times do |i|
        @new_message = SendMessage.call(
          from_id: @other_account.id,
          to_id: @from_account.id,
          title: "Message that I received #{i} title",
          about: "Message that I received #{i} about",
          expire_date: '2017/06/19',
          status: 'UNREAD',
          body: "Operation #{i} cancelled"
        )
        @my_messages << @new_message
      end
    end
    it 'HAPPY: should find all the messages for an account' do
      auth = AuthenticateAccount.call(username: 'odilon',
                                      password: 'mypass')
      auth_headers = { 'HTTP_AUTHORIZATION' => "Bearer #{auth[:auth_token]}" }
      result = get "/api/v1/accounts/#{@from_account.id}/messages",
                   nil, auth_headers
      _(last_response.status).must_equal 200

      messages = JSON.parse(result.body)

      valid_ids = @my_messages.map(&:id)
      _(messages['data'].count).must_equal 5
      messages['data'].each do |msg|
        _(valid_ids).must_include msg['id']
      end
    end
  end
end
