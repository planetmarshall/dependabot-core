# typed: false
# frozen_string_literal: true

require "spec_helper"
require "dependabot/conan/conan_cli"

RSpec.describe Dependabot::Conan::ConanCli do
  subject(:conan_cli) { described_class.new }

  describe "graph_info" do
    context "when the command is executed" do
      it "returns successfully" do
        conanfile = Dependabot::DependencyFile.new(
          name: "conanfile.txt",
          content: fixture("projects", "basic_conanfile_txt", "conanfile.txt")
        )
        expect(conan_cli.graph_info(conanfile)).to be_a(Hash)
      end
    end
  end
end
