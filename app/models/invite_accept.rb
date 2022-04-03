# frozen_string_literal: true

class InviteAccept < ApplicationRecord
    belongs_to :business
    belongs_to :user
end
