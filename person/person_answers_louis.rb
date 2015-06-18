# attributes:
# first_name
# last_name
# nickname
# age
# number_of_logins
# favorite_language
# favorite_number_or_color  #lchan: we should not try to store multiple different data types in the same attribute
class Person < ActiveRecord::Base
  has_many :blog_posts

  #Why before save instead of using the validation in active record when we are clearly validating the record?
  before_save :verify_valid_age

  #lchan: Should use the logic || instead of the control flow or.
  # Also, why less than 12 is invalid? Need more documentation than just adding the error saying 'Age in invalid'.
  def verify_valid_age
    if age < 12 or age > 120
      self.errors.add('Age in invalid!')
    end
  end

  #lchan: ? true : false is not needed
  def is_teenager
    age < 18 ? true : false
  end

  #lchan: Should use the logic && instead of the control flow and.
  def full_name
    if first_name and last_name
      "#{first_name} #{last_name}"
    else
      nil
    end
  end

  #lchan: This looks like it is trying to get the total sum for all logins for all people, but is there a reason do this in code rather than in database?
  # Something like 'SELECT SUM(number_of_logins) FROM people' will do the same thing.
  #
  # Also, method name is ambigious and it is questionable that should we have this method inside this class. 
  # Either name it total_logins_for_all_people or move it out to a helper.
  def self.total_logins
    all.inject(0) do |sum, person|
      sum += person.number_of_logins
    end
  end

  #lchan: These three methods may help code readability, but still seems way too specific
  def favorite_language_is_ruby?
    favorite_language == 'ruby'
  end

  def favorite_language_is_javascript?
    favorite_language == 'javascript'
  end

  def favorite_language_is_python?
    favorite_language == 'python'
  end
  #lchan: let's go with the following:

  def is_favorite_language? (language)
    favorite_language == language
  end   

  #lchan: Method name doesn't explain what it does, and the logic was wrong.
  def correct_favorite_number_or_color
    if favorite_number_or_color === Fixnum
      return favorite_number_or_color == 'black' #lchan: This should be == 21, Fixnum can never equal to 'black'
    elsif favorite_number_or_color === String
      return favorite_number_or_color == 21 #lchan: This should be == 'black', String can never equal to an integer
    end
  end

  #lchan: This method name doesn't describe what it does
  def set_nickname
    new_nickname = ''
    #lchan: This object already has the link to the blog_posts. Why we need a separate query like this instead of this.blog_posts.size?
    blog_post_count = BlogPost.count("author_id = #{id}")
    #This should be a logging statement - putting stuff out to the console is not useful - also, more context - should say logger.info("blog post count for user #{id} is #{blog_post_count}")
    puts blog_post_count

    #Should refactor out all the nickname construction/determination logic - this method should just set_nickname and not doing more logic than that.
    experience_level = if blog_post_count < 10
      'Beginner'
    elsif blog_post_count < 20
      'Apprentice'
    elsif blog_post_count < 30
      'Expert'
    else
      'Guru'
    end
    #Similar logging fix
    puts experience_level


    new_nickname = experience_level + ' Writer'

    #The single line form reads well enough, don't need to separate this into 2 parts (i.e. if !number_of_logics.nil? && number_of_logins == 42)
    if !number_of_logins.nil?
      if number_of_logins == 42
        new_nickname = 'Special ' + new_nickname
      end
    end
    nickname = new_nickname
    save
  end

  #The new set_nickname should look like this (assuming we want to keep the functionality)

  def set_nickname_according_to_blog_post_count
    nickname = generate_nickname_according_to_blog_post_count
    save
  end

  def generate_nickname_according_to_blog_post_count
    new_nickname = get_experience_level + ' Writer'
    if is_number_of_logins_special?
      new_nickname = 'Special ' + new_nickname
    end
    new_nickname    
  end
  
  def get_experience_level
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

  def is_number_of_logins_special?
     !number_of_logics.nil? && number_of_logins == 42
  end  
end

