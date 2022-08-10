require 'json'
require 'open3'
require 'bundler'

class RunWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook, message)
    begin
      env = JSON.parse(webhook.environment, symbolize_names: false)
      env.each do |key, value|
        if env[key].class != String
          env[key] = value.to_s
        end
      end
    rescue StandardError => e
      webhook.journals.create stdin: '',
                              result: 0,
                              stdout: '',
                              stderr: 'invalid environment'
      return
    end

    env ||= Hash.new
    env['PWD'] = webhook.working_directory

    Rails.logger.error "chdir #{webhook.working_directory}"
    Dir.chdir(webhook.working_directory)

    begin
      Rails.logger.error 'about to run'

      # https://web.archive.org/web/20161026202728/http://www.rakefieldmanual.com/fascicles/001-clean-environment.html
      Bundler.with_clean_env do
        stdout, stderr, status =  Open3.capture3(env, webhook.application, stdin_data: message)

        Rails.logger.error 'about to create journal'
        webhook.journals.create stdin: message,
                                result: status,
                                stdout: stdout,
                                stderr: stderr
      end

    rescue StandardError => e
      webhook.journals.create  stdin: message,
                               result: -1,
                               stdout: '',
                               stderr: e.to_s
    end

    Rails.logger.error "ran"
  end
end
