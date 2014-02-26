# encoding: utf-8
require File.expand_path('../../lib/layabout.rb', __FILE__)
require 'pry'

RSpec.configure do |c|
  c.alias_example_to :expect_it
end

RSpec::Core::MemoizedHelpers.module_eval do
  alias to     should
  alias to_not should_not
end


describe RUBY_VERSION do
  expect_it { to match(/^2\.\d\.\d$/) }
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
    r = Layabout.rect do
      rect :shield
    end
    expect(r).to respond_to(:shield)
    expect(r.shield).to be_a(Layabout::Rect)
  end
end

rect = Layabout.rect x: 15 do
  rect :shield, width: 10
  shield.add_above(Layabout.rect align: :centered)

end

rect.shield.x

<<MEH
# Note: The following is idealized code for an unimplemented API

, origin: [0, 0], reverse_axis: :y, quadrant: 3
rect = Layabout::Rect.new(:svg) do
end

MEH
