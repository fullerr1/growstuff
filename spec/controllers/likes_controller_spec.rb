## DEPRECATION NOTICE: Do not add new tests to this file!
##
## View and controller tests are deprecated in the Growstuff project.
## We no longer write new view and controller tests, but instead write
## feature tests (in spec/features) using Capybara (https://github.com/jnicklas/capybara).
## These test the full stack, behaving as a browser, and require less complicated setup
## to run. Please feel free to delete old view/controller tests as they are reimplemented
## in feature tests.
##
## If you submit a pull request containing new view or controller tests, it will not be
## merged.

require 'rails_helper'

describe LikesController do
  let(:like) { FactoryGirl.create :like, member: member }
  let(:member) { FactoryGirl.create(:member) }
  let(:blogpost) { FactoryGirl.create(:post) }
  let(:mypost) { FactoryGirl.create(:post, author: member) }

  before { sign_in member }

  describe "POST create" do
    before { post :create, post_id: blogpost.id, format: :json }
    it { expect(response.code).to eq('201') }
    it { expect(response.content_type).to eq "application/json" }
    it { expect(Like.last.likeable_id).to eq(blogpost.id) }
    it { expect(Like.last.likeable_type).to eq('Post') }
    it { JSON.parse(response.body)["description"] == "1 like" }
  end

  describe "DELETE destroy" do
    before { delete :destroy, id: like.id, format: :json }
    it { expect(response.code).to eq('200') }
    it { expect(response.content_type).to eq "application/json" }
    it { JSON.parse(response.body)["description"] == "0 likes" }
  end
end
