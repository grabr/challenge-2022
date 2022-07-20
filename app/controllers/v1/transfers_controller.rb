module V1
  class TransfersController < BaseController
    # Available scope:
    # - current_user
    # Params:
    # - to_id:
    # - amount_cents:
    # Expected response:
    # - In case of success:
    #   - status: 201
    #   - json: { transfer_id: <CREATED TRANSFER ID> }
    # - In case of failure:
    #   - status: 422
    #   - json: { error: <ERROR MESSAGE> }
    def create
      render json: {}
    end
  end
end
