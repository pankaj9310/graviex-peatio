module Admin
  class Ability
    include CanCan::Ability

    def initialize(user)
      return unless user.admin?

      can :read, Order
      can :read, Trade
      can :read, Proof
      can :update, Proof
      can :manage, Document
      can :manage, Member
      can :manage, Ticket
      can :manage, IdDocument
      can :manage, TwoFactor

      can :menu, Deposit
      can :manage, ::Deposits::Bank
      can :manage, ::Deposits::Satoshi
      can :manage, ::Deposits::Gravio
      can :manage, ::Deposits::Doge
      can :manage, ::Deposits::Ltc
      can :manage, ::Deposits::Ether
      #deposit

      can :menu, Withdraw
      can :manage, ::Withdraws::Bank
      can :manage, ::Withdraws::Satoshi
      can :manage, ::Withdraws::Gravio
      can :manage, ::Withdraws::Doge
      can :manage, ::Withdraws::Ltc
      can :manage, ::Withdraws::Ether
      #withdraw

    end
  end
end
