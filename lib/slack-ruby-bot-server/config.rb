module SlackRubyBotServer
  module Config
    extend self

    attr_accessor :server_class
    attr_accessor :service_class
    attr_accessor :database_adapter
    attr_accessor :view_paths

    def reset!
      self.server_class = SlackRubyBotServer::Server
      self.service_class = SlackRubyBotServer::Service

      self.view_paths = [
        'views',
        'public',
        File.expand_path(File.join(__dir__, '../../public'))
      ]

      self.database_adapter = if defined?(::Mongoid)
                                :mongoid
                              elsif defined?(::ActiveRecord)
                                :activerecord
                              else
                                raise 'One of "mongoid" or "activerecord" is required.'
                              end
    end

    def activerecord?
      database_adapter == :activerecord
    end

    def mongoid?
      database_adapter == :mongoid
    end

    reset!
  end

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end
