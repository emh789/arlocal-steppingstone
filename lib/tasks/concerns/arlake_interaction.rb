class Arlake::Interaction


  require 'io/console'


  class PasswordNotConfirmed < ::StandardError
  end
  


  protected

  
  def self.ask(question: '', default: nil, options: [])
    answer = default
    response = new(question: question, options: options).ask
    if response.to_s != ''
      answer = response
    end
    answer  
  end  
  

  def self.ask_for_attribute(resource, attribute, default: nil, options: [])
    answer = {}
    question = attribute.to_s
    currently = resource.send(attribute)

    response = new(question: question, currently: currently, options: options).ask

    case default
    when nil, ''
      if response.to_s != ''
        answer[attribute] = response
      end
    else
      if response.to_s != ''
        answer[attribute] = response
      else
        answer[attribute] = default
      end
    end
    answer
  end
  
  
  def self.ask_for_password_and_confirm
    attributes = {}
    password = new(question: 'New password').ask_secret
    if password.to_s != ''
      confirm = new(question: 'Confirm password').ask_secret
      if password == confirm
        attributes['password'] = password
      else
        raise PasswordNotConfirmed
      end
    end
    attributes
  end
  
  
    
  public


  def initialize(question: nil, options: [], currently: nil)
    @question = question
    @options = options
    @currently = currently.to_s
  end

    
  def ask
    STDOUT.print build_prompt
    answer = STDIN.gets("\n").chomp.strip
    answer
  end
  
  
  def ask_secret
    STDOUT.print build_prompt
    answer = STDIN.noecho(&:gets).chomp.strip
    STDOUT.print "\n"
    answer
  end



  private
  
  
  def build_prompt
    prompt = "> #{@question}"
    if @currently != ''
      prompt << " (#{@currently})"
    end
    if @options.any?
      prompt << " [#{@options.map {|o| o.to_s}.join('/')}]"
    end
    prompt << ': '
    prompt
  end
    

end
