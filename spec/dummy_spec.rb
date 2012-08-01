require 'spec_helper'

describe XSS do
  it 'should be a module' do
    XSS.should be_a(Module)
  end
end
