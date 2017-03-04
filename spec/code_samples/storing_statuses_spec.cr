require "../spec_helper"

module SfCodeSamples::StoringStatuses
  class IsMosop
    extend Sf::AsStatusOwner

    status :success
    status :failure

    getter name : String

    def initialize(@name : String)
    end

    def validate
      if @name == "mosop"
        success!
      else
        failure!
      end
    end
  end

  it self.name do
    mosops = IsMosop::Statuses.new
    %w(mosop mosop mosop usop).each do |name|
      mosops.continue do
        IsMosop.new(name).validate
      end
    end

    mosops[0].status.name.should eq "success"
    mosops[1].status.name.should eq "success"
    mosops[2].status.name.should eq "success"
    mosops[3].status.name.should eq "failure"
    mosops[0].name.should eq "mosop"
    mosops[1].name.should eq "mosop"
    mosops[2].name.should eq "mosop"
    mosops[3].name.should eq "usop"
    mosops.success[0].name.should eq "mosop"
    mosops.success[1].name.should eq "mosop"
    mosops.success[2].name.should eq "mosop"
    mosops.failure[0].name.should eq "usop"
    mosops.has_success?.should be_true
    mosops.has_failure?.should be_true
  end
end
