# app/controllers/contacts_controller.rb

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  # ...
end
