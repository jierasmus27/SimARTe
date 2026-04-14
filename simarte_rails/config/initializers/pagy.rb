# frozen_string_literal: true

# Pagy core + overflow extra are required in config/application.rb before controllers load.

Pagy::DEFAULT[:limit] = 25
Pagy::DEFAULT[:overflow] = :last_page
