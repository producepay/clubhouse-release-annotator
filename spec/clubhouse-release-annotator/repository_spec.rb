RSpec.describe ClubhouseReleaseAnnotator::Repository do

  before do
    allow(Git).to receive(:open).and_return(mock_git)
  end

  let :mock_git do
    double(Git, :tags => [nil])
  end

  describe :relevant_commits do
    let :mock_log do
      double(Array)
    end

    before do
      allow(mock_git).to receive(:log).and_return(mock_log)
    end

    context "when there's a previous release tagged" do
      before do
        allow(mock_git).to receive(:tags).and_return([
          double(Git::Object::Tag, :name => "2018-01-01")
        ])
      end

      it "looks only for commits since the release" do
        expect(mock_log).to receive(:between).and_return(mock_log) #.with("2018-01-01", "HEAD")
        repo = ClubhouseReleaseAnnotator::Repository.new
        commits = repo.instance_eval("relevant_commits")
        expect(commits).to eql(mock_log)
      end
    end

    context "when there's no previous release tagged" do
      before do
        allow(mock_git).to receive(:tags).and_return([])
      end

      it "looks at all commits" do
        expect(mock_log).not_to receive(:between)
        repo = ClubhouseReleaseAnnotator::Repository.new
        commits = repo.instance_eval("relevant_commits")
        expect(commits).to eql(mock_log)
      end
    end
  end

  describe :parse_commits do
    let :annotated_commits do
      [
        double(Git::Object::Commit, message: "[branch ch123] a commit message"),
        double(Git::Object::Commit, message: "[branch ch1235] a commit message"),
        double(Git::Object::Commit, message: "[branch ch1237] a commit message with ticket that appears more than once"),
        double(Git::Object::Commit, message: "[branch ch1237][branch ch1238] another commit message that finishes two tickets"),
        double(Git::Object::Commit, message: "[branch ch12345] a commit message with a five digit ticket")
      ]
    end

    let :unannotated_commits do
      [
        double(Git::Object::Commit, message: "a commit message with no ticket number"),
        double(Git::Object::Commit, message: "[2234] a commit message without ch"),
        double(Git::Object::Commit, message: "[ch2235] a commit message without branch"),
        double(Git::Object::Commit, message: "a commit message that happens to have number 2235"),
        double(Git::Object::Commit, message: "[branch ch1237 ch1238] two ticktes in the same tag not currently allowed"),
      ]
    end

    let :all_commits do
      (unannotated_commits + annotated_commits).shuffle
    end

    it "separates commits into annotated and unannotated" do
      allow(mock_git).to receive(:log).and_return(unannotated_commits + annotated_commits)
      repo = ClubhouseReleaseAnnotator::Repository.new
      repo.instance_eval("parse_commits")
      expect(repo.annotated).to include(*annotated_commits)
      expect(repo.annotated).not_to include(*unannotated_commits)
      expect(repo.unannotated).to include(*unannotated_commits)
      expect(repo.unannotated).not_to include(*annotated_commits)
    end

    it "returns a list of unique commit numbers" do
      allow(mock_git).to receive(:log).and_return(unannotated_commits + annotated_commits)
      repo = ClubhouseReleaseAnnotator::Repository.new
      repo.instance_eval("parse_commits")
      expect(repo.referenced_stories).to contain_exactly("123", "1235", "1237", "1238", "12345")
    end
  end

end
