require 'rails_helper'

RSpec.describe "Home", type: :request do
  # Use HTTPS for all request specs since force_ssl is enabled
  before do
    host! "care.lvh.me:3001"
  end

  describe "GET /" do
    it "returns http success" do
      get root_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get root_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response).to render_template(:index)
    end

    it "contains welcome message" do
      get root_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response.body).to include("Welcome to Our Website")
    end
  end

  describe "GET /about" do
    it "returns http success" do
      get about_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response).to have_http_status(:success)
    end

    it "renders the about template" do
      get about_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response).to render_template(:about)
    end

    it "contains about page content" do
      get about_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response.body).to include("About Us")
      expect(response.body).to include("Our Story")
    end
  end

  describe "GET /contact" do
    it "returns http success" do
      get contact_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response).to have_http_status(:success)
    end

    it "renders the contact template" do
      get contact_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response).to render_template(:contact)
    end

    it "contains contact form" do
      get contact_path, headers: { 'X-Forwarded-Proto' => 'https' }
      expect(response.body).to include("Contact Us")
      expect(response.body).to include("Send us a Message")
    end
  end

  describe "POST /contact" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          name: "John Doe",
          email: "john@example.com",
          subject: "Test Subject",
          message: "Test message"
        }
      end

      it "redirects to contact page" do
        post contact_path, params: valid_params, headers: { 'Content-Type' => 'application/x-www-form-urlencoded', 'X-Forwarded-Proto' => 'https' }
        expect(response).to redirect_to(contact_path)
      end

      it "sets success flash message" do
        post contact_path, params: valid_params, headers: { 'Content-Type' => 'application/x-www-form-urlencoded', 'X-Forwarded-Proto' => 'https' }
        expect(flash[:success]).to eq("Thank you for your message! We'll get back to you soon.")
      end
    end

    context "with empty form" do
      it "still processes the request" do
        post contact_path, params: {}, headers: { 'Content-Type' => 'application/x-www-form-urlencoded', 'X-Forwarded-Proto' => 'https' }
        expect(response).to redirect_to(contact_path)
      end
    end
  end
end
