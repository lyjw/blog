require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { Post.new }

  describe "validations" do
    it "validates the presence of title" do
      post.valid?
      expect(post.errors).to have_key(:title)
    end

    it "validate the minimum length of title is 7" do
      post.title = "abc"
      post.valid?
      expect(post.errors).to have_key(:title)
    end

    it "validates the presence of body" do
      post.valid?
      expect(post.errors).to have_key(:body)
      # expect(post).to_not be_valid
    end
  end

  describe ".body_snippet" do

    it "returns a maximum of a 100 characters and appends ... if greater than 100 characters in length" do
      a = Post.new(title: "Title", body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco")

      result = a.body_snippet

      expect(result.length).to eq(103)
      expect(result).to eq("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore...")
    end

    it "returns the body if it's 100 characters or less" do
      a = Post.new(title: "Title", body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor")

      result = a.body_snippet

      expect(result).to eq("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor")
    end

  end

end
