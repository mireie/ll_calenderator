# KickCal

KickCal is a Rails application for collecting league, team, game, and location
data and presenting upcoming schedules. It was designed to generate calendar
feeds from team schedules.

The hosted project is currently paused. League and team calendar endpoints now
return `410 Gone` because the underlying service supports calendar
subscriptions directly. The application remains available for local
development and maintenance.

## Requirements

- Ruby 3.2.3
- PostgreSQL
- Node.js and Yarn 1.22.22

Ruby dependencies are declared in `Gemfile`, and JavaScript dependencies are
declared in `package.json`.

## Getting started

Clone the repository, install the dependencies, and prepare the database:

```sh
git clone https://github.com/mireie/ll_calenderator.git
cd ll_calenderator
bin/setup --skip-server
```

The development database configuration expects PostgreSQL databases named
`calendarator_development` and `calendarator_test`. Make sure PostgreSQL is
running and that your local PostgreSQL user can create and access those
databases. You can also prepare the database directly with:

```sh
bin/rails db:prepare
```

Start the development environment with:

```sh
bin/dev
```

This starts the Rails server at <http://localhost:3000> and watches the
JavaScript and CSS builds.

## Useful commands

```sh
# Run the Rails server and asset watchers
bin/dev

# Build JavaScript and CSS once
yarn build

# Run the test suite
bundle exec rspec

# Run linting
bundle exec rubocop

# Open a Rails console
bin/rails console
```

Use `bin/setup --skip-server` when you want to install or update dependencies,
prepare the database, and clear local logs without starting the server.

## Application areas

- Organizations contain leagues, teams, and games discovered from external
	schedule pages.
- League and schedule sync work is implemented as Active Job jobs backed by
	Solid Queue.
- Locations are geocoded through Geocoder using Nominatim, with results cached
	through the Rails cache.
- Devise provides user authentication and Pundit provides authorization.
- The admin area exposes refresh and job-management tools to authorized users.

The main resource routes are organizations, locations, games, teams, and
leagues. The root route renders the paused-project page.

## Configuration

Development and test database settings live in `config/database.yml`.
Production expects:

```sh
CALENDARATOR_DATABASE_PASSWORD=...
```

Rails credentials are used for production-only secrets such as the Bugsnag API
key. Edit them with:

```sh
bin/rails credentials:edit
```

Do not commit local secrets or production credentials.

## Background jobs

Development and production use Solid Queue as the Active Job adapter. Puma
starts the Solid Queue plugin unless `DISABLE_SOLID_QUEUE_IN_PUMA` is set.

The job classes in `app/jobs` handle organization discovery, league details,
teams, schedules, and nightly synchronization. The job dashboard is mounted at
`/jobs` for authorized super users.

## Deployment

The application includes a `Dockerfile` and Fly.io configuration in `fly.toml`.
The Fly deployment runs `./bin/rails db:prepare` as its release command and
serves the Rails application on port 3000. Configure the production database,
Rails credentials, and any platform-specific secrets before deploying.

## Project status

KickCal is not currently under active product development. Changes should be
limited to maintenance, security, reproducibility, or explicitly planned work.
If you would like to see it running again, [contact me through GitHub](https://github.com/mireie/ll_calenderator/issues/new)
and let me know.
