shared_examples_for "Commentable model" do

  it { should have_many(:comments).dependent(:destroy)}

end
