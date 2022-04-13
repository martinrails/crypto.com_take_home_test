class CryptoWallet
  def initialize amount
    @balance = amount
  end

  def check
    @balance
  end

  def deposit amount
    @balance += amount unless amount.negative?
  end

  def withdraw amount
    if amount > @balance || amount.negative?
      false
    else
      @balance -= amount
    end
  end

  def send_money amount, wallet
    if withdraw(amount)
      wallet.deposit(amount)
    else
      false
    end
  end
end
