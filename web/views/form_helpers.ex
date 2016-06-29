defmodule Academy.FormHelpers do
  @moduledoc """
  Conveniences for HTML forms.
  """

  use Phoenix.HTML

  @doc ~S"""
  Build an input group. Usefull to have the class "invalid" in the div when
  a field in the changeset is invalid.

  Example:

      input_group f, :name do
        label f, :name
      end

  might give:

  ```html
  <div class="input invalid">
    <input type="text" id="form_name" name="form[name]">
  </div>
  ```
  """
  def input_group(form, field, fun) do
    classes = "input"
    classes = classes <> if form.errors[field], do: " invalid", else: ""
    content_tag :div, [class: classes], fun
  end
end
