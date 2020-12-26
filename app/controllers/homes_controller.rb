class HomesController < ApplicationController
  def top
    @lastworks = Work.last(3).order('id')
  end

  def about
    @lastworks = Work.first(2).order('id DESC')
  end
end
