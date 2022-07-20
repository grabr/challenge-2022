Fabricator(:user) do
  external_id { SecureRandom.uuid }
  balance_cents { 0 }
  pending_balance_cents { 0 }
  balance_currency { 'ARS' }
end
