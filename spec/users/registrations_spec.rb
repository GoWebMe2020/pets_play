require 'rails_helper'

describe "Registrations Controller", type: :request do
  describe "POST #create" do
    context "Does not create a new user" do
      it "if the password and password confirnmation are incorrect" do
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

  describe "PATCH #update" do
    context "If the user is logged in" do
      it "updates the user details" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        patch "/registrations/#{user.id}", :params => {
          user: {
            email: "new_test@mail.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq("updated")
        expect(response_data["user_logged_in"]).to be(true)
        expect(response_data["user"]["email"]).to eq("new_test@mail.com")
      end
    end

    context "Does not update a user" do
      it "if the user is not logged in" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        patch "/registrations/#{user.id}", :params => {
          user: {
            email: "new_test@mail.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }

        response_data = JSON.parse(response.body)
        expect(response_data["status"]).to eq(500)

        unchanged_user = User.find(user.id)
        expect(unchanged_user.email).to eq("test@mail.com")
      end

      it "if the password and password confirnmation are incorrect" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        patch "/registrations/#{user.id}", :params => {
          user: {
            email: "new_test@mail.com",
            password: "123456",
            password_confirmation: "123457"
          }
        }

        response_data = JSON.parse(response.body)
        expect(response_data["status"]).to eq(500)

        unchanged_user = User.find(user.id)
        expect(unchanged_user.email).to eq("test@mail.com")
      end
    end
  end

  describe "DELETE #destory" do
    context "It deletes a user" do
      it "if they are logged in" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        delete "/registrations/#{user.id}"

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq("destroyed")
        expect(response_data["user_logged_in"]).to be(false)
        expect(response_data["user"]).to be(nil)

        expect(User.count).to be(0)
        expect(User.first).to be(nil)
      end

      it "if the user has pets" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")
        pet_1 = Pet.create!(name: "Flower", breed: "Samoyed", sex: "Male", size: "Medium", birthday: DateTime.new(2015, 11, 22), user_id: user.id)
        pet_2 = Pet.create!(name: "Leaf", breed: "Samoyed", sex: "Female", size: "Medium", birthday: DateTime.new(2015, 11, 22), user_id: user.id)

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        delete "/registrations/#{user.id}"

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq("destroyed")
        expect(User.count).to be(0)
        expect(Pet.count).to be(0)
      end
    end

    context "Does not delete a user" do
      it "if they are not logged in" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        delete "/registrations/#{user.id}"

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq(500)

        expect(User.count).to be(1)
        expect(User.first).to eq(user)
      end
    end
  end
end
