require 'rails_helper'

describe 'webhooks', type: :request do
  subject { post '/webhooks', params: params }

  let!(:sender) do
    Fabricate(
      :user,
      balance_cents: 100_00,
      pending_balance_cents: 0,
      balance_currency: 'ARS'
    )
  end

  let!(:receiver) do
    Fabricate(:user, balance_currency: 'BRL', balance_cents: 0)
  end

  let!(:transfer) do
    Fabricate(
      :transfer,
      sender: sender,
      external_id: transfer_ext_id,
      receiver: receiver,
      amount_cents: 100_00,
      rate: 1.5
    )
  end

  let(:params) { { transfer_id: transfer_ext_id, status: status } }
  let(:transfer_ext_id) { SecureRandom.uuid }

  context 'when status is succeeded' do
    let(:status) { 'succeeded' }

    it 'changes balances and transfer status' do
      expect { subject }
        .to change { sender.reload.balance_cents }.by(-100_00)
        .and change { receiver.reload.balance_cents }.by(150_00)
        .and change { transfer.reload.status }.from('pending').to('succeeded')

      expect(response.status).to eq 200
    end
  end

  context 'when status is failed' do
    let(:status) { 'failed' }

    it 'does not changes balances and changes transfer status' do
      expect { subject }
        .to change { sender.reload.pending_balance_cents }.by(100_00)
        .and change { transfer.reload.status }.from('pending').to('failed')

      expect(sender.balance_cents).to eq 100_00
      expect(receiver.reload.balance_cents).to eq 0

      expect(response.status).to eq 200
    end
  end
end
