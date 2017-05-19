# frozen_string_literal: true

# Tests for the route route

require_relative './spec_helper'

describe 'Test root route' do
  it 'should find the root route' do
    get '/'
    _(last_response.body).must_include 'Secure chat web API'
    _(last_response.status).must_equal 200
  end
end
