defmodule Academy.Router do
  use Academy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Academy do
    pipe_through [:browser, :browser_auth]

    get "/",      PageController, :index
    get "/about", PageController, :about

    get  "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/logout", SessionController, :delete

    resources "/users", UserController, except: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Academy do
  #   pipe_through :api
  # end
end
