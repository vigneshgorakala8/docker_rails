class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
    if request.post?
      # Handle form submission with strong parameters
      contact_params = params.permit(:name, :email, :subject, :message)
      @name = contact_params[:name]
      @email = contact_params[:email]
      @subject = contact_params[:subject]
      @message = contact_params[:message]

      # Here you would typically send an email or save to database
      # For now, we'll just show a success message
      flash[:success] = "Thank you for your message! We'll get back to you soon."
      redirect_to contact_path
    end
  end
end
