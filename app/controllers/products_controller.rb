class ProductsController < ApplicationController
  skip_before_action :authorize, only: [:show, :edit, :update]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @user = User.find_by id: session[:user_id]
    @tags = Tag.all
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @tags = Tag.all
    @user = User.find_by id: session[:user_id]
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    tags = params[:tags]
    this_product_tags = @product.product_tags.to_a.map { |val| val.id }
    tags.each do |tag|
      #skip if the product has the tag
      unless this_product_tags.index(tag)
        this_tag = Tag.find(tag)
        product_tag = ProductTag.new(:tag => this_tag, :product => @product)
        @product.product_tags << product_tag
      end
    end

    desc_review = params[:product][:desc]
    rate_review = params[:product][:review]
    if desc_review && rate_review
      review = Review.new(:product => @product, :description => desc_review, :review => rate_review)
      @product.reviews << review
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      desc_review = params[:product][:desc]
      rate_review = params[:product][:review]
      if desc_review && rate_review
        review = Review.new(:product => @product, :description => desc_review, :review => rate_review)
        @product.reviews << review
      end

      if User.find_by id: session[:user_id]
        if @product.update(product_params)
          @products = Product.order(updated_at: :desc)
          tags = params[:tags]
          
          # remove tag which is not valid
          this_product_tags = @product.product_tags.to_a.map { |val| val.id }
          this_product_tags.each do |this_product_tag|
            unless tags.index(this_product_tag)
              @product.product_tags.find(this_product_tag).delete
            end
          end

          # add new all tag
          tags.each do |tag|
            #skip if the product has the tag
            unless this_product_tags.index(tag)
              this_tag = Tag.find(tag)
              product_tag = ProductTag.new(:tag => this_tag, :product => @product)
              @product.product_tags << product_tag
              @product.save
            end
          end
          ActionCable.server.broadcast 'products', html: render_to_string('store/index', layout: false)
          format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      else
        @product.save
        format.html { redirect_to store_index_url, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
end
