class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable

  has_attached_file :avatar, :styles => {:eighty=>"80x80#",:forty=>"40x40#",:one_sixty=>"160x160#"}

  has_many :subscriptions, dependent: :destroy

  def auth_attributes
    {github_token: github_token, github_nickname: github_nickname, auth_token: auth_token}
  end

  def auth_token
    authentication_token
  end

  def update_missing_attributes attrs
    attrs.each do |attr,value|
      write_attribute(attr, value) if read_attribute(attr).nil? || "#{read_attribute(attr)}".length == 0
    end

    save!
  end

  def self.find_for_github_auth(github_auth={}, options={})
    info            = github_auth.fetch("info",{})
    github_nickname = info.fetch("nickname",nil)
    github_image    = info.fetch("image",nil)

    github_token    = github_auth.fetch("credentials",{}).fetch("token",nil)
    github_uid      = github_auth.fetch("uid", nil)

    full_name       = info.fetch("name","")
    email           = info.fetch("email","")

    user            = User.find_by_github_nickname(github_nickname)

    unless user || options[:do_not_create]
      temporary_pass = Devise.friendly_token

      user ||= User.create!(email: email,
                            password: temporary_pass,
                            password_confirmation: temporary_pass,
                            github_uid: github_uid,
                            github_image: github_image,
                            full_name: full_name,
                            github_token: github_token,
                            github_nickname: github_nickname
                           )
    end

    if user.valid?
      user.update_missing_attributes(full_name: full_name, github_token: github_token, github_uid: github_uid, github_image: github_image)
      return user
    else
      raise "Access denied"
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  github_token           :string(255)
#  github_uid             :integer
#  github_nickname        :string(255)
#  github_image           :string(255)
#  state                  :string(255)
#  checked_in_at          :datetime
#

