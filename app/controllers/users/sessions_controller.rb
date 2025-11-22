class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      resource.record_login(request.remote_ip) if resource.persisted?
    end
  end
end
