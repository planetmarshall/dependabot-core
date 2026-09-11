# frozen_string_literal: true

module Dependabot
  module Conan
    class ConanCli
      extend T::Sig

      sig { params(manifest_file: Dependabot::DependencyFile).returns(T::Hash[String, String]) }
      def graph_info(manifest_file)
        command = "conan graph info --format=json #{manifest_file.path}"
        stdout, stderr, status = Open3.capture3(command)

        JSON.parse(stdout)
      end
    end
  end
end
