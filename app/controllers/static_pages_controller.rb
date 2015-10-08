include TwitterApiHelper

class StaticPagesController < ApplicationController
    
    def index
        user = User.find_by(email: 'bennettlee908@gmail.com')
        sign_in(user)
        
        if signed_in?
            @tweets = []
            render 'index'
        else
            redirect_to new_user_session_path
        end
    end

    def tweets
        @tweets = TwitterApi.get_tweets_for_handle(params[:handle])

        render 'tweets.js.erb'
    end

end
