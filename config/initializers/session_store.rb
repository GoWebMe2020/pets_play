if Rails.env == "production"
  Rails.application.config.session_store :cookie_store, key: "_pets_play", domain: "some_domain_name_with_react.com"
else
  Rails.application.config.session_store :cookie_store, key: "_pets_play"
end
