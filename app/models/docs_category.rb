# frozen_string_literal: true

class DocsCategory < ApplicationRecord
  has_many :docs
end
