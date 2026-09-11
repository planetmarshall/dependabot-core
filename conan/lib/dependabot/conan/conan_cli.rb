# typed: true
# frozen_string_literal: true

require "dependabot/errors"
require "dependabot/shared_helpers"
require "dependabot/dependency_file"

module Dependabot
  module Conan
    class ConanCli
      extend T::Sig

      sig { params(manifest_file: Dependabot::DependencyFile).returns(T::Hash[String, String]) }
      def graph_info(manifest_file)
        SharedHelpers.in_a_temporary_directory do
          write_temporary_dependency_files([manifest_file])
          command = "conan graph info --format=json #{File.join(Dir.pwd, manifest_file.name)}"
          Dependabot.logger.info("Running conan command: #{command}")
          stdout, stderr, return_code = Open3.capture3(command)
          raise DependabotError.new("Error running '#{command}': #{stderr}") if return_code != 0

          JSON.parse(stdout)
        end
      end

      sig { params(dependency_files: T::Array[Dependabot::DependencyFile]).void }
      def write_temporary_dependency_files(dependency_files)
        dependency_files
          .each do |file|
          path = file.name
          FileUtils.mkdir_p(Pathname.new(path).dirname)
          File.write(path, file.content)
        end
      end
    end
  end
end
