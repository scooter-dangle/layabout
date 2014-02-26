# encoding: utf-8
require File.expand_path('../../lib/layabout.rb', __FILE__)
require 'pry'


describe RUBY_VERSION do
  it do
    expect(subject).to match(/^\d\.\d\.\d$/)
    expect(subject).not_to match(/^1\.\d\.\d$/)
  end
end

describe Layabout do
  it do
    expect(subject::Rect.new).to be_a(Layabout::Rect)

    expect(subject.rect).to be_a(Layabout::Rect)
  end
end

describe (Layabout::Rect.new) do
  it do
    [:width, :height, :x, :y, :rect].each {|methd| expect(subject).to respond_to(methd) }
  end

  it 'sensible defaults' do
    [:width, :height, :x, :y].each {|methd| expect(subject.send methd).to be_zero }
  end
end

describe Layabout::Rect do
  it do
    opts = { width: 10, height: 10, x: 15, y: 15 }
    r = Layabout.rect(opts)
    opts.each {|(methd, val)| expect(r.send methd).to be(val) }
  end

  it do
    outer_shield = BasicObject.new
    r = Layabout.rect do
      rect :shield, width: 5
      outer_shield = shield
    end
    expect(r).to respond_to(:shield)
    expect(r.shield).to be_a(Layabout::Rect)
    expect(r.shield.width).to be(5)
    expect(r.shield).to be(outer_shield)
  end

  it do
    outer_shield = BasicObject.new
    r = Layabout.rect do
      rect :shield, width: 5
    end

  end
end

<<MEH_NOTES

# Sortof how things should work?

## Sketch 1
rect = Layabout.rect x: 15 do
  # Create instance variable named shield
  rect :shield, width: 10

  # Add another rectangle above shield rect
  shield.add_above(Layabout.rect align: :centered)
end

# Access the x coördinate of the shield rect
rect.shield.x


## Sketch 2
rect = Layabout.rect do
  rect :shield, width: 15, height: 15
  
  add_above :shield,
    rect(:crest, width: 20, height: 10)

  # Alternate syntax
  shield.is_below rect(:crest,
    width: 20, height: 10)

  # Alternate syntax
  shield.add_above rect(:crest,
    width: 20, height: 10)

  # Alternate syntax
  rect :crest, width:20, height: 10
  shield.below :crest
end
expect(rect.width ).to be(20)
expect(rect.height).to be(25)

MEH_NOTES