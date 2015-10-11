class UsersController < ApplicationController
    
    ##################################################### FILTERS #####################################################

    # Include sorting params for sortable headers on index page
    include HeaderFiltersHelper

    ##################################################### RESOURCES #####################################################

    # Show all users
    def index
       
        # Default sort parameter is created_at
        if params[:sort].blank?
            params[:sort] = { name: 'created_at', direction: '' }
        end

        @users = User.search(search_params).order("#{sort_name_param} #{sort_direction_param}").paginate(per_page: 5, page: params[:page])

        # Respond to different formats
        respond_to do |format|
          format.html # index.html.erb
          format.js  # index.js.erb
          format.json { render json: @users }
        end
    end 

    # Show an individual user
    def show

        # Only signed in users have access
        if !signed_in?
            flash[:error] = 'You must sign in to view user'
            redirect_to root_path
            return
        end

        if @user = User.find_by(id: params[:id])
            # Respond to different formats
            respond_to do |format|
              format.html # show.html.erb
              format.js # show.js.erb
              format.json { render json: @user }
            end
        else
            flash[:success] = 'User does not exist'
            # Respond to different formats
            respond_to do |format|
              format.html { safe_redirect_to_back }
              format.json { render json: { message: "User does not exist" } }
            end
        end
    end

    # Create a form for new sensor
    def new
        @user = User.new
    end

    # Create a new user
    def create
        @user = User.new(user_params)
        
        if @user.save

            flash[:success] = "Welcome to StackTwitter!"

            sign_in(@user)
            
            # Respond to different formats
            respond_to do |format|
              format.html { redirect_to root_path }
              format.json { render json: { message: "User Sucessfully Created", user: @user } }
            end
        else
            flash[:error] = @user.errors.full_messages
            # Respond to different formats
            respond_to do |format|
              format.html { render 'new' }
              format.json { render json: { message: "User Was Not Sucessfully Created", error: flash[:error] } }
            end
            
        end
    end 

    # Display form for updating an existing user
    def edit

        @user = User.find(params[:id])
    end

    # Update an existing user
    def update

        @user = User.find(params[:id])
        
        # If update is sucessful, redirect to user page, else render edit page
        if @user.update_attributes(user_params)
            flash[:success] = "Update Is Successful"

            # If user updated user param's status, send them a confirmation email
            # if !user_params[:o_status].nil? && @user.active?
            #     UserMailer.user_approved({ name: @user.user.name, email: @user.user.email }).deliver
            # end

            # Respond to different formats
            respond_to do |format|
              format.html { redirect_to @user }
              format.json { render json: { message: flash[:success] , user: @user } }
            end
        else
            flash[:error] = @user.errors.full_messages
            # Respond to different formats
            respond_to do |format|
              format.html { render 'show' }
              format.json { render json: { message: "User Update Not Sucessful ", error: flash[:error] } }
            end
            
        end
    end 

    # Destroy an existing user
    def destroy

        if @user = User.find_by(id: params[:id])
            @user.destroy

            flash[:success] = "User Successfully Destroyed"

            # Respond to different formats
            respond_to do |format|
              format.html { redirect_to users_path }
              format.json { render json: @user }
            end

        else
            render json: { message: "User Not Found" }
        end
    end


    ##################################################### PRIVATE #####################################################

    private
    
    # Strong Parameters
    def user_params
        params[:user].delete(:password) if params[:user][:password].blank?
        params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
        params.require(:user).permit(:user_id, :first_name, :last_name, :email, :password, :password_confirmation)
    end

    # Serach params (filter_data)
    def search_params
        params.permit(:name)
    end
end
