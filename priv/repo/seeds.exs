# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Academy.Repo.insert!(%Academy.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Academy.Repo

alias Academy.SkillCategory
alias Academy.Skill

programming_category    = Repo.insert! %SkillCategory{name: "Programming Languages"}
networking_category     = Repo.insert! %SkillCategory{name: "Networking"}
frameworks_category     = Repo.insert! %SkillCategory{name: "Frameworks & CMS"}
administration_category = Repo.insert! %SkillCategory{name: "Administration"}
web_category            = Repo.insert! %SkillCategory{name: "Web"}
electronic_category     = Repo.insert! %SkillCategory{name: "Electronic"}
hardware_category       = Repo.insert! %SkillCategory{name: "Hardware"}

# =================
# == Programming ==
# =================

Repo.insert! %Skill{
    name: "C",
    description: "The emblematic low-level language",
    category_id: programming_category.id
  }

Repo.insert! %Skill{
    name: "C++",
    description: "A low-level object oriented language",
    category_id: programming_category.id
  }

Repo.insert! %Skill{
    name: "Java",
    description: "A high-level object oriented language",
    category_id: programming_category.id
  }

Repo.insert! %Skill{
    name: "Python",
    description: "A simple, high-level, dynamic language",
    category_id: programming_category.id
  }

Repo.insert! %Skill{
    name: "Elixir",
    description: "A functional, concurrent language",
    category_id: programming_category.id
  }

Repo.insert! %Skill{
    name: "OpenGL",
    description: "Graphical, cross-language programming interface",
    category_id: programming_category.id
  }

# ================
# == Networking ==
# ================

Repo.insert! %Skill{
    name: "NAT",
    description: "Network-Address-Translation",
    category_id: networking_category.id
  }

Repo.insert! %Skill{
    name: "TCP",
    description: "Transport-Control-Protocol",
    category_id: networking_category.id
  }

Repo.insert! %Skill{
    name: "IPv4",
    description: "Knowledge of IPv4 functionning",
    category_id: networking_category.id
  }

Repo.insert! %Skill{
    name: "DNS",
    description: "Domain-Name-system",
    category_id: networking_category.id
  }

Repo.insert! %Skill{
    name: "Reverse-Proxy",
    description: "Implementation of a reverse proxy",
    category_id: networking_category.id
  }

# ================
# == Frameworks ==
# ================

Repo.insert! %Skill{
    name: "Symphony",
    description: "A PHP web framework around the MVC model",
    category_id: frameworks_category.id
  }

Repo.insert! %Skill{
    name: "Wordpress",
    description: "A CMS based on PHP and MySQL",
    category_id: frameworks_category.id
  }

Repo.insert! %Skill{
    name: "Phoenix",
    description: "A productive web framework using Elixir",
    category_id: frameworks_category.id
  }

# ====================
# == Administration ==
# ====================

Repo.insert! %Skill{
    name: "GNU/Linux",
    description: "A POSIX compliant operating system.",
    category_id: administration_category.id
  }

Repo.insert! %Skill{
    name: "Debian / Ubuntu",
    description: "A Linux distribution",
    category_id: administration_category.id
  }

Repo.insert! %Skill{
    name: "RedHat / CentOS",
    description: "A Linux distribution",
    category_id: administration_category.id
  }

Repo.insert! %Skill{
    name: "Systemd",
    description: "A Linux init system",
    category_id: administration_category.id
  }

Repo.insert! %Skill{
    name: "System V",
    description: "A Linux init system",
    category_id: administration_category.id
  }

Repo.insert! %Skill{
    name: "Virtualization",
    description: "Create virtual operating system runtimes",
    category_id: administration_category.id
  }

# =========
# == Web ==
# =========

Repo.insert! %Skill{
    name: "HTML5",
    description: "HyperText Markup Language",
    category_id: web_category.id
  }

Repo.insert! %Skill{
    name: "CSS3",
    description: "Cascade Style Sheets",
    category_id: web_category.id
  }

Repo.insert! %Skill{
    name: "SVG",
    description: "Scalable Vector Graphics",
    category_id: web_category.id
  }

# ================
# == Electronic ==
# ================

Repo.insert! %Skill{
    name: "VHDL / Verilog",
    description: "Hardware description language",
    category_id: electronic_category.id
  }

Repo.insert! %Skill{
    name: "Arduino",
    description: "Open-Source microcontroller",
    category_id: electronic_category.id
  }

Repo.insert! %Skill{
    name: "PIC",
    description: "Embedded system microcontroller",
    category_id: electronic_category.id
  }

# ==============
# == Hardware ==
# ==============

Repo.insert! %Skill{
    name: "Processors",
    description: "Processors",
    category_id: hardware_category.id
  }

Repo.insert! %Skill{
    name: "Graphic Cards",
    description: "Graphic cards",
    category_id: hardware_category.id
  }

Repo.insert! %Skill{
    name: "Motherboards",
    description: "Motherboards",
    category_id: hardware_category.id
  }
