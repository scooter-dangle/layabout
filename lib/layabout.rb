# encoding: utf-8
# layabout.rb
require 'ostruct'
require 'pry'

module Layabout

  def self.rect *args, &block
    Rect.new *args, &block
  end

  #class Rect < OpenStruct
  class Rect
    attr_reader :width, :height, :x, :y

    def initialize width: 0, height: 0, x: 0, y: 0, wrt: nil, &block
      @width = width
      @height = height
      @x = x
      @y = y
      @contents = []
      instance_exec &block if block_given?
    end

    def rect name=nil, opts={}, &block
      singleton_class.class_exec { attr_reader name }
      opts = handle_wrt opts if opts[:wrt]
      opts = handle_child opts
      out = instance_variable_set "@#{name}", Layabout.rect(opts, &block)
      @contents << out
      out
    end

    protected
    def handle_child opts
      alignments = %i(center left top right bottom)
      %i(x y).each do |axis|
        opts[axis] = handle_align axis, opts if alignments.include? opts[axis]
      end
      opts
    end

    def handle_align axis, opts, reference_object = self
      dimension = case axis
                  when :x then :width
                  when :y then :height
                  end

      case opts[axis]
      when :center
        if opts[:outside]
          #FIXME
        else
          (reference_object.send(dimension).to_f / 2) - (opts[dimension].to_f / 2)
        end
      when :left, :top
        if opts[:outside]
          #FIXME
        else
          reference_object.send axis
        end
      when :right, :bottom
        if opts[:outside]
          #FIXME
        else
          reference_object.send(dimension) - opts[dimension]
        end
      end
    end

    def handle_wrt opts
      opts[:wrt].each do |key, align_opts|
        ref_obj = send(key)
        align_opts.each do |axis, alignment|
          # We're passing in the *original* opts merged with align_opts...
          # ...not just the current align_opts.
          opts[axis] = handle_align axis, opts.merge(align_opts).merge(outside: true), ref_obj
          #binding.pry
        end
      end

      opts
    end
  end
end
