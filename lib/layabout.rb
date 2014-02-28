# encoding: utf-8
# layabout.rb
require 'ostruct'

module Layabout

  def self.rect *args, &block
    Rect.new *args, &block
  end

  #class Rect < OpenStruct
  class Rect
    attr_reader :width, :height, :x, :y

    def initialize width: 0, height: 0, x: 0, y: 0, &block
      @width = width
      @height = height
      @x = x
      @y = y
      @contents = []
      instance_exec &block if block_given?
    end

    def rect name=nil, opts={}
      singleton_class.class_exec { attr_reader name }
      out = instance_variable_set "@#{name}", Layabout.rect(opts)
      @contents << out
      out
    end
  end
end