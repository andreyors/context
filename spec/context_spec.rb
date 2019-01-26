# frozen_string_literal: true

require "spec_helper"

RSpec.describe Context do
  it "has a version number" do
    pattern = /\d+.\d+.\d+/

    expect(pattern.match(Context::VERSION)).to be_truthy
  end

  it "returns a proper instance" do
    expect(described_class.configure).to be_an_instance_of Context::ThreadAware
  end
end
