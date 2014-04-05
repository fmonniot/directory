# Welcome to your directory

A simple directory based on the [Télécom SudParis](http://www.telecom-sudparis.eu/fr_accueil.html) LDAP.

## Getting Started

1. Install elasticsearch

    You'll find install instruction at [http://www.elasticsearch.org/overview/elkdownloads/]

2. Install MongoDB

    Follow instruction given at [http://docs.mongodb.org/manual/tutorial/install-mongodb-on-debian/]

3. Clone the repository
4. Install the service

        export RAILS_ENV=production
        bundle install
        rake db:mongoid:create_indexes
        
        rake directory:create_index # Create ES indices
        rake directory:import_all # Import data from LDAP

5. Configure auto update (cron)

        whenever -i

6. Configure Nginx and init.d script

        root# cp scripts/init.d/trombint /etc/init.d/trombint
        root# chmod +x /etc/init.d/trombint
        root# cp scripts/nginx/trombint /etc/nginx/sites-enabled/trombint

7. Start the server

        root# service trombint start
        root# service nginx start


**Heads Up**: You can recreate ES index with

        RAILS_ENV=production rake directory:populate

## Tests

You can execute tests with the following commands:

    # Ruby tests (code coverage available in ./coverage)
    rake spec

    # Javascripts tests (code coverage available in ./coverage_js)
    trombint$ teaspoon --coverage-reports=html

**Heads Up**: You'll need [Instanbul](https://github.com/gotwarlost/istanbul) for js coverage

## License

This project is available under the [MIT License](http://www.opensource.org/licenses/MIT).
