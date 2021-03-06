# attributes:
# first_name                string
# last_name                 string
# nickname                  string
# age                       integer
# number_of_logins          integer
# favorite_language         string
# favorite_number_or_color  integer/string # do not store two things in one column
class Person < ActiveRecord::Base
  has_many :blog_posts

  before_save :verify_valid_age

  def verify_valid_age # should be a validation, not callback
    if age < 12 or age > 120
      self.errors.add('Age is invalid!')
    end
  end

  def is_teenager # teenager?
    age < 18 ? true : false # no need for ternary
  end

  def full_name
    if first_name && last_name # use && instead of and
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

  def converted_favorite_thing
    if favorite_thing =~ /^\d*$/ # should use \A and \z and +
      favorite_thing.to_i
    else
      favorite_thing
    end
  end

  def favorite_number_is_small # favorite_number_is_small?
    if converted_favorite_thing === Fixnum # use is_a? instead
      return converted_favorite_thing <= 10 # unnecessary return
    else
      return nil # unnecessary return
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

