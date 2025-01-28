module ApplicationHelper

  # エラーメッセージ（エラーがある場合のみ div タグを生成し、赤色のテキストで表示！）
  def error_message_for(object, field)
    return unless object.errors[field].any?

    content_tag(:div, class: "text-danger small mt-1") do
      object.errors.full_messages_for(field).join(", ")
    end
  end
end