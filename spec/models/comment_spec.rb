require 'spec_helper'

describe Comment do
  context "#associations" do
    it { should belong_to :user }
    it { should belong_to :article }
  end
end
