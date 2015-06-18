# attributes:
# first_name
# last_name
# nickname
# age
# number_of_logins
# favorite_language
# favorite_number_or_color
class Person < ActiveRecord::Base
  has_many :blog_posts

  before_save :verify_valid_age

  def verify_valid_age
    if age < 12 or age > 120
      self.errors.add('Age in invalid!')
    end
  end

  def is_teenager
    age < 18 ? true : false
  end

  def full_name
    if first_name and last_name
      "#{first_name} #{last_name}"
    else
      nil
    end
  end

  def self.total_logins
    all.inject(0) do |sum, person|
      sum += person.number_of_logins
    end
  end

  def favorite_language_is_ruby?
    favorite_language == 'ruby'
  end

  def favorite_language_is_javascript?
    favorite_language == 'javascript'
  end

  def favorite_language_is_python?
    favorite_language == 'python'
  end

  def correct_favorite_number_or_color
    if favorite_number_or_color === Fixnum
      return favorite_number_or_color == 'black'
    elsif favorite_number_or_color === String
      return favorite_number_or_color == 21
    end
  end

  def set_nickname
    new_nickname = ''
    blog_post_count = BlogPost.count("author_id = #{id}")
    puts blog_post_count
    experience_level = if blog_post_count < 10
      'Beginner'
    elsif blog_post_count < 20
      'Apprentice'
    elsif blog_post_count < 30
      'Expert'
    else
      'Guru'
    end
    puts experience_level
    new_nickname = experience_level + ' Writer'
    if !number_of_logins.nil?
      if number_of_logins == 42
        new_nickname = 'Special ' + new_nickname
      end
    end
    nickname = new_nickname
    save
  end
end

