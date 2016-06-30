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

    get "/",      UserController, :index
    get "/about", PageController, :about

    get  "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/logout", SessionController, :delete

    resources "/users", UserController, only: [:index, :show]

    get      "/account",      UserController, :show_self
    get      "/account/edit", UserController, :edit
    patch    "/account/edit", UserController, :update
    put      "/account/edit", UserController, :update
    delete   "/account/edit", UserController, :delete

    get  "/account/skills/edit", SkillLevelController, :edit
    post "/account/skills",      SkillLevelController, :update

    resources "/skills",          SkillController, except: [:show, :update, :create]
    post      "/skills/new",      SkillController, :create
    patch     "/skills/:id/edit", SkillController, :update
    put       "/skills/:id/edit", SkillController, :update

    resources "/skill_categories",          SkillCategoryController, only: [:edit, :new, :delete]
    post      "/skill_categories/new",      SkillCategoryController, :create
    patch     "/skill_categories/:id/edit", SkillCategoryController, :update
    put       "/skill_categories/:id/edit", SkillCategoryController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", Academy do
  #   pipe_through :api
  # end
end
