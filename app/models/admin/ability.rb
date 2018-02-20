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
      can :manage, ::Deposits::Poseidon
      can :manage, ::Deposits::Profithunter
      can :manage, ::Deposits::Xgoldcoin
      can :manage, ::Deposits::Deviant
      can :manage, ::Deposits::Phoboscoin
      can :manage, ::Deposits::Dinero
      can :manage, ::Deposits::Advance
      can :manage, ::Deposits::Dv7coin
      can :manage, ::Deposits::Shekel
      can :manage, ::Deposits::Argo
      can :manage, ::Deposits::Escrow
      can :manage, ::Deposits::Neetcoin
      can :manage, ::Deposits::Xylo
      can :manage, ::Deposits::Steepcoin
      can :manage, ::Deposits::Bitcoingreen
      can :manage, ::Deposits::Craftr
      can :manage, ::Deposits::Enviromint
      can :manage, ::Deposits::Snowgem
      can :manage, ::Deposits::Newyorkcoin
      can :manage, ::Deposits::Zeroonecoin
      can :manage, ::Deposits::Bitcoinz
      can :manage, ::Deposits::Yenten
      can :manage, ::Deposits::Yicoin
      can :manage, ::Deposits::Tulipcoin
      can :manage, ::Deposits::Pawcoin
      can :manage, ::Deposits::Stronghand
      can :manage, ::Deposits::Lemanum
      can :manage, ::Deposits::Keyco
      can :manage, ::Deposits::Absolute
      can :manage, ::Deposits::Suppocoin
      can :manage, ::Deposits::Linda
      can :manage, ::Deposits::Highcoin
      can :manage, ::Deposits::Blisscoin
      can :manage, ::Deposits::Tokyo
      can :manage, ::Deposits::Elleriumcoin
      #deposit

      can :menu, Withdraw
      can :manage, ::Withdraws::Bank
      can :manage, ::Withdraws::Satoshi
      can :manage, ::Withdraws::Gravio
      can :manage, ::Withdraws::Doge
      can :manage, ::Withdraws::Ltc
      can :manage, ::Withdraws::Ether
      can :manage, ::Withdraws::Poseidon
      can :manage, ::Withdraws::Profithunter
      can :manage, ::Withdraws::Xgoldcoin
      can :manage, ::Withdraws::Deviant
      can :manage, ::Withdraws::Phoboscoin
      can :manage, ::Withdraws::Dinero
      can :manage, ::Withdraws::Advance
      can :manage, ::Withdraws::Dv7coin
      can :manage, ::Withdraws::Shekel
      can :manage, ::Withdraws::Argo
      can :manage, ::Withdraws::Escrow
      can :manage, ::Withdraws::Neetcoin
      can :manage, ::Withdraws::Xylo
      can :manage, ::Withdraws::Steepcoin
      can :manage, ::Withdraws::Bitcoingreen
      can :manage, ::Withdraws::Craftr
      can :manage, ::Withdraws::Enviromint
      can :manage, ::Withdraws::Snowgem
      can :manage, ::Withdraws::Newyorkcoin
      can :manage, ::Withdraws::Zeroonecoin
      can :manage, ::Withdraws::Bitcoinz
      can :manage, ::Withdraws::Yenten
      can :manage, ::Withdraws::Yicoin
      can :manage, ::Withdraws::Tulipcoin
      can :manage, ::Withdraws::Pawcoin
      can :manage, ::Withdraws::Stronghand
      can :manage, ::Withdraws::Lemanum
      can :manage, ::Withdraws::Keyco
      can :manage, ::Withdraws::Absolute
      can :manage, ::Withdraws::Suppocoin
      can :manage, ::Withdraws::Linda
      can :manage, ::Withdraws::Highcoin
      can :manage, ::Withdraws::Blisscoin
      can :manage, ::Withdraws::Tokyo
      can :manage, ::Withdraws::Elleriumcoin
      #withdraw

    end
  end
end
