require 'spec_helper'
describe 'rattic' do

  context 'with defaults for all parameters' do
    it { should contain_class('rattic') }
  end
end
