require 'rails_helper'

RSpec.describe Comment, type: :model do

  describe "validations" do
    it "requires a body" do
      c = Comment.new FactoryGirl.attributes_for(:comment, body: "")
      expect(c).to be_invalid
    end
  end

end
