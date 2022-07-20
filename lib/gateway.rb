class Gateway
  ## Sends a POST /transfers request to some external service.
  # Payload:
  # - from_id – ID of the sender (User#external_id)
  # - to_id – ID of the receiver (User#external_id)
  # - amount_cents – Amount (cents) in a sender's currendy
  #
  # Response:
  # - transfer_id: external ID of the created transfer
  # - rate: fresh rate between sender's and receiver's currency
  # Errors:
  # - NetworkError

  class NetworkError < StandardError; end

  def create_transfer(from_id:, to_id:, amount_cents:)
    response = post(
      "/transfers", {
        from_id: from_id,
        to_id: to_id,
        amount_cents: amount_cents
      }.to_json
    )

    if response.success?
      JSON.parse(response.body).symbolize_keys
    else
      raise NetworkError
    end
  end

  private

  # stub
  class Response
    def success?
      [true, true, true, false].sample
    end

    def body
      {
        transfer_id: SecureRandom.uuid,
        rate: [1.123, 2.345, 3.456].sample
      }.to_json
    end
  end

  # stub
  def post(path, json_body)
    sleep rand
    Response.new
  end
end
