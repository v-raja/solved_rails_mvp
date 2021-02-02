class InviteMailer < Devise::Mailer

  def invitation_instructions(record, token, opts={})
    @token = token
    @niche = record.niche
    devise_mail(record, record.invitation_instructions || :invitation_instructions, opts)
  end
  # record.invitation_instructions ||

  def confirmation_instructions(record, token, opts = {})
    @token = token
    @niche = record.niche
    devise_mail(record, record.confirmation_instructions || :confirmation_instructions, opts)
  end

end
