# frozen_string_literal: true

class UserNotifierMailer < ApplicationMailer
  def welcome_email(from, to, subject, user)
    headers['X-MJ-CustomID'] = 'custom value'
    headers['X-MJ-EventPayload'] = 'custom payload'

    @user = user

    send(from, to, subject, headers)
  end

  def invite_email(from, to, subject, user, group)
    @user = user
    @group = group
    headers['X-MJ-CustomID'] = 'custom value'
    headers['X-MJ-EventPayload'] = 'custom payload'

    send(from, to, subject, headers)
  end

  def send(from, to, subject, headers)
    @resource = User
    @token = ''
    mail(
      from: from,
      to: to,
      subject: subject,
      headers: headers
    )
  end
end
