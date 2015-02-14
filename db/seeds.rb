require_relative '../spec/factories'
10.times {
  user = FactoryGirl.create :user
  rand(6).times {
    article = FactoryGirl.create :article, :user => user
    rand(10).times {
      FactoryGirl.create :comment, :user => user, :article => article
    }
  }
}
