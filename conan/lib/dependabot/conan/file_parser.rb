# typed: strict
# frozen_string_literal: true

require "dependabot/dependency"
require "dependabot/file_parsers"
require "dependabot/file_parsers/base"
require "dependabot/conan/conan_cli"

module Dependabot
  module Conan
    class FileParser < Dependabot::FileParsers::Base
      extend T::Sig

      sig do
        params(
          dependency_files: T::Array[Dependabot::DependencyFile],
          source: T.nilable(Dependabot::Source),
          repo_contents_path: T.nilable(String),
          credentials: T::Array[Dependabot::Credential],
          reject_external_code: T::Boolean,
          options: T::Hash[Symbol, T.untyped],
          conan_cli: Dependabot::Conan::ConanCli
        ).void
      end
      def initialize(
        dependency_files:,
        source: nil,
        repo_contents_path: nil,
        credentials: [],
        reject_external_code: false,
        options: {},
        conan_cli: Dependabot::Conan::ConanCli.new
      )
        super(
          dependency_files: dependency_files,
          source: source,
          repo_contents_path: repo_contents_path,
          credentials: credentials,
          reject_external_code: reject_external_code,
          options: options)
        @conan_cli = conan_cli
      end

      sig { override.returns(T::Array[Dependabot::Dependency]) }
      def parse
        # We don't really parse a manifest file. We call
        # [conan graph info](https://docs.conan.io/2/reference/commands/graph/info.html)
        # to generate the dependency graph,
        # then extract the dependencies from it.
        graph = @conan_cli.graph_info(dependency_files.first)
        nodes = graph["graph"]["nodes"]
        root = nodes["0"]

        dependencies = root["dependencies"]
        dependencies.map do |dep_id, dep|
          ref = nodes[dep_id]
          requirements = []
          if dep["direct"]
            requirements << {
              requirement: ref["version"],
              groups: ["direct", ref["context"]],
              source: {
                url: ref["homepage"]
              },
              file: root["label"]
            }
          end
          Dependabot::Dependency.new(
            name: ref["name"],
            version: ref["version"],
            package_manager: "conan",
            requirements: requirements
          )
        end
      end

      private

      sig { override.void }
      def check_required_files
        raise "No conanfile found!" unless conanfile
      end

      sig { returns(T.nilable(Dependabot::DependencyFile)) }
      def conanfile
        @conanfile ||= T.let(get_original_file("conanfile.txt") || get_original_file("conanfile.py"), T.nilable(Dependabot::DependencyFile))
      end
    end
  end
end

Dependabot::FileParsers.register("conan", Dependabot::Conan::FileParser)
