# typed: strict
# frozen_string_literal: true

require "dependabot/file_fetchers"
require "dependabot/file_fetchers/base"

module Dependabot
  module Conan
    class FileFetcher < Dependabot::FileFetchers::Base
      extend T::Sig

      sig { override.returns(String) }
      def self.required_files_message
        "Repo must contain either a conanfile.txt, or a conanfile.py file."
      end

      sig { override.params(filenames: T::Array[String]).returns(T::Boolean) }
      def self.required_files_in?(filenames)
        filenames.include? "conanfile.txt"
      end

      sig { override.returns(T::Array[DependencyFile]) }
      def fetch_files
        # Implement beta feature flag check
        #unless allow_beta_ecosystems?
        #  raise Dependabot::DependencyFileNotFound.new(
        #    nil,
        #    "Conan support is currently in beta. Set ALLOW_BETA_ECOSYSTEMS=true to enable it."
        #  )
        #end

        fetched_files = [
          conanfile
        ].compact

        return fetched_files if fetched_files.any?

        raise Dependabot::DependencyFileNotFound.new(nil, self.class.required_files_message)
      end

      sig { override.returns(T.nilable(T::Hash[Symbol, T.untyped])) }
      def ecosystem_versions
        # TODO: Return supported ecosystem versions
        # Example: { package_managers: { "conan" => "1.0.0" } }
        nil
      end

      private

      def conanfile = fetch_file_if_present("conanfile.txt")
    end
  end
end

Dependabot::FileFetchers.register("conan", Dependabot::Conan::FileFetcher)
