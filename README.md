# Gov Repo Search

GovRepoSearch is a web app that lets you search for public sector open source
software on Github.

## How it works

The crawler queries all repositories belonging to known government
organisations on github, using the github API.

Any repositories that have a licence file in the root of the repository are
indexed using elasticsearch.

The github API gives us a lot of information about code repositories, such as:

- README text
- Number of commits
- Most recent commit
- Repository topics
- Programming languages used
- Number of people that have starred or forked the repository
- Tags that follow semantic versioning
- Size of codebase

Some organisations also follow metadata standards, which could tell us
even more about their repositories. For example:
- [civic.json](http://open.dc.gov/civic.json/)
- [.about.yml](https://github.com/18F/about_yml)
- [.codeinventory.yml](https://github.com/GSA/codeinventory)

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes on
how to deploy the project on a live system.

### Prerequisites

You need vagrant and virtualbox to run the development environment. (TODO)

Then, enter the ubuntu virtual machine:
```
vagrant up
vagrant ssh
```

Alternatively, you can install Elasticsearch and ruby 2.4.0 directly on your host machine. (TODO)

### Installing
Install the gem dependencies with:

```
gem install bundler
bundle install
```

Run the app in development with
```
bundle exec rails s
```

If everything is working you should be able to view the app in your browser
at http://localhost:3000

## Running the tests

TODO

### Crawler tests

TODO

### Web App tests

TODO

### Coding style

TODO

## Deployment

TODO.

The project should follow the [12 factor](https://12factor.net)
methodology.

It requires an elasticsearch cluster to run.

The crawler should be scheduled to run nightly.

## Built With

* [Ruby](https://www.ruby-lang.org/en/) - Programming language
* [Bundler](https://bundler.io/) - Dependency management
* [Rails](http://rubyonrails.org/) - Web framework
* [Elasticsearch](https://www.elastic.co/products/elasticsearch) - Search engine
* [Octokit](http://octokit.github.io/octokit.rb/) - Github API client

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Versioning

Use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/matmoore/govwebsearch/tags).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments and Inspiration

* Thanks to [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2) and [zenorocha](https://gist.github.com/zenorocha/4526327) for their handy README templates
* [Govcode](https://github.com/dlapiduz/govcode.org)
* [code.gov](https://code.gov) and their discussion of [metadata standards](https://github.com/presidential-innovation-fellows/code-gov-web/issues/41)
* [Code for DC's project browser](http://codefordc.org/projects/) and the [Code for America API](https://github.com/codeforamerica/cfapi)
* [open.gsa](http://open.gsa.gov/) and [CFPB Open Tech](https://cfpb.github.io/)
