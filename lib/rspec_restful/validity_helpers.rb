module RspecRestful
  module ValidityHelpers
    def stub_as_always_valid(klass)
      allow_any_instance_of(klass).to receive(:valid?).and_return(true)
    end

    def stub_as_never_valid(klass)
      allow_any_instance_of(klass).to receive(:valid?).and_return(false)
    end
  end
end
