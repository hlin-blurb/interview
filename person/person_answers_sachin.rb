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
  validates :age, range: 12..120

 
  def is_teenager?
    age < 18
  end

  def full_name
      "#{first_name} #{last_name}" if first_name and last_name
  end

  def self.total_logins
    sum(:number_of_logins)
  end

  def is_favorite_language_ruby?
    favorite_language == 'ruby'
  end

  def is_favorite_language_javascript?
    favorite_language == 'javascript'
  end

  def is_favorite_language_python?
    favorite_language == 'python'
  end

  def correct_favorite_number_or_color
    if Fixnum === favorite_number_or_color
      favorite_number_or_color == 'black'
    elsif String === favorite_number_or_color
      favorite_number_or_color == 21
    end
  end

  def set_nickname
    new_nickname =  '#{experience_level} Writer'
    self.nickname = special ? 'Special #{new_nickname}' : new_nickname
    save
  end
  
  def experience_level
    blog_post_count = BlogPost.count("author_id = #{id}")
    if blog_post_count < 10
      'Beginner'
    elsif blog_post_count < 20
      'Apprentice'
    elsif blog_post_count < 30
      'Expert'
    else
      'Guru'
    end
  end
  
  def special
    number_of_logins? && number_of_logins == 42
  end
end

