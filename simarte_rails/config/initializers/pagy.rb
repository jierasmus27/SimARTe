# frozen_string_literal: true

# Pagy core is required in config/application.rb before controllers load.

Pagy::OPTIONS[:limit] = 25
Pagy::OPTIONS.freeze
