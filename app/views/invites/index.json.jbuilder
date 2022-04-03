# frozen_string_literal: true

json.array! @invites, partial: 'invites/invite', as: :invite
