module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end
end

def sklonyator(q_count, word_forms)
  q_count %= 100 if q_count > 100
  q_count %= 10 if q_count > 20

  return "#{q_count} #{word_forms[0]}" if q_count == 1
  return "#{q_count} #{word_forms[1]}" if q_count.between?(2, 4)
  "#{q_count} #{word_forms[2]}"
end

  # def fa_icon(icon_class)
  #   content_tag 'span', '', class: "fa fa-#{icon_class}"
  # end


# Добавьте на страницу пользователя блок с количеством вопросов.
# Слово вопросов должно быть в правильной форме (как мы делали в уроке про «склонятор»).
# В качестве ответа приложите ссылку на репозиторий с приложением askme.
# Добавьте в ваше приложение метод склонятора в качестве хелпера.
# Чтобы проверить, как он работает, поменяйте количество вопросов в болванке @questions.
