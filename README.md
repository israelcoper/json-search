# Json::Search

A simple library that provides basic search functionality to a json response.


## Assumptions

1. Option `--file_path` requires absolute path to file
2. Option `--url` expects a valid url
3. IF option `--file_path` and `--url` are both provided, url have the high priority.
4. The json response is expected to have either `data` or `results` attribute

  ```
  {
    "data": [...]
  }
  ```
  **OR**
  ```
  {
    "results": [...]
  }
  ```


## References

* https://bundler.io/guides/creating_gem.html
* https://github.com/rails/thor


## Usage

After checking out the repo, run bundle install to install dependencies. Then run `bundle exec rspec spec` to run the tests.

To use the CLI, execute: `./exe/json-search help`. This instruction will display the following:

```
Commands:
  json-search duplicate_email  # Show any records having duplicate email
  json-search help [COMMAND]   # Describe available commands or one specific command
  json-search search KEYWORD   # Search and return records with names partially matching a given search query
```

Basic search:
```
./exe/json-search search jane
```

Dynamic search field:
```
./exe/json-search search gmail --field email
```

Support to search on dynamic file:
```
./exe/json-search search aol.com --field email --file_path /mnt/d/code/json-search/data/records.json
```

Support to search on REST api:
```
./exe/json-search search frozen --field climate --url https://swapi.dev/api/planets
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/json-search. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/json-search/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Json::Search project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/json-search/blob/master/CODE_OF_CONDUCT.md).
