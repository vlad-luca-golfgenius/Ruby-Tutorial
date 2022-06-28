class ApplicationController < ActionController::Base
  def hello
    render html: "hello, world! \n ¡Hola, mundo!"
  end

  def goodbye
    render html: "GoodbyeΩΩ≈"
  end
end
