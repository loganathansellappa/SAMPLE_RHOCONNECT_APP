require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Developer" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Developer,'testuser'
    end

    it "should process Developer query" do
      pending
    end

    it "should process Developer create" do
      pending
    end

    it "should process Developer update" do
      pending
    end

    it "should process Developer delete" do
      pending
    end
  end  
end