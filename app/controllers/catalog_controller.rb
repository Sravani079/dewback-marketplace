class CatalogController < ApplicationController
  def index
    @dewbacks = Dewback.all

    if params[:query].present?
      @dewbacks = @dewbacks.search(params[:query])
    end

    # Filtering
    @dewbacks = @dewbacks.where(size: params[:size]) if params[:size].present?
    @dewbacks = @dewbacks.where(max_speed: params[:speed]) if params[:speed].present?
    @dewbacks = @dewbacks.where(color: params[:color]) if params[:color].present?
    @dewbacks = @dewbacks.where(max_load: params[:load]) if params[:load].present?
    @dewbacks = @dewbacks.where(food_requirements: params[:food]) if params[:food].present?

    # Sorting
    case params[:sort_by]
    when "price_asc"
      @dewbacks = @dewbacks.order(price: :asc)
    when "price_desc"
      @dewbacks = @dewbacks.order(price: :desc)
    when "size_asc"
      @dewbacks = @dewbacks.order(Arel.sql("CASE size WHEN 'Small' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Large' THEN 3 END ASC"))
    when "size_desc"
      @dewbacks = @dewbacks.order(Arel.sql("CASE size WHEN 'Small' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Large' THEN 3 END DESC"))
    when "speed_asc"
      @dewbacks = @dewbacks.order(Arel.sql("CASE max_speed WHEN 'Slow' THEN 1 WHEN 'Moderate' THEN 2 WHEN 'Fast' THEN 3 END ASC"))
    when "speed_desc"
      @dewbacks = @dewbacks.order(Arel.sql("CASE max_speed WHEN 'Slow' THEN 1 WHEN 'Moderate' THEN 2 WHEN 'Fast' THEN 3 END DESC"))
    end
  end
end


