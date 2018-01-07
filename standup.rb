require_relative 'markov'

text = ARGV.first

raise 'You must pass some text' if text.nil?
if !text.include?(" ")
  # assume it's a filename and grab the text from a file
  text = File.read(text)
end

# generate the text
chain = MarkovChainTextGenerator.new(text)
generated_text = ""
10.times do
  generated_text <<  " " + chain.generate_sentence
end

puts generated_text
