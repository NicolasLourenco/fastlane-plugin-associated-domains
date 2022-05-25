require 'fastlane/action'
require_relative '../helper/update_associated_domains_helper'

module Fastlane
  module Actions
    module SharedValues
      APP_ASSOCIATED_DOMAINS = :APP_ASSOCIATED_DOMAINS
    end

    class UpdateAssociatedDomainsAction < Action
      def self.run(params)
        UI.message("Entitlements File: #{params[:entitlements_file]}")
        UI.message("New associated domains: #{params[:associated_domains]}")

        entitlements_file = params[:entitlements_file]
        unless File.exist?(entitlements_file)
          UI.user_error!("Could not find entitlements file at path '#{entitlements_file}'")
        end

        # parse entitlements
        result = Plist.parse_xml(entitlements_file)
        UI.user_error!("Entitlements file at '#{entitlements_file}' cannot be parsed.") unless result

        # get associated domains field
        associated_domains_field = result['com.apple.developer.associated-domains']
        unless associated_domains_field
          UI.user_error!('No existing associated domains specified. Please specify an associated domain in the entitlements file.')
        end

        # set new associated domains
        UI.message("Old associated domains: #{associated_domains_field}")
        result['com.apple.developer.associated-domains'] = params[:associated_domains]

        # save entitlements file
        result.save_plist(entitlements_file)
        UI.message("New associated domains set: #{result['com.apple.developer.associated-domains']}")

        Actions.lane_context[SharedValues::APP_ASSOCIATED_DOMAINS] = result['com.apple.developer.associated-domains']
      end

      def self.description
        'This plugin changes the associated domains in the entitlements file'
      end

      def self.details
        'Updates the associated domains in the given Entitlements file, so you can have associated domains for web credentials or app links.'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :entitlements_file,
                                       env_name: 'FL_UPDATE_APP_GROUP_IDENTIFIER_ENTITLEMENTS_FILE_PATH', # The name of the environment variable
                                       description: 'The path to the entitlement file which contains the associated domains', # a short description of this parameter
                                       verify_block: proc do |value|
                                         unless value.include?('.entitlements')
                                           UI.user_error!('Please pass a path to an entitlements file. ')
                                         end
                                         if !File.exist?(value) && !Helper.test?
                                           UI.user_error!('Could not find entitlements file')
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :associated_domains,
                                       env_name: 'FL_UPDATE_ASSOCIATED_DOMAINS_IDENTIFIERS',
                                       description: "An Array of unique identifiers for the associated domains. Eg. ['webcredentials:fastlane.com']",
                                       type: Array)
        ]
      end

      def self.output
        [
          ['APP_ASSOCIATED_DOMAINS', 'The new associated domains']
        ]
      end

      def self.authors
        ['NicolasLourenco']
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.example_code
        [
          'update_assiocated_domains_group_identifiers(
            entitlements_file: "/path/to/entitlements_file.entitlements",
            associated_domains: ["webcredentials:fastlane.com"]
          )'
        ]
      end

      def self.category
        :project
      end

      def self.is_supported?(platform)
        %i[ios mac android].include?(platform)
      end
    end
  end
end
