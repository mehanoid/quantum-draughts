# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'matches/show', type: :view do
  before(:each) do
    @match = assign(:match, Match.create!(
      :boards => ''
    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
  end
end
