require 'crypto_wallet'

RSpec.describe CryptoWallet do
  let(:wallet) { CryptoWallet.new amount }
  let(:amount) { 10 }

  describe '#deposit' do
    context 'when balance in the crypto wallet is zero' do
      let(:amount) { 0 }

      it 'adds the amount to the current balance' do
        wallet.deposit 5
        expect(wallet.check).to eq 5
      end

      it 'returns new balance' do
        expect(wallet.deposit(5)).to eq 5
      end
    end

    context 'when the balance in the wallet is above zero' do
      let(:amount) { 5 }

      it 'adds amount to the current balance' do
        wallet.deposit 5
        expect(wallet.check).to eq 10
      end

      it 'returns the new balance' do
        expect(wallet.deposit(5)).to eq 10
      end
    end

    context 'when amount deposited is negative' do
      let(:amount) { 5 }

      it 'does not change balance' do
        wallet.deposit (-10)
        expect(wallet.check).to eq 5
      end
    end
  end

  describe 'withdraw' do
    context 'when amount already in the wallet is higher than current balance' do
      let(:withdraw_amount) { 11 }

      it 'does not withdraw any money' do
        wallet.withdraw withdraw_amount
        expect(wallet.check).to eq amount
      end

      it 'it also notifies user that transaction failed' do
        expect(wallet.withdraw(withdraw_amount)).to eq(false)
      end
    end

    context 'when amount is lower than or equal to current balance' do
      let(:withdraw_amount) { 9 }

      it 'subtracts amount from current balance' do
        wallet.withdraw withdraw_amount
        expect(wallet.check).to eq 1
      end

      it 'returns the final balance' do
        expect(wallet.withdraw(withdraw_amount)).to eq 1
      end
    end

    context 'when amount withdrawn is negative' do
      let(:withdraw_amount) { -100 }

      it 'does not change balance' do
        wallet.withdraw withdraw_amount
        expect(wallet.check).to eq 10
      end
    end
  end

  describe '#send_money' do
    let(:other_wallet) { CryptoWallet.new other_amount }
    let(:other_amount) { 15 }

    context 'when amount sent to any other_wallet is higher than current balance' do
      let(:send_amount) { 100 }

      it 'does not send any money' do
        wallet.send_money(send_amount, other_wallet)

        expect(wallet.check).to eq amount
        expect(other_wallet.check).to eq other_amount
      end

      it 'notifies user that transaction failed' do
        expect(wallet.send_money(send_amount, other_wallet)).to eq(false)
      end
    end

    context 'when amount being sent is lower than the current balance' do
      let(:send_amount) { 9 }

      it 'subtracts the amount from current balance' do
        wallet.send_money(send_amount, other_wallet)
        expect(wallet.check).to eq 1
      end

      it 'adds amount to other user' do
        wallet.send_money(send_amount, other_wallet)
        expect(other_wallet.check).to eq 15 + send_amount
      end

      it 'returns final balance of receiver' do
        expect(wallet.send_money(send_amount, other_wallet)).to eq 15 + send_amount
      end
    end
  end

  describe '#check' do
    context 'when balance is zero' do
      let(:amount) { 0 }

      it 'returns zero' do
        expect(wallet.check).to eq 0
      end
    end

    context 'when balance is higher than zero' do
      it 'returns the correct balance' do
        expect(wallet.check).to eq 10
      end
    end
  end
end
