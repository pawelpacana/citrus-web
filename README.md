## Citrus Web

[![Build Status](https://secure.travis-ci.org/pawelpacana/citrus-web.png)](http://travis-ci.org/pawelpacana/citrus-web) [![Dependency Status](https://gemnasium.com/pawelpacana/citrus-web.png)](https://gemnasium.com/pawelpacana/citrus-web) [![Code Climate](https://codeclimate.com/github/pawelpacana/citrus-web.png)](https://codeclimate.com/github/pawelpacana/citrus-web) [![Gem Version](https://badge.fury.io/rb/citrus-web.png)](http://badge.fury.io/rb/citrus-web) [![Coverage Status](https://coveralls.io/repos/pawelpacana/citrus-web/badge.png)](https://coveralls.io/r/pawelpacana/citrus-web)

Web component - an API endpoint, commit push listener and frontend app server.

### Triggering github push

	puma -b tcp://127.0.0.1:8080 --debug -Ilib config.ru
	curl -X POST http://127.0.0.1:8080/github_push --data-urlencode payload@spec/payload.json
