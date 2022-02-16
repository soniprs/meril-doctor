module BxBlockLogin
  class DoctorAdapter
    include Wisper::Publisher

    def login_account(account_params)
      byebug
        email = account_params.email.downcase

        account = AccountBlock::Doctor
          .where('LOWER(email) = ?', email)
          .where(:activated => true)
          .first

      unless account.present?
        broadcast(:account_not_found)
        return
      end
      
      if account.pin.to_i == account_params.pin.to_i
        token, refresh_token = generate_tokens(account.id)
        broadcast(:successful_login, account, token, refresh_token)
      else
        broadcast(:failed_login)
      end
    end

    def generate_tokens(account_id)
      [
        BuilderJsonWebToken.encode(account_id, 1.day.from_now, token_type: 'login'),
        BuilderJsonWebToken.encode(account_id, 1.year.from_now, token_type: 'refresh')
      ]
    end
  end
end
