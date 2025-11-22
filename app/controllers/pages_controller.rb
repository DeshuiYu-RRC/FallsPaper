class PagesController < ApplicationController
  def about
  end

  def contact
  end

  def send_contact
    # In a real application, you would send an email here
    flash[:notice] = "Thank you for your message. We will get back to you soon."
    redirect_to contact_path
  end
end
