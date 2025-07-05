require 'telegram/bot'
require "#{File.dirname(__FILE__)}/../app/routes"
require 'semantic_logger'

class BotClient
  def initialize(token = ENV['TELEGRAM_TOKEN'], log_level = ENV['LOG_LEVEL'] || 'error', log_url = ENV['LOG_URL'])
    @token = token
    @username = ENV['TELEGRAM_USERNAME']
    SemanticLogger.default_level = log_level.to_sym
    SemanticLogger.add_appender(
      io: $stdout
    )
    unless log_url.nil? || log_url.empty?
      SemanticLogger.add_appender(
        appender: :http,
        url: log_url,
        application: 'bot'
      )
    end
    @logger = SemanticLogger['BotClient']
  end

  def start
    @logger.info "Starting bot version:#{Version.current}"
    @logger.info "username is #{@username}"
    @logger.info "token is #{@token}"
    run_client do |bot|
      bot.listen do |message|
        chat_id = extract_chat_id(message)
        message_id = extract_message_id(message)

        correlation_id = "cid:#{chat_id}-#{message_id}"
        Thread.current[:cid] = correlation_id

        SemanticLogger.tagged(correlation_id) do
          handle_message(message, bot)
        end
      end
    rescue StandardError => e
      @logger.fatal e.message
    end
  end

  def run_once
    run_client do |bot|
      bot.fetch_updates { |message| handle_message(message, bot) }
    end
  end

  private

  def run_client(&block)
    Telegram::Bot::Client.run(@token, logger: @logger) { |bot| block.call bot }
  end

  def handle_message(message, bot)
    @logger.debug "From: @#{message.from.username}, message: #{message.inspect}"

    Routes.new.handle(bot, message)
  end

  def extract_chat_id(message)
    case message
    when Telegram::Bot::Types::Message
      message.chat.id
    when Telegram::Bot::Types::CallbackQuery
      message.message.chat.id
    else
      'unknown_chat'
    end
  end

  def extract_message_id(message)
    case message
    when Telegram::Bot::Types::Message
      message.message_id
    when Telegram::Bot::Types::CallbackQuery
      message.message.message_id
    else
      'unknown_msg'
    end
  end
end
