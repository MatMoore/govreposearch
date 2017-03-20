# Gov Repo Search

GovRepoSearch is a web app that lets you search for public sector open source
software on Github.

## How it works

The crawler queries all code repositories belonging to known government
organisations on Github, using the Github API.

The README text and other repository information get added to an Elasticsearch
search index.

To be indexed, a repository has to have a README file, and licence information.
If there isn't a LICENCE.txt/md/rst file, the crawler tries to guess from the
readme (not all licences are recognised this way).

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes on
how to deploy the project on a live system.

### Prerequisites

TODO: install ansible; create `ansible/secrets.yml` with `secret_key_base` var.

You need vagrant and virtualbox to run the development environment. (TODO)

Then, enter the ubuntu virtual machine:
```
vagrant up
vagrant ssh
```

Alternatively, you can install Elasticsearch and ruby 2.4.0 directly on your
host machine. (TODO)

### Building the search index

You need to create and populate the search index to run the app.

First create the search index:
```
bundle exec rake index:create_or_replace
```

If you get any errors, check that Elasticsearch is running and listening on port
9200.

You can check Elasticsearch's health by visiting [http://localhost:9200/_cat/health]().

After creating the index, you can run the crawler with:
```
bundle exec rake crawler:crawl
```

P.S. the crawler will crash when it hits the Github API's rate limit of 60
requests/hour...

To crawl the whole list of organisations, you need to set up an access token.
Visit [https://github.com/settings/tokens]() to generate one.

Then set the environment variable `GITHUB_API_KEY`, or add it to a `.env` file
in the root of the project, like
```
GITHUB_API_KEY=<your key here>
```

Indexing takes a while to run.

### Running the app
First install the gem dependencies with:

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

The tests are all written in RSpec.

Run them with:
```
bundle exec rspec
```

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
* [Ansible](https://www.ansible.com/) - Configuration management
* [Octokit](http://octokit.github.io/octokit.rb/) - Github API client

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

### Data that might be useful
The github API gives us a lot of information about repositories, including:

- README text
- Number of commits
- Most recent commit
- Repository topics
- Programming languages used
- Number of people that have starred or forked the repository
- Tags that follow semantic versioning
- Size of codebase

Some organisations also follow metadata standards, which could tell us more
about their repositories. For example:
- [civic.json](http://open.dc.gov/civic.json/)
- [.about.yml](https://github.com/18F/about_yml)
- [.codeinventory.yml](https://github.com/GSA/codeinventory)

## License

This project is licensed under the MIT License - see the [LICENCE](LICENCE) file for details

## Acknowledgments and Inspiration

* Thanks to [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2) and [zenorocha](https://gist.github.com/zenorocha/4526327) for their handy README templates.
* [Govcode](https://github.com/dlapiduz/govcode.org) is (was?) a similar project.
* [code.gov](https://code.gov) lets you search code released by the US government. They are also looking into [metadata standards](https://github.com/presidential-innovation-fellows/code-gov-web/issues/41).
* [Code for DC's project browser](http://codefordc.org/projects/) and the [Code for America API](https://github.com/codeforamerica/cfapi) cover projects from civic tech organisations.
* [open.gsa](http://open.gsa.gov/) and [CFPB Open Tech](https://cfpb.github.io/) showcase projects from the GSA and CFPB.
