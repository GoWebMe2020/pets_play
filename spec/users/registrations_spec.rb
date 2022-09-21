require 'rails_helper'

describe "Registrations Controller", type: :request do
  describe "POST #create" do
    before(:each) do
      p "This is before each test"
    end
    context "Does not create a new user" do
      it "if the password and password confirnmation is incorrect" do
        expect{
          post "/registrations", :params => {
            user: {
              email: "test@mail.com",
              password: "123456",
              password_confirmation: "123457"
            }
          }
        }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password confirmation doesn't match Password")
      end

      it "if the email already exists" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        expect{
          post "/registrations", :params => {
            user: {
              email: "test@mail.com",
              password: "123456",
              password_confirmation: "123456"
            }
          }
        }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has already been taken")
      end
    end


    context "Does create a new user" do
      it "if the email is unique and password and password_confirmation match" do
        post "/registrations", :params => {
          user: {
            email: "test@mail.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq("created")
        expect(response_data["user_logged_in"]).to be(true)
        expect(response_data["user"]["email"]).to eq("test@mail.com")
      end
    end

  end
end
