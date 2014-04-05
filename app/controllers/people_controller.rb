class PeopleController < ApplicationController
  respond_to :html

  # Show the main page of directory
  # TODO Use a static page for this
  def index
  end

  # when user came from the link given in email
  def confirm_deletion
    begin
      raise 'Follow the link given in the mail.' if key_params.empty?
      @person = Person.find_by(key_params)
      @person.desindex

      flash[:success] = 'You have correctly deleting your profile.'
    rescue Mongoid::Errors::DocumentNotFound
      flash[:warning] = 'This confirmation link doesn\'t exist.'
    rescue RuntimeError => e
      flash[:warning] = e.message
    end

    redirect_to root_url
  end

  private

  def key_params
    params.permit(:key)
  end
  
end
