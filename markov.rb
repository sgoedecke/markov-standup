# A simple markov chain text generator. Takes a string of text. Works best on text with many short sentences.
# Internal structure: a dictionary. To find a word that has followed word X, choose any word from the array
# of words at dict[X].

class MarkovChainTextGenerator
  def initialize(text)
    @dict = build_dictionary(text)
    @first_words = []
    @last_words = []
    split_into_sentences(text).each do |sentence|
      @first_words << sentence.split(" ").first
      @last_words << sentence.split(" ").last
    end
  end

  def generate_sentence
    first_word = @first_words.sample
    sentence = [first_word]
    # sometimes this ends a sentence pretty early (e.g. when one word both starts and ends some sentences)
    until @last_words.include?(sentence.last)
      sentence << @dict[sentence.last].sample
    end
    return sentence.join(" ") + "."
  end

  private

  def build_dictionary(text)
    dict = {}

    split_into_sentences(text).each do |sentence|
      words = sentence.split(" ")
      words.each_with_index do |word, i|
        next_word = words[i+1]
        next if next_word.nil?
        # put the following word into the dictionary under the key of the current word
        if dict[word].nil?
          dict[word] = [next_word]
        else
          dict[word] << next_word
        end
      end
    end
    return dict
  end

  def split_into_sentences(text)
    # remove punctuation and split text into an array of sentences
    text
      .gsub(/;|-/,". ") # replace semi colons and dashes with full stops
      .gsub(/\n/," ") # replace new lines with spaces
      .gsub(/,|:/,'') # just strip commas/colons
      .split(". ")
      .map { |s| s.gsub(/\./,'')} # make sure we kill any extra full stops afterward
      .each { |s| s[0] = s[0].capitalize } # make sure the first letter of each sentence is capitalized
  end
end
