# frozen_string_literal: true

class SendgridMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def test(email, subject, message)
    from = Email.new(email: 'fund6@ltv.fund')
    to = Email.new(email: email)
    subject = subject
    content = Content.new(type: 'text/plain', value: message)
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end
