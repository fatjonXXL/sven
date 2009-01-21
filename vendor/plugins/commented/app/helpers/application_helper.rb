module ApplicationHelper
  def infoize(comment)
    "#{('on')} #{comment.created_at.to_s(:short)} #{('by')} #{comment.author}"
  end
end