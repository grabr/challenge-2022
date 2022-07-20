require 'rails_helper'
require 'gateway'

describe 'v1/transfers', type: :request do
  subject { post '/v1/transfers', params: params, headers: default_headers }

  let!(:sender) do
    Fabricate(
      :user,
      balance_cents: sender_balance,
      pending_balance_cents: sender_pending_balance,
      balance_currency: 'ARS'
    )
  end

  let!(:receiver) do
    Fabricate(:user, balance_currency: 'BRL')
  end

  let(:sender_balance) { 100_00 }
  let(:sender_pending_balance) { sender_balance }

  let(:default_headers) do
    {
      'Auth-User-Id' => sender.id,
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  let(:params) { { to_id: receiver.id, amount_cents: 100_0 }.to_json }

  before do
    stub = allow_any_instance_of(Gateway).to receive(:create_transfer)

    case gateway_response
    when Hash
      stub.and_return(gateway_response)
    when Exception
      stub.and_raise(gateway_response)
    end
  end

  let(:gateway_response) { { transfer_id: external_id, rate: rate } }
  let(:external_id) { SecureRandom.uuid }
  let(:rate) { 1.5 }

  let(:transfer) { Transfer.last }

  context 'when sender has available balance' do
    it 'creates a transfer' do
      expect { subject }.to change(Transfer, :count).by(1)

      expect(transfer.rate).to eq rate
      expect(transfer.status).to eq 'pending'
      expect(transfer.sender_id).to eq sender.id
      expect(transfer.receiver_id).to eq receiver.id
      expect(transfer.external_id).to eq external_id
      expect(response.status).to eq 201

      expect(JSON.parse(response.body)).to eq({ 'transfer_id' => transfer.id })
    end
  end

  context 'when gateway throws an error' do
    let(:gateway_response) { Gateway::NetworkError }

    it 'responds with an error' do
      expect { subject }.not_to change(Transfer, :count)

      expect(response.status).to eq 422
      expect(JSON.parse(response.body)).to have_key('error')
    end
  end

  context 'when sender doesnt have sufficient balance' do
    let(:sender_balance) { 1_00 }

    it 'responds with an error' do
      expect { subject }.not_to change(Transfer, :count)

      expect(response.status).to eq 422
      expect(JSON.parse(response.body)).to eq({ 'error' => 'insufficient_balance' })
    end
  end
end
