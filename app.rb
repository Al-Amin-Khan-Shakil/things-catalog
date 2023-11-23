require_relative 'classes/game'
require_relative 'classes/author'
require_relative 'classes/music'
require_relative 'classes/genre'
require_relative 'classes/book'
require_relative 'classes/label'
require_relative 'data_manager'
require './modules/author_module'
require './modules/game_module'
require './modules/storage'
require 'json'

class App
  include GameModule
  include AuthorModule
  include StorageModule
  attr_reader :labels, :games, :authors

  def initialize
    @books = DataManager.load_books
    @labels = DataManager.load_labels
    @album = DataManager.load_album
    @genre = DataManager.load_genre
    prep_for_storage
    @games = load_games
    @authors = load_authors
  end

  def list_books
    if @books.empty?
      puts 'There is no book in your collection'
    else
      @books.each_with_index do |book, index|
        print "Publish date: #{book.publish_date} Publisher: #{book.publisher} Cover-state: #{book.cover_state} "
        print "Book-title: #{@labels[index].title}\n"
      end
    end
    puts
  end

  def list_labels
    if @labels.empty?
      puts 'There is no labels in your collection'
    else
      @labels.each_with_index do |label, index|
        puts "#{index}. Label: #{label.title} Color: #{label.color}"
      end
    end
    puts
  end

  def add_new_book
    puts 'Title of book: '
    title = gets.chomp
    puts 'Published date (dd/mm/yy): '
    publish_date = Date.parse(gets.chomp)
    puts 'Publisher: '
    publisher = gets.chomp
    puts 'Color of cover: '
    color = gets.chomp
    puts 'Cover-state (good or bad): '
    cover_state = gets.chomp
    new_book = Book.new(publish_date, publisher, cover_state)
    new_label = Label.new(title, color)
    new_label.add_item(new_book)
    @books << new_book
    @labels << new_label
    DataManager.save_book(@books)
    DataManager.save_label(@labels)
    puts 'Book added successfully'
  end
  
  def list_album
    if @album.empty?
      puts 'There are no albums saved currently'
    else
      @album.each_with_index do |album, index|
        puts "#{index}. On Spotify? : #{album.on_spotify} Date: #{album.publish_date}"
      end
    end
    puts
  end

  def list_genre
    if @genre.empty?
      puts 'There are no genres saved currently'
    else
      @genre.each_with_index do |genre, index|
        puts "#{index}. Genre: #{genre.name}"
      end
    end
    puts
  end

  def add_new_album
    puts 'Enter a date: DD/MM/YYYY'
    album_date = gets.chomp
    puts 'enter Y if it\'s on spotify or N if it\'s not'
    on_spotify = gets.chomp.downcase == 'y'
    puts 'Enter a genre:'
    genre = gets.chomp
    new_album = MusicAlbum.new(on_spotify: on_spotify, publish_date: album_date)
    new_genre = Genre.new(genre)
    new_genre.add_item(new_album)
    @album << new_album
    @genre << new_genre
    DataManager.save_album(@album)
    DataManager.save_genre(@genre)
    puts 'Album added successfully'
  end
  def prep_for_storage
    create_file('games')
    create_file('authors')
  end
    
  def save_data
    save_to_file(@games.map(&:to_hash), 'games')
    save_to_file(@authors.map(&:to_hash), 'authors')
  end
end
