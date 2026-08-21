# typed: strong
# frozen_string_literal: true

# These all need to be required so the various classes can be registered in a
# lookup table of package manager names to concrete classes.
require "dependabot/conan/file_fetcher"
require "dependabot/conan/file_parser"
require "dependabot/conan/update_checker"
require "dependabot/conan/file_updater"
require "dependabot/conan/metadata_finder"
require "dependabot/conan/version"
require "dependabot/conan/requirement"

require "dependabot/pull_request_creator/labeler"
Dependabot::PullRequestCreator::Labeler
  .register_label_details("conan", name: "conan", colour: "000000")

require "dependabot/dependency"
Dependabot::Dependency.register_production_check("conan", ->(_) { true })
