# frozen_string_literal: true

json.array! @invite_accepts, partial: 'invite_accepts/invite_accept', as: :invite_accept
