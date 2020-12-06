module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def inclination(number, one, few, many)
    return "" if number.nil? || !number.is_a?(Numeric)
    balance = number % 10
    balance_100 = number % 100

    return many if (11..14).include?(balance_100)

    return one if balance == 1

    return few if (2..4).include?(balance)

    return many if  balance >= 5 || balance == 0
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end


# Добавьте на страницу пользователя блок с количеством вопросов.
# Слово вопросов должно быть в правильной форме (как мы делали в уроке про «склонятор»).
# В качестве ответа приложите ссылку на репозиторий с приложением askme.
# Добавьте в ваше приложение метод склонятора в качестве хелпера.
# Чтобы проверить, как он работает, поменяйте количество вопросов в болванке @questions.
