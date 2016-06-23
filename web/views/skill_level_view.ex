defmodule Academy.SkillLevelView do
  use Academy.Web, :view

  use Phoenix.HTML

  def get_skill_level(user, skill) do
    case Academy.SkillLevelController.find_skill_level(user, skill.id) do
      nil -> 0
      skill_level -> skill_level.level
    end
  end

  def rating_input(user, skill) do
    {:safe,
      "<input id=\"skill_#{skill.id}\" max=\"5\" min=\"0\" name=\"skill_levels[skill_#{skill.id}]\" type=\"number\" value=\"#{get_skill_level(user, skill)}\">"}
  end

  def rating_label(skill) do
    content_tag :label, skill.name, for: "skill_#{skill.id}"
  end

end
