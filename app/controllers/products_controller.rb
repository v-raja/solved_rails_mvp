class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    authorize @products
    set_meta_tags title: "Explore solutions by product",
                  description: "Understand all the different ways a product can be used to solve problems.",
                  reverse: true,
                  canonical: products_url
  end

  # GET /products/1
  # GET /products/1.json
  def show
    authorize @product
    set_meta_tags title: "Understand how #{@product.name} can help you",
                  description: "Understand how different people use #{@product.name} to solve their problems",
                  reverse: true,
                  canonical: product_url(@product)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product, include: ['plans'] }
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.friendly.find (params[:id])
    end
end
