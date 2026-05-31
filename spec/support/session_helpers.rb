module SessionHelpers
  def sign_in_as(user)
    session = user.sessions.create!(remember_me: true, expires_at: Session::REMEMBER_ME_DURATION.from_now)
    Current.session = session

    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:session_id] = session.id
      cookies[:session_id] = cookie_jar[:session_id]
    end
  end

  def sign_out
    Current.session&.destroy!
    cookies.delete(:session_id)
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :request
end
