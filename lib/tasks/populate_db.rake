require 'json'

namespace :db do
    desc 'Fill database with sample data'
    task populate: :environment do
        populate_admin
    end

    # Populate administrator
    def populate_admin

         User.create!(
                        first_name:             'Bennett', 
                        last_name:              'Lee',
                        email:                  'bennettlee908@gmail.com',
                        password:               'testing',
                        password_confirmation:  'testing',
                    )

    end
    
end




















