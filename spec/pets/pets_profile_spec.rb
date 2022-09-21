require 'rails_helper'

describe "Pets Profile Controller", type: :request do
  describe "POST #create" do
    context "Creates a pet" do
      it "if the user is logged in and passes the necessary information" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        post "/pets_profile", params: {
          pet: {
            name: "Flower",
            breed: "Samoyed",
            sex: "Male",
            size: "Medium",
            birthday: DateTime.new(2015, 11, 22),
            user_id: user.id
          }
        }

        response_data = JSON.parse(response.body)

        pet = Pet.first

        expect(response_data["status"]).to eq("created")
        expect(response_data["pet"]["name"]).to eq(pet.name)
        expect(response_data["pet"]["breed"]).to eq(pet.breed)
        expect(response_data["pet"]["sex"]).to eq(pet.sex)
        expect(response_data["pet"]["size"]).to eq(pet.size)
        expect(response_data["pet"]["user_id"]).to eq(user.id)
      end

      it "allows the user to have more than one pet" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        pet = Pet.create!(name: "Flower", breed: "Samoyed", sex: "Male", size: "Medium", birthday: DateTime.new(2015, 11, 22), user_id: user.id)

        post "/pets_profile", params: {
          pet: {
            name: "Spikey",
            breed: "Samoyed",
            sex: "Female",
            size: "Medium",
            birthday: DateTime.new(2015, 11, 22),
            user_id: user.id
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq("created")
        expect(response_data["pet"]["name"]).to eq("Spikey")
        expect(response_data["pet"]["breed"]).to eq("Samoyed")
        expect(response_data["pet"]["sex"]).to eq("Female")
        expect(response_data["pet"]["size"]).to eq("Medium")
        expect(response_data["pet"]["user_id"]).to eq(user.id)
        expect(user.pets.count).to be(2)
      end
    end

    context "Does not create a pet" do
      it "if a pet already exists with the same name" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")

        post "/sessions", :params => {
          user: {
            email: "test@mail.com",
            password: "123456"
          }
        }

        pet = Pet.create!(name: "Flower", breed: "Samoyed", sex: "Male", size: "Medium", birthday: DateTime.new(2015, 11, 22), user_id: user.id)

        post "/pets_profile", params: {
          pet: {
            name: "Flower",
            breed: "Samoyed",
            sex: "Female",
            size: "Medium",
            birthday: DateTime.new(2015, 11, 22),
            user_id: user.id
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["status"]).to eq(500)
      end
    end
  end

  describe "PATCH #update" do
    context "Updates the pet" do
      it "If the pet belongs to the user and the correct details are passed" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")
        pet = Pet.create!(name: "Flower", breed: "Samoyed", sex: "Male", size: "Medium", birthday: DateTime.new(2015, 11, 22), user_id: user.id)

        patch "/pets_profile/#{pet.id}", params: {
          pet: {
            name: "Snowy",
            breed: "Samoyed",
            sex: "Male",
            size: "Medium",
            birthday: DateTime.new(2015, 11, 22),
            user_id: user.id
          }
        }

        response_data = JSON.parse(response.body)

        expect(response_data["pet"]["name"]).to_not eq(pet.name)
        expect(response_data["pet"]["name"]).to eq("Snowy")
        expect(response_data["pet"]["breed"]).to eq(pet.breed)
        expect(response_data["pet"]["sex"]).to eq(pet.sex)
        expect(response_data["pet"]["size"]).to eq(pet.size)
        expect(response_data["pet"]["user_id"]).to eq(user.id)
        expect(Pet.count).to be(1)
      end
    end
  end

  describe "DELETE #destroy" do
    context "Deletes a pet" do
      it "if it belongs to the user" do
        user = User.create!(email: "test@mail.com", password: "123456", password_confirmation: "123456")
        pet = Pet.create!(name: "Flower", breed: "Samoyed", sex: "Male", size: "Medium", birthday: DateTime.new(2015, 11, 22), user_id: user.id)

        delete "/pets_profile/#{pet.id}"

        response_data = JSON.parse(response.body)

        expect(Pet.count).to be(0)
        expect(Pet.first).to be(nil)
      end
    end
  end
end
