# Clubhouse::Release::Annotator

Generates release notes for a project that has Clubhouse tickets annotated in the
commit messages.

## Configuration

You must provide a Clubhouse API token, which you can get from Clubhouse via gear icon ->
settings -> API tokens.  

You can put it in `.clubhouse_api_token` in a working
directory (per-project config), `~/.clubhouse_api_token` (per-user config), or provide the
environment variable CLUBHOUSE_API_TOKEN.

## Installation

Not yet released as a public gem, so you have to build and install locally.

1. Clone this repository
1. `cd clubhouse-release-annotator`
1. `rbenv local <Ruby version of your project>`
1. `bundle`
1. `gem build clubhouse-release-annotator.gemspec`
1. `gem install clubhouse-release-annotator --local`

## Usage

In your project directory, run `clubhouse-release-annotator`.  Copy and paste the
output into your RELEASES.md file.

## TODO

Possible features to add
* Ability to pass in a target directory/repository on the command line instead of requiring pwd.
* Use clubhouse API to filter for only those stories actually completed since the last release
* Possibly report on stories that were touched but not completed
* provide command-line flag to report non-completed and/or previously-completed stories
* Automatically insert the annotations into README  
* Possibly search clubhouse for completed features that weren't correctly annotated in git messages

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/EvanDorn-ProducePay/clubhouse-release-annotator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Clubhouse::Release::Annotator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/EvanDorn-ProducePay/clubhouse-release-annotator/blob/master/CODE_OF_CONDUCT.md).
