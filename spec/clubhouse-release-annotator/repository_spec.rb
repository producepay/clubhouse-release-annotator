# frozen_string_literal: true

RSpec.describe ClubhouseReleaseAnnotator::Repository do
  before do
    allow(Git).to receive(:open).and_return(mock_git)
  end

  let :mock_git do
    instance_double(Git::Base, tags: [nil])
  end

  describe "#relevant_commits" do
    let :mock_log do
      double(Array)
    end

    before do
      allow(mock_git).to receive(:log).and_return(mock_log)
    end

    context "when there's a previous release tagged" do
      before do
        allow(mock_git).to receive(:tags).and_return(
          [instance_double(Git::Object::Tag, name: '2018-01-01')]
        )
      end

      it 'looks only for commits since the release' do
        expect(mock_log).to receive(:between).with("2018-01-01", "HEAD").and_return(mock_log)
        repo = described_class.new
        commits = repo.instance_eval('relevant_commits')
        expect(commits).to eql(mock_log)
      end
    end

    context "when there's no previous release tagged" do
      before do
        allow(mock_git).to receive(:tags).and_return([])
      end

      it 'looks at all commits' do
        expect(mock_log).not_to receive(:between)
        repo = described_class.new
        commits = repo.instance_eval('relevant_commits')
        expect(commits).to eql(mock_log)
      end
    end
  end

  describe "#parse_commits" do
    let :annotated_commits do
      [
        instance_double(Git::Object::Commit, message: '[branch ch123] a commit message'),
        instance_double(Git::Object::Commit, message: '[branch ch1235] a commit message'),
        instance_double(Git::Object::Commit, message: '[branch ch1237] duplicate ticket'),
        instance_double(Git::Object::Commit, message: '[branch ch1237][branch ch1238] two tickets'),
        instance_double(Git::Object::Commit, message: '[branch ch12345] a five digit ticket')
      ]
    end

    let :unannotated_commits do
      [
        instance_double(Git::Object::Commit, message: 'a commit message with no ticket number'),
        instance_double(Git::Object::Commit, message: '[2234] a commit message without ch'),
        instance_double(Git::Object::Commit, message: '[ch2235] a commit message without branch'),
        instance_double(Git::Object::Commit, message: 'a commit  that happens to have number 2235'),
        instance_double(Git::Object::Commit, message: '[branch ch1237 ch1238] two tickets in tag')
      ]
    end

    let :all_commits do
      (unannotated_commits + annotated_commits).shuffle
    end

    before do
      allow(mock_git).to receive(:log).and_return(unannotated_commits + annotated_commits)
    end

    it 'correctly separates annotated commits' do
      repo = described_class.new
      repo.instance_eval('parse_commits', __FILE__, __LINE__)
      expect(repo.annotated).to contain_exactly(*annotated_commits)
    end

    it 'correctly separates unannotated commits' do
      repo = described_class.new
      repo.instance_eval('parse_commits', __FILE__, __LINE__)
      expect(repo.unannotated).to contain_exactly(*unannotated_commits)
    end

    it 'returns a list of unique commit numbers' do
      allow(mock_git).to receive(:log).and_return(unannotated_commits + annotated_commits)
      repo = described_class.new
      repo.instance_eval('parse_commits', __FILE__, __LINE__)
      expect(repo.referenced_stories).to contain_exactly('123', '1235', '1237', '1238', '12345')
    end
  end
end
