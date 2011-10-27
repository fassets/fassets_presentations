class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
end
