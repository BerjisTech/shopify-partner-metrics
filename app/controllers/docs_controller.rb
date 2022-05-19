# frozen_string_literal: true

class DocsController < ApplicationController
  def big_dicky; end

  def doc
    @doc = Doc.find(params[:id])
    requests = @doc.requests.present? ? @doc.requests : 0
    @doc.update(requests: requests + 1)
  end
end
