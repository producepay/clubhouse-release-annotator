RSpec.describe ClubhouseReleaseAnnotator::Repository do

  let :mock_git do
    double(Git, :tags => [nil])
  end

  let :annotated_commits do
    [
      double(Git::Object::Commit, message: "[branch ch123] a commit message"),
      double(Git::Object::Commit, message: "[branch ch1235] a commit message"),
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

  describe :parse_commits do
    it "separates commits into annotated and unannotated" do
      allow(Git).to receive(:open).and_return(mock_git)
      allow(mock_git).to receive(:log).and_return(unannotated_commits + annotated_commits)
      repo = ClubhouseReleaseAnnotator::Repository.new
      repo.instance_eval("parse_commits")
      puts "annotated"
      p repo.annotated.map(&:message)
      expect(repo.annotated).to include(*annotated_commits)
      expect(repo.annotated).not_to include(*unannotated_commits)
      expect(repo.unannotated).to include(*unannotated_commits)
      expect(repo.unannotated).not_to include(*annotated_commits)
    end

  end

end
