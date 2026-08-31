# typed: false
# frozen_string_literal: true

require "spec_helper"
require "dependabot/conan/file_fetcher"
require_common_spec "file_fetchers/shared_examples_for_file_fetchers"

RSpec.describe Dependabot::Conan::FileFetcher do
  let(:credentials) do
    [{
      "type" => "git_source",
      "host" => "github.com",
      "username" => "x-access-token",
      "password" => "token"
    }]
  end
  let(:url) { github_url + "repos/example/repo/contents/" }
  let(:github_url) { "https://api.github.com/" }
  let(:directory) { "/" }
  let(:source) do
    Dependabot::Source.new(
      provider: "github",
      repo: "example/repo",
      directory: directory
    )
  end
  let(:file_fetcher_instance) do
    described_class.new(
      source: source,
      credentials: credentials,
      repo_contents_path: nil
    )
  end

  before do
    allow(file_fetcher_instance).to receive_messages(commit: "sha", allow_beta_ecosystems?: true)
  end

  it_behaves_like "a dependency file fetcher"

  context "with no conan dependency files" do
    before do
      stub_request(:get, url + "?ref=sha")
      .with(headers: { "Authorization" => "token token" })
      .to_return(
        status: 200,
        headers: { "content-type" => "application/json" },
        body: fixture("github", "contents_no_conan_repo.json"),
      )
    end

    it "raises the expected error" do
      expect { file_fetcher_instance.files }
        .to raise_error(Dependabot::DependencyFileNotFound)
    end
  end

  def conan_stub_request(fixture, filename)
    stub_request(:get, url + "#{filename}?ref=sha")
      .with(headers: { "Authorization" => "token token" })
      .to_return(
        status: 200,
        headers: { "content-type" => "application/json" },
        body: fixture
      )
  end

  context "with a conan.lock file and a conanfile.txt file" do
    before do
      conan_stub_request(fixture("github", "contents_conanfile_txt_and_lockfile_repo.json"), "")
      conan_stub_request(fixture("github", "contents_lockfile.json"), "conan.lock")
      conan_stub_request(fixture("github", "contents_conanfile_txt.json"), "conanfile.txt")
    end

    it "fetches the conan.lock and conanfile.txt files" do
      expect(file_fetcher_instance.files.count).to eq(2)
      expect(file_fetcher_instance.files.map(&:name))
        .to match_array(%w(conan.lock conanfile.txt))
    end
  end

  describe ".required_files_in?" do
    subject(:required_files_in?) { described_class.required_files_in?(filenames) }

    context "when conan.lock and conanfile.txt is present" do
      let(:filenames) { ["conan.lock", "conanfile.txt"] }

      it { is_expected.to be(true)}

    end
  end

  describe ".required_files_message" do
    subject(:required_files_message) {described_class.required_files_message}

    it "returns a helpful message" do
      expect(required_files_message)
        .to eq("Repo must contain a conan.lock file and one of either a conanfile.txt, or a conanfile.py file.")
    end
  end
end
