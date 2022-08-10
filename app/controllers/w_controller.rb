class WController < ApplicationController
  def post
    webhook = Webhook.find_by path: params[:path]

    unless webhook && webhook.enabled?
      raise ActionController::RoutingError.new('Not Found')
    end

    message = request.body.string

    RunWebhookJob.perform_later(webhook, message)
  end
end
