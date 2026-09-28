# [згенеровано] rails new (порожній модуль)
# [власний код] допоміжні методи для видів
module ApplicationHelper
  # Пункт меню з виділенням поточної сторінки
  def nav_link(text, path, active: nil)
    # посилання без параметрів (напр. /books) активне лише тоді, коли в запиті теж немає параметрів
    active = current_page?(path) && (path.include?("?") || request.query_string.blank?) if active.nil?
    link_to text, path, class: ("active" if active)
  end

  # Середня оцінка у вигляді зірок: 4.3 -> ★★★★☆
  def stars(rating)
    return tag.span("без оцінок", class: "muted") unless rating

    full = rating.round
    tag.span("★" * full + "☆" * (5 - full), class: "stars", title: rating)
  end

  def availability(book)
    count = book.available_count
    if count.positive?
      tag.span("доступно: #{count}", class: "ok")
    else
      tag.span("немає в наявності", class: "no")
    end
  end

  # Обкладинка-заглушка: колір залежить від жанру (завантаження обкладинок — у наступній версії)
  COVER_HUES = [ 210, 25, 150, 280, 350, 45, 190 ].freeze

  def cover(book, big: false)
    tag.div(class: [ "cover", ("big" if big) ], style: "--hue: #{COVER_HUES[book.genre_id % COVER_HUES.size]}") do
      tag.span(book.title)
    end
  end

  def form_errors(record)
    return unless record.errors.any?

    tag.div(class: "form-errors") do
      tag.p("Не вдалося зберегти:") + tag.ul { safe_join(record.errors.full_messages.map { |m| tag.li(m) }) }
    end
  end
end
