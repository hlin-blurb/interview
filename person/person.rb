# attributes:
# first_name                string
# last_name                 string
# nickname                  string
# age                       integer
# number_of_logins          integer
# favorite_language         string
# favorite_thing            integer/string
class Person < ActiveRecord::Base
  has_many :blog_posts

  before_save :verify_valid_age

  def verify_valid_age
    if age < 12 or age > 120
      self.errors.add('Age is invalid!')
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

  def converted_favorite_thing
    if favorite_thing =~ /^\d*$/
      favorite_thing.to_i
    else
      favorite_thing
    end
  end

  def favorite_number_is_small
    if converted_favorite_thing === Fixnum
      return converted_favorite_thing <= 10
    else
      return nil
    end
  end

  def set_nickname
    new_nickname = ''
    blog_post_count = BlogPost.count("person_id = #{id}")
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

