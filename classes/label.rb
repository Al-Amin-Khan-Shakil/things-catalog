require 'securerandom'
require_relative 'item'
require 'date'

class Label
  attr_accessor :title, :string
  attr_reader :id, :items

  def initialize(title, color)
    @id = SecureRandom.uuid
    @title = title
    @color = color
    @items = []
  end

  def add_item(item)
    @items << item
    item.label = self
  end
end
