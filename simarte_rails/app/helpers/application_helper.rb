# frozen_string_literal: true

module ApplicationHelper
  include ::Pagy::Frontend
  # Wraps occurrences of +query+ in +text+ with <mark> (HTML-escaped, safe for user-controlled +query+).
  def highlight_search(text, query)
    text = text.to_s
    return ERB::Util.html_escape(text) if query.blank?

    q = query.to_s.strip
    return ERB::Util.html_escape(text) if q.empty?

    escaped = ERB::Util.html_escape(text)
    pattern = Regexp.new(Regexp.escape(q), Regexp::IGNORECASE)
    result = escaped.gsub(pattern) do
      m = Regexp.last_match(0)
      %(<mark class="bg-primary/25 text-inherit rounded-sm px-0.5">#{m}</mark>)
    end
    result.html_safe
  end
end
