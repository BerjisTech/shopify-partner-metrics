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

  def deregister_email(from, to, subject, user, group)
    @user = user
    @group = group
    headers['X-MJ-CustomID'] = 'custom value'
    headers['X-MJ-EventPayload'] = 'custom payload'

    send(from, to, subject, headers)
  end

  def new_group_email(from, to, subject, user, group)
    @user = user
    @group = group

    headers['X-MJ-CustomID'] = 'custom value'
    headers['X-MJ-EventPayload'] = 'custom payload'

    send(from, to, subject, headers)
  end

  def new_approval_email(from, to, subject, user, loan)
    @user = user
    @loan = loan
    headers['X-MJ-CustomID'] = 'custom value'
    headers['X-MJ-EventPayload'] = 'custom payload'

    send(from, to, subject, headers)
  end

  def loan_approved_email(from, to, subject, user, loan)
    @user = user
    @loan = loan
    headers['X-MJ-CustomID'] = 'custom value'
    headers['X-MJ-EventPayload'] = 'custom payload'

    send(from, to, subject, headers)
  end

  def send(from, to, subject, headers)
    mail(
      from: from,
      to: to,
      subject: subject,
      headers: headers
    )
  end
end
