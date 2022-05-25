require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class UpdateAssociatedDomainsHelper
      # class methods that you define here become available in your action
      # as `Helper::UpdateAssociatedDomainsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the update_associated_domains plugin helper!")
      end
    end
  end
end
