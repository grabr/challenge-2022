Fabricator(:transfer) do
  sender { Fabricate(:user) }
  receiver { Fabricate(:user) }
  external_id { SecureRandom.uuid }
  amount_cents { 100_00 }
  rate { 1.5 }
  status { 'pending' }
end
