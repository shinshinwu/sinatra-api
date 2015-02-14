before '/api/*' do
  content_type :json
end

get '/api/v1/users' do
  User.all.to_json
end

get '/api/v1/articles' do
  Article.all.to_json
end

get '/api/v1/users/:user_id/articles' do
  user = User.find(params[:user_id])
  user.articles.to_json
end

post '/api/v1/users/:user_id/articles' do
  token = params[:token_key]
  user = User.find(params[:user_id])
  if token.nil?
    halt 401, {errors: "User cannot create articles without token"}.to_json
  elsif Token.find_by(key: token).user_id == user.id
    key = Token.find_by(key: token)
    key.times_used += 1
    key.save
    new_article = Article.new(user_id: user.id, title: params[:title], body: params[:body])
    if new_article.save
      status 201
      new_article.to_json
    else
      halt 400, {errors: new_article.errors}.to_json
    end
  else
    halt 401, {errors: "Token invalid"}.to_json
  end
end

post '/api/v1/users/:user_id/articles/:article_id/comments' do
  token = params[:token_key]
  user = User.find(params[:user_id])
  if token.nil?
    halt 401, {errors: "User cannot create articles without token"}.to_json
  elsif Token.find_by(key: token).user_id == user.id
    key = Token.find_by(key: token)
    key.times_used += 1
    key.save
    article = Article.find(params[:article_id])
    new_comment = Comment.new(user_id: user.id, article_id: article.id, body: params[:body])
    if new_comment.save
      status 201
      new_comment.to_json
    else
      halt 400, {errors: new_comment.errors}.to_json
    end
  else
    halt 401, {errors: "Token invalid"}.to_json
  end
end

get '/api/v1/users/:user_id/key/new' do
  new_token = Token.create(user_id: params[:user_id])
  new_token.to_json
end




