# frozen_string_literal: true

module BillingsHelper
  def boolean_to_yes_no(boolean)
    boolean ? 'yes' : 'no'
  end

  def text_color_from_boolean(boolean)
    boolean ? 'bg-info' : 'bg-secondary'
  end
end
