defmodule Academy.Avatar do
  @moduledoc ~S"""
  Handle the avatar uploads.

  This uses both the "arc" and "arc_ecto" dependencies. The "arc" dependency is
  the baseline of this object (validation, defaults, etc...). The "arc_ecto"
  dependency is used to be able to integrate that to our database model (in this
  case the `Academy.User` model, by integrating the `Academy.Avatar.Type` in our
  schema and adding `cast_attachments/3` to `Academy.User.changeset/2`.
  """

  @doc ~S"""
  Overriden function to get the url of a user's avatar.
  """
  def url(file, version, options) do
    # Drop the absolute path
    url = Arc.Actions.Url.url(__MODULE__, file, version, options)
          |> Path.split
          |> Enum.take(-3)

    url = Path.join ["/" | url]
  end

  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  @acl :public_read

  @versions [:original]

  @doc ~S"""
  Always returns `Arc.Storage.Local` to specify local storage only.
  """
  def __storage, do: Arc.Storage.Local

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  @doc ~S"""
  Whitelist file extensions

  In this case, only .jpg, .jpeg, .gif, .png files are allowed.
  """
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  @doc ~S"""
  Override the persisted filenames

  This returns the user id, because we want the user id to be the filename.
  """
  def filename(_version, {_file, user}) do
    "#{user.id}"
  end

  @doc ~S"""
  Override the storage directory

  The storage of the avatars are in the "priv/static/images/avatar" directory
  and will be served by phoenix as the "/images/avatar" URI.
  """
  def storage_dir(_version, _file_and_scope) do
    Path.join [
      :code.priv_dir(:academy),
      "static",
      "images",
      "avatars"
    ]
  end

  @doc ~S"""
  Provide a default URL if there hasn't been a file uploaded

  The storage of the default avatar are the same as any avatar. The default
  avatar is created in the `Academy.UserController.create/1` function.
  """
  def default_url(_version, user) do
    "/images/avatars/#{user.id}.png"
  end

end
