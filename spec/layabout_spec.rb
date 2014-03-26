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
    opts.each {|(methd, val)| expect(r.send methd).to eq(val) }
  end

  it do
    outer_shield = BasicObject.new
    r = Layabout.rect do
      rect :shield, width: 5, height: 15
      outer_shield = shield
    end
    expect(r).to respond_to(:shield)
    expect(r.shield).to be_a(Layabout::Rect)
    expect(r.shield.width).to eq(5)
    expect(r.shield.height).to eq(15)
    expect(r.shield).to be(outer_shield)
  end

  pending do
    outer_shield = BasicObject.new
    r = Layabout.rect width: :infer do
      rect :shield, width: 5
    end
    expect(r.width).to eq(0)
  end

  # Let's be as explicit in our declarations as we can tolerate
  it do
    r = Layabout.rect width: 100, height: 200 do
      rect :shield,
        width: 10, height: 20,
        x: :center, y: :center

      rect :header,
        width: 20, height: 50,
        x: :left, y: :top

      rect :footer,
        width: 20, height: 50,
        x: :right, y: :bottom
    end

    expect(r.shield.x).to eq(45)
    expect(r.shield.y).to eq(90)

    expect(r.header.x).to eq(0)
    expect(r.header.y).to eq(0)

    expect(r.footer.x).to eq(80)
    expect(r.footer.y).to eq(150)
  end

  # relative layout
  it do
    r = Layabout.rect width: 100, height: 200 do
      rect :shield,
        width: 10, height: 20,
        x: :center, y: :center

      rect :charge_dexter,
        width: 10, height: 40,
        # The x opt of :right means charge_dexter is
        # flush with shield on *charge_dexter's* right
        # side...i.e., shield will be to the right
        # of charge_dexter... charge_dexter won't be
        # to the right of shield.
        wrt: {shield: {x: :right,
                       y: :center}}
    end

    expect(r.charge_dexter.x).to eq(35)
    expect(r.charge_dexter.y).to eq(80)
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

  # Alternate syntax
  add_above :shield,
    rect(:crest, width: 20, height: 10)

  # Alternate syntax
  add :above, :shield,
    rect(:crest, width: 20, height: 10)

  # Alternate syntax
  above :shield, add:
    rect(:crest, width: 20, height: 10)

  # Alternate syntax
  above :shield, rect: [:crest, {width: 20, height: 10}]
end
expect(rect.width ).to be(20)
expect(rect.height).to be(25)

# Sketch 3
[{type: :rect,
  name: :shield,
  width: 15,
  height: 15},
 {type: :rect,
  name: :crest,
  above: :shield,
  width: 20,
  height: 10}]

expect(rect.width ).to be(20)
expect(rect.height).to be(25)

MEH_NOTES
