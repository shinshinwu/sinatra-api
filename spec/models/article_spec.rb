require 'spec_helper'

describe Article do
  context "#associations" do
    it { should belong_to :user }
    it { should have_many :comments }
  end
end
