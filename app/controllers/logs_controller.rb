# -*- encoding : utf-8 -*-
class LogsController < ApplicationController

  def index
    @logs = Log.all.order('created_at DESC')
  end

end
