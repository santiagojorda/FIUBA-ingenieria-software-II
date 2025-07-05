require 'spec_helper'
require_relative '../lib/version'

describe 'version' do
  it 'deberia tener 3 numeros' do
    expect(Version.current.split('.').size).to eq 3
  end
end
