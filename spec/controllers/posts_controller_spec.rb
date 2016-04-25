require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:user)      { FactoryGirl.create(:user) }
  let(:test_post) { FactoryGirl.create(:post) }

  describe "#new" do

    describe "with a signed in user" do

      before do
        request.session[:user_id] = user.id
        get :new
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "assigns a Post object" do
        expect(assigns(:post)).to be_a_new(Post)
      end

    end

    describe "without a signed in user" do

      before { request.session[:user_id] = nil }

      it "redirects to a sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end

    end

  end

  describe "#create" do

    describe "with a signed in user" do

      before { request.session[:user_id] = user.id }

      context "with valid attributes" do

        def valid_post
          post :create, post: {title:"Another Post Overhere", body:"This is the body of the post"}
        end

        it "saves a new post to the database" do
          expect { valid_post }.to change { Post.count }.by 1
        end

        it "associates the created post with the signed in user" do
          valid_post
          expect(Post.last.user_id).to eq(user.id)
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
          expect { invalid_post }.to change { Post.count }.by 0
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

    describe "without a signed in user" do

      before { request.session[:user_id] = nil }

      it "redirects the user to the sign in page" do
        post :create
        expect(response).to redirect_to new_session_path
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

    # TODO: Fix index action in blog - posts_controller_spec
    # it "assigns an instance variable to all posts in the database" do
    #   a = FactoryGirl.create(:post)
    #   b = FactoryGirl.create(:post)
    #
    #   get :index
    #
    #   expect(assigns(:posts)).to eq([a, b])
    # end
  end

  describe "#edit" do

    describe "with a signed in user" do

      context "where post belongs to user" do

        let(:user_post) { FactoryGirl.create(:post, user_id: user.id) }

        before do
          request.session[:user_id] = user.id
          get :edit, id: user_post.id
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end

        it "sets a Post instance variable with the passed id" do
          expect(assigns(:post)).to eq(user_post)
        end
      end

      context "where post does not belong to user" do

        let(:not_user_post) { FactoryGirl.create(:post) }

        before do
          request.session[:user_id] = user.id
          get :edit, id: not_user_post.id
        end

        it "redirects to the Post show page" do
          expect(response).to redirect_to post_path(not_user_post)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end

      end

    end

    describe "without a signed in user" do

      before { request.session[:user_id] = nil }

      it "redirects to a sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end

    end

  end

  describe "#update" do

    describe "with a signed in user" do

      before { request.session[:user_id] = user.id }

      describe "where post belongs to user" do

        let(:user_post) { FactoryGirl.create(:post, user_id: user.id)}

        context "with valid parameters" do

          let(:new_valid_body) { Faker::Hipster.paragraph(2) }

          before do
            patch :update, id: user_post.id, post: { body: new_valid_body }
          end

          it "updates the Post which id is passed" do
            expect(user_post.reload.body).to eq(new_valid_body)
          end

          it "redirects to the show page of the Post" do
            expect(response).to redirect_to (post_path(user_post))
          end

          it "sets a flash message" do
            expect(flash[:notice]).to be
          end
        end

        context "with invalid parameters" do
          before do
            patch :update, id: user_post.id, post: { title: "" }
          end

          it "does not update the Post" do
            expect(user_post.title).to eq(user_post.reload.title)
          end

          it "renders the edit template" do
            expect(response).to render_template(:edit)
          end

          it "sets a flash message" do
            expect(flash[:alert]).to be
          end
        end
      end

      describe "where post does not belong to user" do

        let(:not_user_post) { FactoryGirl.create(:post) }

        # TODO: ActionController::ParameterMissing: - param is missing or the value is empty: post
        before do
          patch :update, id: not_user_post.id
        end

        it "redirects to the Post show page" do
          expect(response).to redirect_to post_path(not_user_post)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to be
        end
      end

    end

    describe "without a signed in user" do

      before { request.session[:user_id] = nil }

      it "redirects to a sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end

    end

  end

  # TODO: Something wrong with destroy
  describe "#destroy" do

    describe "with a signed in user" do

      before { request.session[:user_id] = user.id }

      describe "where post belongs to user" do

        let(:user_post) { FactoryGirl.create(:post, user_id: user) }

        # TODO: Adding a record instead of deleting a record?
        # it "removes a Post from the database" do
        #   count_before = Post.count
        #   delete :destroy, id: user_post.id
        #   count_after = Post.count
        #
        #   expect(count_after).to eq(count_before - 1)
        # end

        it "redirects to the index page" do
          delete :destroy, id: user_post.id
          expect(response).to redirect_to(posts_path)
        end

        it "sets a flash massage" do
          delete :destroy, id: user_post.id
          expect(flash[:notice]).to be
        end
      end

      describe "where post does not belong to user"

    end

    describe "without a signed in user" do

      before { request.session[:user_id] = nil }

      it "redirects to a sign in page" do
        get :new
        expect(response).to redirect_to new_session_path
      end

    end


  end

end
