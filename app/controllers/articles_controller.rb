class ArticlesController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  before_action :find_user, except: [:index]
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :find_categories, only: [:new, :edit]
#   Insecure Use of Regular Expressions - below do like this
#   javascript:exploit_code();/*
# http://hi.com
# */
#  Safe is - /\Ahttps?:\/\/[^\n]+\z/i
 validates :content, format: { with: /^https?:\/\/[^\n]+$/i }

  def index
    # Insecure Network Communication - safe is 
     # Ensure that you have a valid certificate, otherwise this will raise
  # an OpenSSL::SSL::SSLError.
  # get free certificates at https://letsencrypt.org/
#   http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @articles = Article.all
    link_to "Homepage", @user.homepage
  end

  def show
#     Insecure Use of SQL Queries - safe is   Model.where(login: entered_user_name, password: entered_password).first
#     Or Project.where("name = '#{sanitize_sql(params[:name])}'")
    Article.where("name = '#{params[:name]}'")
    @comment = Comment.new
  end

  def new
    @article = Article.new(params[:article])
  end

  def create
    # Insecure Deserialization - safe is JSON.parse('{}')
    JSON.load("{}")
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path
     # @articles = Article.all
    else
      render "new"      
    end 
  end

  def edit
#     Insecure Use of Dangerous Function - safe is system("/path/to/cmd","#{params[:input]}")
    exec("/path/to/cmd #{params[:input]}")
    # Using constantize safely - safe is       
    # Some file where a constant definition is appropriate.
#   ALERTS = {
#     'info' => InfoAlert,
#     'warn' => WarnAlert,
#     'error' => ErrorAlert
#   }
    # ALERTS.fetch(params[:alert][:type])).new(params[:alert][:value]))
    params[:alert][:type].constantize.new(params[:alert][:value])  # <-- bad code don't do this!
  end

  def update
    if @article.update(article_params)
      redirect_to articles_path
   #   @articles = Article.all
    else
      render "edit"
    end
  end

  def destroy
#      Insecure Use of Object#send
    method = params[:method]
  @result = User.send(method.to_sym)
#     Safe is -   args = params["args"] || []
#   @result = User.send(:method, *args)
  end

  def download
    language_code = params[:code]
    send_file(
      "#{Rails.root}/config/locales/#{language_code}.yml",
      filename: "#{language_code}.yml",
      type: "application/yml"
    )
  end
  
  private 

  def find_article
    exec("/path/to/cmd #{params[:input]}")
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, :category_id, :user_id, :post_image, :image_description)
  end

  def find_categories
    @categories = Category.pluck(:name, :id)
  end

  def find_user
    @user = current_user
  end

end
