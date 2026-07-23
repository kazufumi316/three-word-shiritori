class ShiritoriController < ApplicationController
  before_action :authenticate_user!

  def index
    @turn = session[:turn]
    @last_word = session[:last_word]
    @used_words = session[:used_words]
  end
end
