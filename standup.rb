require_relative 'markov'

class StandupGenerator
  def initialize(text)
    raise 'You must pass a file with Slack logs' if text.nil?
    @text = File.read(text)
  end

  def generate
    puts "Today: "
    print_generated_text(get_tasks(@text), 3)

    puts "\nYesterday: "
    print_generated_text(get_tasks(@text), 3)

    puts "\nBlockers: "
    print_generated_text(get_blockers(@text), 1)
  end

  private

  def print_generated_text(text, num=10)
    # generate the text
    chain = MarkovChainTextGenerator.new(text)
    generated_text = ""
    num.times do
      generated_text <<  "\n * " + chain.generate_sentence
    end
    puts generated_text
  end

  def get_tasks(text)
    # Use `On your previous report, you mentioned:` to get 'today' data
    text.split('GeekbotAPP')
      .map{|t| t[/#{Regexp.escape("On your previous report, you mentioned:")}(.*?)\n\n/m, 1]}
      .compact
      .join('. ')
      .gsub("- ", "")
      .gsub("* ", "")
      .gsub("..", ".")
  end

  def get_blockers(text)
    # Use `What obstacles are impeding your progress?` to get 'blockers' data
    text.split('GeekbotAPP')
      .map{|t| t[/#{Regexp.escape("What obstacles are impeding your progress?\n\n")}(.*?)\n\n/m, 1]}
      .compact
      .map { |s| s.slice(s.index("]\n")+2..-1)} # slice off names
      .join('. ')
      .gsub("- ", "")
      .gsub("* ", "")
      .gsub("..", ".")
  end
end


text = ARGV.first

StandupGenerator.new(text).generate
