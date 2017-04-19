require_relative './spec_helper'

describe 'Testing Public key resource routes' do
  before do
    Public_key.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new public key' do
    it 'HAPPY: should create a new unique public key' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo Public key', key: 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC9W0yKNIDI0wJ8EmTRZjLRa7ja+dip8RSAEUn8mUU6HuWAQj3hHRUQO4X6t25GJA1nWsjfN+m4jkJDDV2J8QKzMFisfLZ3XMRla3E83oOrbusdW+wZLy9B1/DZP81Jdf1Jv716ZexRwSQqgd0Ut1/VupIYMxbf8DPYY2lVC7KFooXtaa9bsedoC98FwNC484SOqt+Z87UQbAshmQxgfju/mS9+gyuTc/a/hE+vpHoqTgX97ixBFYpGq9XCCKTm4+3j+h7YkLSwrOmTN0tr0s0Z66ArNJB+2TYtM4FfgFj2k7UX8xS+y5rArA0AbnGjiNrBGpvgFAakuALG+hzt3teT', owner: 'odilonkoutou' }.to_json
      post '/api/v1/public_keys/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create duplicate public keys (key should be unique)' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo Public key', key: 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC9W0yKNIDI0wJ8EmTRZjLRa7ja+dip8RSAEUn8mUU6HuWAQj3hHRUQO4X6t25GJA1nWsjfN+m4jkJDDV2J8QKzMFisfLZ3XMRla3E83oOrbusdW+wZLy9B1/DZP81Jdf1Jv716ZexRwSQqgd0Ut1/VupIYMxbf8DPYY2lVC7KFooXtaa9bsedoC98FwNC484SOqt+Z87UQbAshmQxgfju/mS9+gyuTc/a/hE+vpHoqTgX97ixBFYpGq9XCCKTm4+3j+h7YkLSwrOmTN0tr0s0Z66ArNJB+2TYtM4FfgFj2k7UX8xS+y5rArA0AbnGjiNrBGpvgFAakuALG+hzt3teT', owner: 'odilonkoutou' }.to_json
      post '/api/v1/public_keys/', req_body, req_header
      post '/api/v1/public_keys/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing public keys' do
    it 'HAPPY: should find an existing public key' do
      new_public_key = Public_key.create(name: 'Demo Public key', key: 'N+m4jkJDDV2', owner: 'ismaelnoble')

      get "/api/v1/public_keys/#{new_public_key.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_public_key.id

    end

    it 'SAD: should not find existent public key' do
      get "/api/v1/public_keys/#{invalid_id(Public_key)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing public keys' do
    it 'HAPPY: should find list of existing public keys' do
      (1..5).each { |i| Public_key.create(name: "Public key #{i}", key: "key #{i}", owner: "user#{i}") }
      result = get '/api/v1/public_keys'
      keys = JSON.parse(result.body)
      _(keys['data'].count).must_equal 5
    end
  end
end
