module BxBlockLogin
  class ProfileAdapter
    include Wisper::Publisher

    def login_account(account_params)
      case account_params.type
      when 'sms_account'
        phone = Phonelib.parse(account_params.full_phone_number).sanitized
        account = AccountBlock::Patient.find_by(full_phone_number: phone,activated: true)
      end

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
