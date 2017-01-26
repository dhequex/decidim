# frozen_string_literal: true
module Decidim
  module Abilities
    # Defines the base abilities for any user. Guest users will use these too.
    # Intended to be used with `cancancan`.
    class Everyone
      include CanCan::Ability

      def initialize(user)
        can :read, ParticipatoryProcess, &:published?
        can :read, :public_pages
        can :manage, :locales

        can :manage, User do |other|
          other == user
        end
      end
    end
  end
end
