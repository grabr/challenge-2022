class User < ApplicationRecord
  # Attributes:
  # - id: UUID
  # - external_id: String (ID in the external transfers service)
  # - balance_cents: Int (User's balance)
  # - balance_currency: String{BRL,MXN,ARS} (User's currency)
  # - pending_balance_cents: Int (Balance including pending transfers)
  # - *timetamps

  BALANCE_CURRENCIES = %w(ARS BRL MXN).freeze

  has_many :incoming_transfers, class_name: 'Transfer', foreign_key: :receiver_id
  has_many :outgoing_transfers, class_name: 'Transfer', foreign_key: :sender_id
end
