shared_examples_for "Attachment destroy" do
  before { attachable.attachments.create(attributes_for(:attachment)) }

  context 'Attachable\'s owner can delete attached file', js: true do
    before{ sign_in(owner) }
    it "should delete attachment" do
      expect{ delete :destroy, id: attachable.attachments.first.id, format: :js }.to change(attachable.attachments, :count).by(-1)
    end
    it "Response status: 200" do
      delete :destroy, id: attachable.attachments.first.id, format: :js
      expect(response.status).to eq 200
    end
  end

  context 'Not owner of attachable can\'t delete attached file', js: true do
    before{ sign_in(user) }
    it "should NOT delete attachment" do
      expect{ delete :destroy, id: attachable.attachments.first.id, format: :js }.to change(attachable.attachments, :count).by(0)
    end
    it "Response status: 302" do
      delete :destroy, id: attachable.attachments.first.id, format: :js
      expect(response.status).to eq 302
    end
  end
end