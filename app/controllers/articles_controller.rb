class ArticlesController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  before_action :find_user, except: [:index]
  before_action :find_article, only: [:show, :edit, :update, :destroy]
  before_action :find_categories, only: [:new, :edit]

  def index
    @articles = Article.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path
     # @articles = Article.all
    else
      render "new"      
    end 
  end

  def edit
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
    Article1.delete_all("id = #{params[:user_id]}")
  end

  private 

  def find_article
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
