ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    %{#{html_tag}<span class="w-full text-sm text-red-500 text-left">#{instance.error_message.first}</span>}.html_safe
  else
    %{#{html_tag}}.html_safe
  end
end
