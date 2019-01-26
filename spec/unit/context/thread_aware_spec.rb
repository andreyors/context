# frozen_string_literal: true

require "spec_helper"

RSpec.describe Context::ThreadAware do
  let(:context) { described_class }

  let(:key) { :data }
  let(:value) { "certain-value" }

  before do
    Thread.current[:thread_aware] = nil
    Thread.current[:thread_aware_active] = nil
  end

  describe ".reset!" do
    subject { context.reset! }

    context "when first time called" do
      it "returns an empty storage" do
        subject

        expect(Thread.current[:thread_aware]).to eq({})
      end
    end

    context "when key is stored" do
      let(:value) do
        {
          foo: "bar",
        }
      end

      before do
        Thread.current[:thread_aware] = value
      end

      it "has correct previous value" do
        expect(Thread.current[:thread_aware]).to eq(value)
      end

      it "returns empty storage" do
        subject

        expect(Thread.current[:thread_aware]).to eq({})
      end
    end
  end

  describe ".storage" do
    subject { context.storage }

    context "when first time called" do
      it "returns an empty storage" do
        expect(subject).to eq({})
      end
    end

    context "when key is stored" do
      before do
        context[key] = value
      end

      it "returns a correct hash" do
        expect(subject).to eq(key => value)
      end
    end
  end

  describe ".exists?" do
    subject { context.exist?(key) }

    let(:key) { :data }

    context "when key does not exist" do
      it "returns false" do
        expect(subject).to eq(false)
      end
    end

    context "when key exists" do
      before do
        context[key] = value
      end

      it "returns true" do
        expect(subject).to eq(true)
      end
    end
  end

  describe ".read" do
    subject { context.read(key) }

    context "when key does not exist" do
      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when key exists" do
      before do
        context[key] = value
      end

      it "return a proper value" do
        expect(subject).to eq(value)
      end
    end
  end

  describe ".write" do
    subject { context.write(key, value) }

    context "when key does not exist" do
      it "has the proper previous value" do
        expect(context[key]).to eq(nil)
      end

      it "saves a new value" do
        subject
        expect(context[key]).to eq(value)
      end
    end

    context "when key exists" do
      let(:previous_value) { "old-value" }

      before do
        context[key] = previous_value
      end

      it "has the proper previous value" do
        expect(context[key]).to eq(previous_value)
      end

      it "overwrites the original value with desired" do
        subject
        expect(subject).to eq(value)
      end
    end
  end

  describe ".delete" do
    subject { context.delete(key) }

    context "when key does not exist" do
      it "does nothing" do
        subject

        expect(context.storage).to eq({})
      end
    end

    context "when key exists" do
      before do
        context[key] = value
      end

      it "has the proper previous value" do
        expect(context.storage).to eq(key => value)
      end

      it "removes this key" do
        subject
        expect(context.storage).to eq({})
      end
    end
  end

  describe ".fetch" do
    subject { context.fetch(key) }

    context "when key does not exist" do
      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end

    context "when key exists" do
      before do
        context[key] = value
      end

      it "returns a proper value" do
        expect(subject).to eq(value)
      end
    end
  end

  describe ".up!" do
    subject { context.up! }

    context "when called first time" do
      it "sets the flag to true" do
        subject

        expect(Thread.current[:thread_aware_active]).to eq(true)
      end
    end

    context "when it was down before" do
      before do
        context.down!
      end

      it "has the proper previous value" do
        expect(Thread.current[:thread_aware_active]).to eq(false)
      end

      it "sets the flag to true" do
        subject

        expect(Thread.current[:thread_aware_active]).to eq(true)
      end
    end
  end

  describe ".down!" do
    subject { context.down! }

    context "when called first time" do
      it "sets flag to false" do
        subject

        expect(Thread.current[:thread_aware_active]).to eq(false)
      end
    end

    context "when it was up before" do
      before do
        context.up!
      end

      it "has the correct previous value" do
        expect(Thread.current[:thread_aware_active]).to eq(true)
      end

      it "sets flag to false" do
        subject

        expect(Thread.current[:thread_aware_active]).to eq(false)
      end
    end
  end

  describe ".flush!" do
    subject { context.flush }

    context "when context is active" do

    end

    context "when context is not active" do

    end
  end

  describe ".active?" do
    subject { context.active? }

    context "when context was not initialized" do
      it "return false" do
        expect(subject).to eq(false)
      end
    end

    context "when context is active" do
      before do
        context.up!
      end

      it "returns true" do
        expect(subject).to eq(true)
      end
    end

    context "when context is not active" do
      before do
        context.down!
      end

      it "return false" do
        expect(subject).to eq(false)
      end
    end
  end
end
