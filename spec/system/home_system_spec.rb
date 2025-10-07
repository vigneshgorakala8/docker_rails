require 'rails_helper'

RSpec.describe "Home System", type: :system do
  # Using Chrome driver configured in rails_helper.rb
  # Will use remote Selenium Chrome in Docker or local Chrome otherwise

  describe "Home page" do
    it "displays the welcome message and navigation" do
      visit root_path
      expect(page).to have_content("Welcome to Our Website")
      expect(page).to have_content("This is the home page of our Rails application")
      # Check navigation links
      expect(page).to have_link("Home")
      expect(page).to have_link("About")
      expect(page).to have_link("Contact")
      expect(page).to have_link("Docker Rails")
    end

    it "shows the features section" do
      visit root_path

      expect(page).to have_content("Features")
      expect(page).to have_content("Modern Design")
      expect(page).to have_content("Responsive")
      expect(page).to have_content("Fast & Secure")
    end

    it "has call-to-action buttons that work" do
      visit root_path

      expect(page).to have_link("About Us")
      expect(page).to have_link("Contact")

      # Test About Us link
      about_link = find('a', text: 'About Us')
      expect(about_link[:href]).to include('/about')
      about_link.click
      expect(page).to have_current_path(about_path, wait: 5)
      expect(page).to have_content("About Us")

      # Test Contact link
      visit root_path
      contact_link = find('a', text: 'Contact')
      expect(contact_link[:href]).to include('/contact')
      contact_link.click
      expect(page).to have_current_path(contact_path, wait: 5)
      expect(page).to have_content("Contact Us")
    end

    it "has active navigation highlighting" do
      visit root_path

      within(".navbar-nav") do
        expect(page).to have_css(".nav-link.active", text: "Home")
      end
    end
  end

  describe "About page" do
    it "displays company information" do
      visit about_path

      expect(page).to have_content("About Us")
      expect(page).to have_content("Learn more about our company")
      expect(page).to have_content("Our Story")
      expect(page).to have_content("Our Mission")
      expect(page).to have_content("Our Values")
    end

    it "shows the values list" do
      visit about_path

      expect(page).to have_content("Innovation and creativity")
      expect(page).to have_content("Quality and excellence")
      expect(page).to have_content("Customer satisfaction")
      expect(page).to have_content("Continuous learning")
    end

    it "has working contact link" do
      visit about_path

      find('a', text: 'Contact Us').click
      expect(page).to have_current_path(contact_path, wait: 5)
      expect(page).to have_content("Contact Us")
    end

    it "has proper navigation highlighting" do
      visit about_path

      within(".navbar-nav") do
        expect(page).to have_css(".nav-link.active", text: "About")
      end
    end
  end

  describe "Contact page" do
    it "displays contact form and information" do
      visit contact_path

      expect(page).to have_content("Contact Us")
      expect(page).to have_content("We'd love to hear from you")
      expect(page).to have_content("Send us a Message")
      expect(page).to have_content("Contact Information")
    end

    it "has all form fields" do
      visit contact_path

      expect(page).to have_field("Name")
      expect(page).to have_field("Email")
      expect(page).to have_field("Subject")
      expect(page).to have_field("Message")
      expect(page).to have_button("Send Message")
    end

    it "shows contact information" do
      visit contact_path

      expect(page).to have_content("123 Main Street")
      expect(page).to have_content("(555) 123-4567")
      expect(page).to have_content("info@example.com")
      expect(page).to have_content("Business Hours")
    end

    it "submits the contact form successfully" do
      visit contact_path

      fill_in "Name", with: "John Doe"
      fill_in "Email", with: "john@example.com"
      fill_in "Subject", with: "Test Subject"
      fill_in "Message", with: "This is a test message"

      click_button "Send Message"

      expect(page).to have_current_path(contact_path, wait: 5)
      expect(page).to have_content("Thank you for your message! We'll get back to you soon.", wait: 2)
    end



    it "has proper navigation highlighting" do
      visit contact_path

      within(".navbar-nav") do
        expect(page).to have_css(".nav-link.active", text: "Contact")
      end
    end
  end

  describe "Navigation flow" do
    it "allows user to navigate between all pages" do
      visit root_path

      # Start from home
      expect(page).to have_content("Welcome to Our Website")

      # Navigate to about
      find('.navbar-nav a', text: 'About').click
      expect(page).to have_current_path(about_path, wait: 5)
      expect(page).to have_content("About Us")

      # Navigate to contact
      find('.navbar-nav a', text: 'Contact').click
      expect(page).to have_current_path(contact_path, wait: 5)
      expect(page).to have_content("Contact Us")

      # Navigate back to home via brand link
      find('.brand-link', text: 'Docker Rails').click
      expect(page).to have_current_path(root_path, wait: 5)
      expect(page).to have_content("Welcome to Our Website")
    end

    it "maintains proper active states during navigation" do
      visit root_path
      within(".navbar-nav") do
        expect(page).to have_css(".nav-link.active", text: "Home")
      end

      find('.navbar-nav a', text: 'About').click
      within(".navbar-nav") do
        expect(page).to have_css(".nav-link.active", text: "About")
        expect(page).not_to have_css(".nav-link.active", text: "Home")
      end

      find('.navbar-nav a', text: 'Contact').click
      within(".navbar-nav") do
        expect(page).to have_css(".nav-link.active", text: "Contact")
        expect(page).not_to have_css(".nav-link.active", text: "About")
      end
    end
  end

  describe "Responsive design" do
    # Skip JavaScript-dependent tests in Docker without Chrome
    # These tests require a browser driver like Selenium Chrome

    it "displays basic content (rack_test compatible)" do
      visit root_path

      expect(page).to have_content("Welcome to Our Website")
      expect(page).to have_link("About Us")
      expect(page).to have_link("Contact")
      expect(page).to have_content("Features")
    end
  end
end
