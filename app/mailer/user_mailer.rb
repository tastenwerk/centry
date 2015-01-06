class UserMailer < ActionMailer::Base

  def signup(user, base_url)
    @user = user
    @base_url = base_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail(to: @user.email, subject: I18n.t('user_mailer.signup.subject', site_name: Centry.config.site.name)).tap do |email|
        Centry::Mailer.transform( email )
      end
    end
  end

  def reset_password(user, base_url)
    @user = user
    @base_url = base_url
    I18n.with_locale(@user.locale || I18n.locale) do
      mail(to: @user.email, subject: I18n.t('user_mailer.reset_pwd.subject', site_name: Centry.config.site.name)).tap do |email|
        Centry::Mailer.transform( email )
      end
    end
  end

end
