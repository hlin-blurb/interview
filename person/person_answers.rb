# attributes:
# first_name
# last_name
# nickname
# age
# number_of_logins
# favorite_language
# favorite_number_or_color # do not store two things in one column
class Person < ActiveRecord::Base
  has_many :blog_posts

  before_save :verify_valid_age

  def verify_valid_age # should be a validation, not callback
    if age < 12 or age > 120
      self.errors.add('Age in invalid!')
    end
  end

  def is_teenager # teenager?
    age < 18 ? true : false # no need for ternary
  end

  def full_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    else # unnecessary else
      nil
    end
  end

  def self.total_logins # use SQL sum
    all.inject(0) do |sum, person|
      sum += person.number_of_logins
    end
  end

  # define is_favorite_language?(language) instead of separately or using metaprogramming
  def favorite_language_is_ruby?
    favorite_language == 'ruby'
  end

  def favorite_language_is_javascript?
    favorite_language == 'javascript'
  end

  def favorite_language_is_python?
    favorite_language == 'python'
  end

  def correct_favorite_number_or_color # correct_favorite_number_or_color?
    # the if/else statements should be switched
    if favorite_number_or_color === Fixnum # use is_a? instead
      return favorite_number_or_color == 'black' #unnecessary return
    elsif favorite_number_or_color === String
      return favorite_number_or_color == 21 #unnecessary return
    end
  end

  def set_nickname # should be set_nickname!
    new_nickname = ''
    blog_post_count = BlogPost.count("author_id = #{id}") # blog_posts.count, query parameterization
    puts blog_post_count # remove
    experience_level = if blog_post_count < 10 # use a case statement
      'Beginner'
    elsif blog_post_count < 20
      'Apprentice'
    elsif blog_post_count < 30
      'Expert'
    else
      'Guru'
    end
    puts experience_level # remove
    new_nickname = experience_level + ' Writer' # string interpolation
    if !number_of_logins.nil? # use #number_of_logins?
      if number_of_logins == 42 # combine with if above, use a constant
        new_nickname = 'Special ' + new_nickname # string interpolation
      end
    end
    nickname = new_nickname # self.nickname
    save # update_attributes
  end
end

