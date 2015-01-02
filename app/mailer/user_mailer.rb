class UserMailer < ActionMailer::Base

  def signup(user, base_url)
    @user = user
    @base_url = base_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail to: @user.email, subject: I18n.t('user_mailer.signup.welcome')
    end
  end

end
