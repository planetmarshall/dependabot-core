# typed: false
# frozen_string_literal: true

require "spec_helper"
require "dependabot/dependency_file"
require "dependabot/conan/file_parser"
require "dependabot/conan/conan_cli"
require_common_spec "file_parsers/shared_examples_for_file_parsers"

RSpec.describe Dependabot::Conan::FileParser do
  subject(:parser) do
    described_class.new(
      dependency_files: dependency_files,
      source: source,
      conan_cli: conan_cli
    )
  end

  let(:source) do
    Dependabot::Source.new(
      provider: "github",
      repo: "example/bazel-project",
      directory: "/"
    )
  end

  let(:conan_cli) {
    graph = JSON.parse(graph_file)
    fake_conan_cli = instance_double(Dependabot::Conan::ConanCli)
    allow(fake_conan_cli).to receive(:graph_info).and_return(graph)
    fake_conan_cli
  }

  let(:dependency_files) { [conanfile] }
  let(:conanfile) { Dependabot::DependencyFile.new(
    name: "conanfile.txt",
    content: fixture("projects", "basic_conanfile_txt", "conanfile.txt")
  )
  }
  let(:graph_file) { fixture("projects", "basic_conanfile_txt", "graph.json") }


  it_behaves_like "a dependency file parser"

  describe "parse" do
    subject(:dependencies) { parser.parse }

    context "with only a conanfile.txt" do

      its(:length) { is_expected.to eq(1) }

      context "with a single dependency specified by an exact version" do
        let(:graph_file) { fixture("projects", "basic_conanfile_txt", "graph.json") }

        describe "the only dependency" do
          subject(:dependency) { dependencies.first }

          it "has the right details" do
            expect(dependency).to be_a(Dependabot::Dependency)
            expect(dependency.name).to eq("zlib")
            expect(dependency.version).to eq("1.3.1")
            expect(dependency.requirements).to eq(
              [{
                requirement: "1.3.1",
                file: "conanfile.txt",
                groups: %w(direct host),
                source: {
                  url: "https://zlib.net"
                }
              }])
          end
        end
      end
    end
  end
end
