class WebhooksController < ApplicationController
  # Webhook handler
  # Payload:
  # - transfer_id: External ID of Transfer
  # - status: `succeeded` or `failed`
  # Response:
  # - 200: OK
  # - 400: Webhook will retry later
  # - 404, 5xx: Webhook will not retry later
  def create
  end
end
