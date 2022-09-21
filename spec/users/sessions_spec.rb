require 'rails_helper'

describe "Sessions Controller", type: :request do
  describe "POST #create" do

    context "Does create a session" do
      it "if the user provides the correct login details" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq("created")
        expect(response_data["user_logged_in"]).to be(true)
        expect(response_data["user"]["email"]).to eq("test@mail.com")
      end
    end

    context "Does not create a session" do
      it "if the user provides the incorrect email" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "wrong@mail.com",
            password: "123456"
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq(401)
      end

      it "if the user provides the incorrect password" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123457"
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq(401)
      end
    end
  end

  describe "GET #logged_in" do
    context "If a user is logged in" do
      it "the user data is available" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        get "/logged_in"

        response_data = JSON.parse(response.body)

        expect(response_data["user_logged_in"]).to be_truthy
        expect(response_data["user"]["email"]).to eq("test@mail.com")
      end
    end

    context "If a user is not logged in" do
      it "the user data will not be available" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        get "/logged_in"

        response_data = JSON.parse(response.body)

        expect(response_data["user_logged_in"]).to be_falsey
      end
    end
  end

  describe "DELETE #logout" do
    context "If a user is logged in" do
      it "can log a user out" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        get "/logged_in"

        logged_in_response = JSON.parse(response.body)

        expect(logged_in_response["user_logged_in"]).to be_truthy
        expect(logged_in_response["user"]["email"]).to eq("test@mail.com")

        delete "/logout"

        get "/logged_in"

        logout_response = JSON.parse(response.body)

        expect(logout_response["user_logged_in"]).to be_falsey
      end
    end
  end
end
