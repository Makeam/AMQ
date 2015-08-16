shared_examples_for "Publishable" do
  it 'should publish to PrivatePub channel if object valid' do
    expect(PrivatePub).to receive(:publish_to).with(publish_path, anything)
    request
  end
  it 'should not publish to PrivatePub channel if object invalid' do
    expect(PrivatePub).to_not receive(:publish_to)
    invalid_params_request
  end
end