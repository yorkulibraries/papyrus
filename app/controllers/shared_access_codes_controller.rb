class SharedAccessCodesController < ApplicationController
  authorize_resource  User

  def index

  end

end
