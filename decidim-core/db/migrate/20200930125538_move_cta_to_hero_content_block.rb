# frozen_string_literal: true

class MoveCtaToHeroContentBlock < ActiveRecord::Migration[5.2]
  class Organization < ApplicationRecord
    self.table_name = :decidim_organizations
  end

  def change
    Decidim::ContentBlock.reset_column_information
    Organization.find_each do |organization|
      content_block = Decidim::ContentBlock.find_by(organization: organization, scope_name: :homepage, manifest_name: :hero)
      settings = {}
      cta_button_text = organization.cta_button_text || {}
      settings = cta_button_text.inject(settings) { |acc, (k, v)| acc.update("cta_button_text_#{k}" => v) }

      unless organization.cta_button_path.empty?
        # Adds i18n support to cta_button_path for every defined lang in cta_button_text
        settings = cta_button_text.inject(settings) { |acc, (k, _v)| acc.update("cta_button_path_#{k}" => organization.cta_button_path) }
      end

      content_block.settings = settings
      content_block.settings_will_change!
      content_block.save!
    end

    remove_column :decidim_organizations, :cta_button_text
    remove_column :decidim_organizations, :cta_button_path
  end
end