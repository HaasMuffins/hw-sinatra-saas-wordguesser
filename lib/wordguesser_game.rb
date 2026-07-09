class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    unless letter.is_a?(String) && letter.match?(/\A[a-zA-Z]\z/)
      raise ArgumentError
    end

    letter = letter.downcase

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.downcase.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end

    true
  end

  def word_with_guesses
    @word.chars.map do |letter|
      if @guesses.include?(letter.downcase)
        letter
      else
        '-'
      end
    end.join
  end

  def check_win_or_lose
    if !word_with_guesses.include?('-')
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'

    uri = URI('https://randomword.saasbook.info/RandomWord')

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end
