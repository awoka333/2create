class HomesController < ApplicationController
  def top
    @lastworks = Work.limit(3).order('id')
  end

  def about
    @lastworks = Work.limit(2).order('id DESC')
  end
end
