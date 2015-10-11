FactoryGirl.define do

    factory :user do
        email                               { Faker::Internet.email }
        password                            'default'
        password_confirmation               'default'
    end

end