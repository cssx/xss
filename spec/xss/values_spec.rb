require 'spec_helper'

describe XSS::Values do
  describe XSS::Values::Number do
    it 'should be able to compare 2 number using #==' do
      V::Number.new(123).should == V::Number.new(123)
    end
  end
end
