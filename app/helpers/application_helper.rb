module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'notice'
      'alert-success'
    when 'alert', 'error'
      'alert-danger'
    else
      'alert-info'
    end
  end
end
