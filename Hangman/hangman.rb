require 'yaml'
require 'fileutils'
require 'open-uri'

DICT_FILENAME = 'google-10000-english-no-swears.txt'
DICT_RAW_URL = 'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt'
SAVE_DIR = 'saves'
MIN_WORD_LEN = 5
MAX_WORD_LEN = 12
MAX_INCORRECT = 6 

FileUtils.mkdir_p(SAVE_DIR)

class Hangman
  attr_accessor :secret, :correct_letters, :wrong_letters, :max_incorrect

  def initialize(secret, max_incorrect = MAX_INCORRECT)
    @secret = secret.downcase
    @correct_letters = Array.new(@secret.length, '_')
    @wrong_letters = []
    @max_incorrect = max_incorrect
  end

  def display_state
    puts "\nСлово: " + @correct_letters.join(' ')
    puts "Невірні літери: #{wrong_letters.empty? ? '-' : wrong_letters.join(', ')}"
    puts "Залишилося спроб: #{remaining_guesses}"
  end

  def remaining_guesses
    max_incorrect - @wrong_letters.length
  end

  def game_won?
    !@correct_letters.include?('_')
  end

  def game_lost?
    remaining_guesses <= 0
  end

  def already_guessed?(letter)
    @correct_letters.include?(letter) || @wrong_letters.include?(letter)
  end

  def guess_letter(letter)
    letter = letter.downcase
    return :already if already_guessed?(letter)

    if @secret.chars.include?(letter)
      @secret.chars.each_with_index do |ch, idx|
        @correct_letters[idx] = ch if ch == letter
      end
      :correct
    else
      @wrong_letters << letter
      :wrong
    end
  end

  def to_yaml
    YAML.dump({
      'secret' => @secret,
      'correct_letters' => @correct_letters,
      'wrong_letters' => @wrong_letters,

      require 'yaml'
      require 'fileutils'
      require 'open-uri'

      DICTIONARY_FILE = 'google-10000-english-no-swears.txt'
      DICTIONARY_URL = 'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt'
      SAVES_DIR = 'saves'
      MIN_LEN = 5
      MAX_LEN = 12
      MAX_MISTAKES = 6

      FileUtils.mkdir_p(SAVES_DIR)

      class GameState
        attr_reader :target, :revealed, :bad_guesses, :max_mistakes

        def initialize(word, max_mistakes = MAX_MISTAKES)
          @target = word.downcase
          @revealed = Array.new(@target.length, '_')
          @bad_guesses = []
          @max_mistakes = max_mistakes
        end

        def display
          puts
          puts "Слово: #{revealed.join(' ')}"
          puts "Невірні: #{bad_guesses.empty? ? '-' : bad_guesses.join(', ')}"
          puts "Залишилось спроб: #{left_attempts}"
        end

        def left_attempts
          max_mistakes - bad_guesses.size
        end

        def won?
          !revealed.include?('_')
        end

        def lost?
          left_attempts <= 0
        end

        def guessed?(ch)
          revealed.include?(ch) || bad_guesses.include?(ch)
        end

        def submit(ch)
          ch = ch.downcase
          return :already if guessed?(ch)

          if target.include?(ch)
            target.chars.each_with_index { |c, i| revealed[i] = c if c == ch }
            :hit
          else
            bad_guesses << ch
            :miss
          end
        end

        def dump_yaml
          YAML.dump({ 'target' => target, 'revealed' => revealed, 'bad_guesses' => bad_guesses, 'max_mistakes' => max_mistakes })
        end

        def self.restore(yaml_str)
          data = YAML.safe_load(yaml_str)
          g = allocate
          g.instance_variable_set(:@target, data['target'])
          g.instance_variable_set(:@revealed, data['revealed'])
          g.instance_variable_set(:@bad_guesses, data['bad_guesses'])
          g.instance_variable_set(:@max_mistakes, data['max_mistakes'] || MAX_MISTAKES)
          g
        end
      end

+      def ensure_dictionary_present
        return if File.exist?(DICTIONARY_FILE)

        puts "Словника (#{DICTIONARY_FILE}) не знайдено."
        print "Завантажити з GitHub? (y/n): "
        answer = STDIN.gets&.chomp&.downcase
        if answer == 'y'
          begin
            puts 'Завантаження...'
            URI.open(DICTIONARY_URL) do |remote|
              File.open(DICTIONARY_FILE, 'wb') { |f| f.write(remote.read) }
            end
            puts "Словник збережено в #{DICTIONARY_FILE}"
          rescue => e
            puts "Не вдалося скачати словник: #{e.message}"
            puts "Покладіть файл #{DICTIONARY_FILE} поруч зі скриптом і спробуйте ще раз."
            exit(1)
          end
        else
          puts 'Гра не може працювати без словника. Завантажте файл і запустіть знову.'
          exit(1)
        end
      end

      def load_word_list
        ensure_dictionary_present
        pool = []
        File.foreach(DICTIONARY_FILE) do |ln|
          w = ln.strip
          next unless w =~ /\A[a-zA-Z]+\z/ && w.length.between?(MIN_LEN, MAX_LEN)
          pool << w.downcase
        end
        if pool.empty?
          puts "У файлі словника відсутні слова довжиною від #{MIN_LEN} до #{MAX_LEN}."
          exit(1)
        end
        pool
      end

      def pick_random_word(list)
        list.sample
      end

      def saved_files
        Dir.glob(File.join(SAVES_DIR, '*.yml')).sort
      end

      def show_saves
        files = saved_files
        if files.empty?
          puts 'Збережень немає.'
          return []
        end
        puts 'Збереження:'
        files.each_with_index { |p, i| puts "#{i + 1}) #{File.basename(p)} (#{File.size(p)} bytes)" }
        files
      end

      def choose_save_file
        files = show_saves
        return nil if files.empty?
        print "Введіть номер для завантаження або Enter для нової гри: "
        choice = STDIN.gets&.chomp
        return nil if choice.nil? || choice.strip.empty?
        idx = choice.to_i
        return nil if idx <= 0 || idx > files.length
        files[idx - 1]
      end

      def write_save(game)
        ts = Time.now.strftime('%Y%m%d_%H%M%S')
        fn = File.join(SAVES_DIR, "hangman_#{ts}.yml")
        File.write(fn, game.dump_yaml)
        puts "Гра збережена у #{fn}"
      end

      def run
        words = load_word_list

        puts '=== Шибениця ==='
        puts '1) Нова гра'
        puts '2) Відкрити збережену'
        print 'Оберіть (1/2): '
        choice = STDIN.gets&.chomp

        state = nil
        if choice == '2'
          path = choose_save_file
          if path
            begin
              state = GameState.restore(File.read(path))
              puts "Завантажено: #{File.basename(path)}"
            rescue => e
              puts "Не вдалося відкрити збереження: #{e.message}"
              puts 'Стартує нова гра.'
            end
          end
        end

        state ||= GameState.new(pick_random_word(words))

        loop do
          puts '-' * 30
          state.display

          if state.won?
            puts "Перемога! Слово: #{state.target.upcase}"
            break
          elsif state.lost?
            puts "Програш. Слово було: #{state.target.upcase}"
            break
          end

          puts "На початку ходу можеш ввести літеру або 'save' щоб зберегти"
          print 'Ваш вибір: '
          input = STDIN.gets&.chomp
          if input.nil?
            puts 'Вихід.'
            break
          end
          token = input.strip

          if token.downcase == 'save'
            write_save(state)
            next
          end

          unless token.length == 1 && token =~ /\A[a-zA-Z]\z/
            puts "Введіть одну букву (a..z) або 'save'."
            next
          end

          letter = token.downcase
          res = state.submit(letter)
          case res
          when :already
            puts "Ви вже вводили '#{letter}'."
          when :hit
            puts "Добре! '#{letter}' є в слові."
          when :miss
            puts "Ні, '#{letter}' немає в слові."
          end
        end

        puts 'Дякую за гру!'
      end

      if __FILE__ == $0
        run
      end