module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def flash_class(level)
      case level
          when :notice  then "alert alert-info"
          when :success then "alert alert-success"
          when :error   then "alert alert-error"
          when :alert   then "alert alert-error"
      end
  end

end


