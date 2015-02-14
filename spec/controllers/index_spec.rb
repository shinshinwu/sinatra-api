require 'spec_helper'

# test get route for users list
describe "controller test" do

  before :each do
    User.delete_all
    Article.delete_all
    Token.delete_all
    @user1 = User.create(username: "burrito", email: "burrito@burrito.com")
    @user2 = User.create(username: "taco", email: "taco@taco.com")
    @article1 = Article.create(user_id: @user1.id, title: "chipotle", body: "steak and quesadillas")
    @article2 = Article.create(user_id: @user2.id, title: "tacobell", body: "tortilla")
    @token1 = Token.create(user_id: @user1.id)
  end

  context "list of users" do

    it "return 200 status code" do
      get '/api/v1/users'
      expect(last_response.status).to eq(200)
    end

    it "display all users" do
      get '/api/v1/users'
      expect(last_response.body).to include("burrito")
    end
  end

  context "list of articles for a user" do

    it "return 200 status code" do
      get '/api/v1/articles'
      expect(last_response.status).to eq(200)
    end

    it "returns all articles" do
      get '/api/v1/articles'
      expect(last_response.body).to include("chipotle")
    end

    it "return all articles from a specific user" do
      get "/api/v1/users/#{@user1.id}/articles"
      expect(last_response.body).to include("steak")
    end

    it "does not display another user's articles" do
      get "/api/v1/users/#{@user2.id}/articles"
      expect(last_response.body).not_to include("steak")
    end

  end

  context "create a new article by a user" do

    it "return a 201 status code" do
      post "/api/v1/users/#{@user1.id}/articles?token_key=#{@token1.key}", {user_id: @user1.id, title: "awesome", body: "awesomer"}
      expect(last_response.status).to eq(201)
    end

    it "should include newly created article data" do
      post "/api/v1/users/#{@user1.id}/articles?token_key=#{@token1.key}", {user_id: @user1.id, title: "awesome", body: "awesomer"}
      expect(last_response.body).to include("awesome")
    end

  end

  context "create a new comment for an article by a user" do

    it "return a 201 status code" do
      post "/api/v1/users/#{@user1.id}/articles/#{@article1.id}/comments?token_key=#{@token1.key}", {user_id: @user1.id, article_id: @article1.id, body: "yummy in my tummy"}
      expect(last_response.status).to eq(201)
    end

    it "should include a newly created comment for the article" do
      post "/api/v1/users/#{@user1.id}/articles/#{@article1.id}/comments?token_key=#{@token1.key}", {user_id: @user1.id, article_id: @article1.id, body: "yummy in my tummy"}
      expect(last_response.body).to include("yummy")
    end

  end

  context "get API key" do

    it "return a 200 status code" do
      get "/api/v1/users/#{@user1.id}/key/new"
      expect(last_response.status).to eq(200)
    end


    it "should generate a new token" do
      expect {
        get "/api/v1/users/#{@user1.id}/key/new"
      }.to change {
        Token.all.count
        @user1.tokens.count
      }.by(1)
    end

  end

  context "POST requests require an API key" do

    it "articles without API key will not be created" do
      expect {
        post "/api/v1/users/#{@user1.id}/articles", {user_id: @user1.id, title: "awesome", body: "awesomer"}
      }.to change {
        @user1.articles.count
      }.by(0)
    end

    it "articles with an API key will be created" do
      expect {
        post "/api/v1/users/#{@user1.id}/articles?token_key=#{@token1.key}", {user_id: @user1.id, title: "awesome", body: "awesomer"}
      }.to change {
        @user1.articles.count
      }.by(1)
    end

    it "comments without API key will not be created" do
      expect {
        post "/api/v1/users/#{@user1.id}/articles/#{@article1.id}/comments", {user_id: @user1.id, article_id: @article1.id, body: "yummy in my tummy"}
      }.to change {
        @user1.comments.count
        @article1.comments.count
      }.by(0)
    end

    it "comments with an API key will be created" do
      expect {
        post "/api/v1/users/#{@user1.id}/articles/#{@article1.id}/comments?token_key=#{@token1.key}", {user_id: @user1.id, article_id: @article1.id, body: "yummy in my tummy"}
      }.to change {
        @user1.comments.count
        @article1.comments.count
      }.by(1)
    end

  end

  context "every time API key is used, times_used increases by 1" do

    it "increases by 1 when creating article" do
      expect {
        post "/api/v1/users/#{@user1.id}/articles?token_key=#{@token1.key}", {user_id: @user1.id, title: "awesome", body: "awesomer"}
      }.to change {
        @token1.reload.times_used
      }.by(1)
    end

    it "increases by 1 when creating comment" do
      expect {
        post "/api/v1/users/#{@user1.id}/articles/#{@article1.id}/comments?token_key=#{@token1.key}", {user_id: @user1.id, article_id: @article1.id, body: "yummy in my tummy"}
      }.to change {
        @token1.reload.times_used
      }.by(1)
    end

  end

end
