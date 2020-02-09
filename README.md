[![Build Status](https://travis-ci.org/aqabawe/cron-parser.svg?branch=master)](https://travis-ci.org/aqabawe/cron-parser)
# cron-parser
Simple Ruby library to parse cron expressions

## How to run
- Install [Docker Compose](https://docs.docker.com/compose/install/)
- To parse a cron expression: `docker-compose run app bin/cron-parser "*/15 0 1,15 * 1-5 /usr/bin/find"`
- To run tests: `docker-compose run app bin/test

## Compostion
The librarby is composed of 3 main components, which can be found in [lib/cron_parser](https://github.com/aqabawe/cron-parser/tree/master/lib/cron_parser). Those components are:

- Parser: Trasnforms the different expression components into values.
- Rule Matcher: Determines which cron rule to be applied on the expression component
- Decorater: Displays the parsed expression in a user friendly format.

The tests for the components can be found in the `tests` folder.

## Supported Rules
- Literals, according to the following limits:

| Field         | Range         |
| ------------- | ------------- |
| Minutes       | 0 - 59        |
| Hours         | 0 - 23        |
| Day of month  | 1 - 31        |
| Month         | 1 - 12        |
| Day of week   | 1 - 7         |

- Wildcard: \*, also with step: \*/5
- Range: Ranges are two numbers separated with a hyphen. The specified range is inclusive. For example, 8-11 for an 'hours' entry specifies execution at hours 8, 9, 10, and 11. Steps can also be added to ranges: 8-20/2
- List: A list is a set of numbers (or ranges) separated by commas. Examples: "1,2,5,9", "0-4,8-12".

## TODO: Further development
- Add support for value `7` in days of the week field.
- Add support for the of literal plus step, ex: `2/5`. Which is not part of the cron standard.
- Add support for using the three letter names for both month and day of the week fields.
