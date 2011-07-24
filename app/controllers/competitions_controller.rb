class CompetitionsController < ApplicationController

  before_filter :login_required, :except => [:show]

=begin
  def index
    @competitions = Competition.all
  end
=end

  def show
    @competition = Competition.find(params[:id])
  end

=begin
  def new
    @competition = Competition.new
  end
=end

  def edit
    @competition = Competition.find(params[:id])
    @competition.update_attribute(:user_id, current_user.id) if @competition.user.nil?
    redirect_to root_path if !current_user.is_admin?(@competition)
  end

=begin
  def create
    @competition = Competition.new(params[:competition])

    if @competition.save
      redirect_to @competition, notice: 'Competition was successfully created.'
    else
      render action: "new"
    end
  end
=end

  def update
    @competition = Competition.find(params[:id])

    if @competition.update_attributes(params[:competition])
      redirect_to admin_path, notice: 'Competition was successfully updated.'
    else
      render action: "edit"
    end
  end

=begin
  def destroy
    @competition = Competition.find(params[:id])
    @competition.destroy
    redirect_to competitions_url
  end
=end
end
