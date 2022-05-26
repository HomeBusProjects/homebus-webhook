require 'open3'

class WController < ApplicationController
  def post
    webhook = Webhook.find_by path: params[:path]

    stdin = request.body.string

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
    end

    Rails.logger.error "about to run"

    begin
      stdout, stderr, status =  Open3.capture3 env, webhook.application, stdin_data: stdin
      webhook.journals.create stdin: stdin,
                               result: status,
                               stdout: stdout,
                               stderr: stderr
    rescue StandardError => e
      webhook.journals.create  stdin: stdin,
                               result: -1,
                               stdout: '',
                               stderr: e.to_s
    end

    Rails.logger.error "ran"
  end
end
