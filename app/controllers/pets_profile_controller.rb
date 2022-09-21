class PetsProfileController < ApplicationController
  include CurrentUserConcern

  def create
    pet = Pet.create!(pet_params) if unique_pet_name(pet_params[:name])

    if pet
      render json: {
        status: :created,
        pet: pet
      }
    else
      render json: { status: 500 }
    end
  end

  def update
    pet = Pet.find(params["id"])

    if pet.update(pet_params)
      render json: {
        status: :updated,
        pet: pet
      }
    else
      render json: { status: 500 }
    end
  end

  def destroy
    pet = Pet.find(params["id"])

    if pet.destroy
      render json: {
        status: :destroyed,
        pet: nil
      }
    else
      render json: { status: 500 }
    end
  end

  private

  def pet_params
    {
      name: params["pet"]["name"],
      breed: params["pet"]["breed"],
      sex: params["pet"]["sex"],
      size: params["pet"]["size"],
      birthday: params["pet"]["birthday"],
      user_id: params["pet"]["user_id"]
    }
  end

  def unique_pet_name(new_pet_name)
    current_pet_name = [].push(new_pet_name)
    @current_user.pets.each do |pet|
      current_pet_name << pet.name
    end
    return current_pet_name == current_pet_name.uniq
  end
end
