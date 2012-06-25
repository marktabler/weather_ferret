require 'spec_helper'

describe Ferrety::WeatherFerret do
  it "can accept JSON parameters on initialize" do
    Ferrety::WeatherFerret.new('{"zip":"97086"}').zip.should == '97086'
  end

  it "can accept Hash parameters on initialize" do
    Ferrety::WeatherFerret.new("zip" => '97086').zip.should == '97086'
  end

  context "in private methods" do
    before(:each) do 
      @ferret = Ferrety::WeatherFerret.new({})
      @ferret.stub(:todays_high).and_return(95)
      @ferret.stub(:todays_low).and_return(50)
      @ferret.stub(:todays_condition).and_return("Scattered storms")
    end

    it "alerts when a high temperature exceeds the high threshold" do
      @ferret.high_threshold = 90
      @ferret.send(:check_temp_ranges)
      @ferret.alerts.size.should == 1
    end

    it "alerts when a low temperature falls below the low threshold" do
      @ferret.low_threshold = 55
      @ferret.search
      @ferret.alerts.size.should == 1
    end

    it "does not alert temperatures within the thresholds" do
      @ferret.high_threshold = 105
      @ferret.low_threshold = 45
      @ferret.search
      @ferret.alerts.size.should == 0
    end

    it "alerts when a forecast includes a search term" do
      @ferret.term = "storm"
      @ferret.search
      @ferret.alerts.size.should == 1
    end

    it "does not alert when the forecast does not include a search term" do
      @ferret.term = "meatballs"
      @ferret.search
      @ferret.alerts.size.should == 0
    end
  end
end