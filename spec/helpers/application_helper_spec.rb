#  require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'spec_helper'

  describe ApplicationHelper do
    include ApplicationHelper

    describe "Overall UI methods" do
      it "should get the local application name" do
        application_name.should == "Hydrant"
      end
    end

  end
