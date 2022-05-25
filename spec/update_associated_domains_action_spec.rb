describe Fastlane::Actions::UpdateAssociatedDomainsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The update_associated_domains plugin is working!")

      Fastlane::Actions::UpdateAssociatedDomainsAction.run(nil)
    end
  end
end
