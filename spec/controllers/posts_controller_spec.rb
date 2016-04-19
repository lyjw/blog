require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:test_post) { FactoryGirl.create(:post) }

  describe "#new" do

    before { get :new }

    it "renders the new template" do
      expect(response).to render_template(:new)
    end

    it "assigns a Post object" do
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "#create" do

    context "with valid attributes" do

      def valid_post
        post :create, post: {title:"Another Post Overhere", body:"This is the body of the post"}
      end

      it "saves a new post to the database" do
        count_before = Post.count
        valid_post
        count_after = Post.count

        expect(count_after).to eq(count_before + 1)
      end

      it "redirects to the post show page" do
        valid_post
        expect(response).to redirect_to(post_path(Post.last))
      end

      it "sets a flash message" do
        valid_post
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do

      def invalid_post
        post :create, post: {title:"Title", body:"abc"}
      end

      it "does not create a record in the database" do
        count_before = Post.count
        invalid_post
        count_after = Post.count

        expect(count_after).to eq(count_before)
      end

      it "renders the post new page" do
        invalid_post
        expect(response).to render_template(:new)
      end

      it "sets a flash message" do
        invalid_post
        expect(flash[:alert]).to be
      end

    end

  end

  describe "#show" do

    before do
      get :show, id: test_post.id
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "sets a Post instance variable" do
      expect(assigns(:post)).to eq(test_post)
    end
  end

  describe "#index" do
    it "renders the index page" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns an instance variable to all posts in the database" do
      a = FactoryGirl.create(:post)
      b = FactoryGirl.create(:post)

      get :index

      expect(assigns(:posts)).to eq([a, b])
    end
  end

  describe "#edit" do
    before do
      get :edit, id: test_post.id
    end

    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end

    it "sets a Post instance variable with the passed id" do
      expect(assigns(:post)).to eq(test_post)
    end
  end

  describe "#update" do

    context "with valid parameters" do

      let(:new_valid_body) { Faker::Hipster.paragraph(2) }

      before do
        patch :update, id: test_post.id, post: { body: new_valid_body }
      end

      it "updates the Post which id is passed" do
        expect(test_post.reload.body).to eq(new_valid_body)
      end

      it "redirects to the show page of the Post" do
        expect(response).to redirect_to (post_path(test_post))
      end

      it "sets a flash message" do
        expect(flash[:notice]).to be
      end
    end

    context "with invalid parameters" do
      before do
        patch :update, id: test_post.id, post: { title: "" }
      end

      it "does not update the Post" do
        expect(test_post.title).to eq(test_post.reload.title)
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

      it "sets a flash message" do
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#destroy" do
    it "removes a Post from the database" do
      test_post
      count_before = Post.count
      delete :destroy, id: test_post.id
      count_after = Post.count

      expect(count_after).to eq(count_before - 1)
    end

    it "redirects to the index page" do
      delete :destroy, id: test_post.id
      expect(response).to redirect_to(posts_path)
    end

    it "sets a flash massage" do
      delete :destroy, id: test_post.id
      expect(flash[:alert]).to be
    end
  end

end
