class PagesController < ApplicationController
  def about
    @page = Page.find_by(slug: "about")
    render :show
  end

  def contact
    @page = Page.find_by(slug: "contact")
    render :show
  end

  def send_contact
    # Handle contact form submission
    flash[:notice] = "Thank you for your message. We will get back to you soon!"
    redirect_to contact_path
  end
end
