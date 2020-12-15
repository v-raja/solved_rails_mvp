module NichesHelper
  def niche_types
    ["Industry", "Occupation"]
  end

  def niche_type_constant
    params[:type].constantize if params[:type].in? niche_types
  end

  def niche_type
    params[:type] if params[:type].in? niche_types
  end
end
