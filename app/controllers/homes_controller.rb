class HomesController < ApplicationController
  def top
    @lastworks = Work.order(created_at: :desc).limit(3)
  end

  def about
    @firstworks = Work.order('created_at').limit(2)
  end
end
