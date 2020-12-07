module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def inclination(number, one, few, many)
    balance = number % 10
    balance_100 = number % 100

    return many if (11..14).include?(balance_100)

    return one if balance == 1

    return many if  balance >= 5 || balance == 0

    few
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end
