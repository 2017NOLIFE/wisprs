require 'json'
require 'base64'
require 'rbnacl/libsodium'

# Holds a full Message document information
class Message
  STORE_DIR = 'db/'.freeze

  attr_accessor :id, :project, :name, :description, :document

  def initialize(new_Message)
    @id = new_Message['id'] || new_id
    @from = new_Message['from']
    @to = new_Message['to']
    @about = new_Message['about']
    @title = new_Message['title']
    @exp = new_Message['exp']
    @document = new_Message['document']
  end

  def new_id
    Base64.urlsafe_encode64(RbNaCl::Hash.sha256(Time.now.to_s))[0..9]
  end

  def to_json(options = {})
    JSON({ id: @id,
           from: @from,
           to: @to,
           about: @about,
           title: @title,
           exp: @exp,
           document: @document },
         options)
  end

  def save
    File.open(STORE_DIR + @id + '.txt', 'w') do |file|
      file.write(to_json)
    end

    true
  rescue
    false
  end

  def self.find(find_id)
    config_file = File.read(STORE_DIR + find_id + '.txt')
    Message.new JSON.parse(config_file)
  end

  def self.all
    Dir.glob(STORE_DIR + '*.txt').map do |filename|
      filename.match(/#{Regexp.quote(STORE_DIR)}(.*)\.txt/)[1]
    end
  end

  def self.setup
    Dir.mkdir(Message::STORE_DIR) unless Dir.exist? STORE_DIR
  end
end
