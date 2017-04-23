class PackagesController < ApplicationController
  def show
    @package = Package.find(params[:id])
  end

  def new
    @package = Package.new
  end

  def create
    @package = Package.new(package_params) 
    if @package.save
      flash[:success] = "Package was successfully added!"
      redirect_to @package
    else
      render 'new'
    end
  end

  private

    def package_params
      params.require(:package).permit(:name, :link, :package_info)
    end
end

