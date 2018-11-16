module ApplicationHelper
  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}" : (text.nil? ? "#{noun.pluralize}" : "#{text}")
    end
  end
end
