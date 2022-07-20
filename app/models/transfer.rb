class Transfer < ApplicationRecord
  # Attributes
  # - id: UUID
  # - external_id: String
  # - sender_id: UUID, User reference
  # - receiver_id: UUID, User reference
  # - amount_cents: Int (Amount sent; in sender's currency)
  # - rate: Float (Conversion rate between sender's and receiver's currencies)
  # - status: String{pending, succeeded, failed}
  # - *timestamps

  STATUSES = %w(pending succeeded failed).freeze

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
end
