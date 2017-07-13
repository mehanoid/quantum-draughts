require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        :boards => ""
      ),
      Match.create!(
        :boards => ""
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
