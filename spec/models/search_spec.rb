require 'rails_helper'

describe 'Searching objects' do

  it 'should Run Sphinx' do
    expect(ThinkingSphinx).to receive(:search).with('qwerty', classes:[Answer])
    Search.search('qwerty','Answer')
  end
end