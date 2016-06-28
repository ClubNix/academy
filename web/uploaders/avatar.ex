defmodule Academy.Avatar do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  @acl :public_read

  @versions [:original]

  def __storage, do: Arc.Storage.Local

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  def filename(_version, {_file, user}) do
    "#{user.id}"
  end

  # Override the storage directory:
  def storage_dir(_version, _file_and_scope) do
    "priv/static/images/avatars/"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, user) do
    "priv/static/images/avatars/#{user.id}.png"
  end

end
