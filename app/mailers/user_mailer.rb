class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: t("mail_subj_activate")
  end
  def password_reset user
    @user = user
    mail to: user.email, subject: t("mail_subj_passrs")
  end
end
