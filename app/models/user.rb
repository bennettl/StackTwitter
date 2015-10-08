class User < ActiveRecord::Base

    # Include default devise modules. Others available are:
    devise :database_authenticatable, :recoverable

    ################################## VALIDATION #################################
    
    validates :password,    allow_nil: true, length: { minimum: 5 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,       format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } # allow nil for twitter!

    ################################## CLASS METHODS ##################################

    # Return stats for facts
    def self.stats
        all_users   = User.all.count
        today       = User.where(created_at: 1.day.ago..Time.now).count
        week        = User.where(created_at: 1.week.ago..Time.now).count
        month       = User.where(created_at: 1.month.ago..Time.now).count
        return { Total: all_users, Today: today, Week: week, Month: month } 
    end

    # Searches users base similar (LIKE) to search hash
    def self.search(search)
        if !search.nil? && !search.empty?
            # Parameters
            query   = []
            like    = Rails.env.development? ? 'LIKE' : 'ILIKE' ; #case insensitive for postgres
            
            # Concatinate columns with || so search[:name] can search both columns
            query.push((search[:name].blank?) ? '' : "(first_name || ' ' || last_name) #{like} '%#{search[:name]}%'")
            
            # Remove nil queries
            query.reject! {|q| q.empty? }

            # Search for all fields
            self.where(query.join(' AND '))
        else
            # Empty scope, returns all but doesn't perform the actual query
            self.all
        end
    end


    ################################## METHODS #################################

    # Returns full name
    def name
        "#{first_name} #{last_name}"
    end

    ################################## JSON #################################
  
    # Will be use by to_json
    def as_json options={}
        return { 
                    id:             id,
                    first_name:     first_name, 
                    last_name:      last_name, 
                    email:          email, 
                    created_at:     created_at, 
                    updated_at:     updated_at 
                }
    end


end
