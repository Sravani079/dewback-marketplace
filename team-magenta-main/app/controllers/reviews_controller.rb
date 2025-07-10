class ReviewsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @dewback = Dewback.find(params[:dewback_id])
      @review = @dewback.reviews.build(review_params)
      @review.user = current_user
  
      if @review.save
        redirect_to dewback_path(@dewback), notice: "Review submitted successfully."
      else
        redirect_to dewback_path(@dewback), alert: "Unable to submit review. Please check and try again."
      end
    end
  
    private
  
    def review_params
      params.require(:review).permit(:rating, :comment, :image)
    end
  end
  