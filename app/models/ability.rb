# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.admin?
        can :manage, :all
      elsif user.member?
        can :read, :all
      else
        can :read, :all # guest user
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities


    # class Ability
    #   include CanCan::Ability

    #   def initialize(user)
    #     user ||= User.new  # ログインしていない場合は、からユーザーを用意し判定に用いる

    #     # default parmission
    #     cannot :buy, Product

    #     if user.sys_admin?
    #       can :manage, :all
    #     end

    #     if user.product_manager?
    #       can :manage, Stockpile, owner: user # 自分がオーナーの倉庫には全権限を持つ
    #       can :read, Stockpile                 # そうでなくても、読み取り権限を持つ

    #       # 自分の倉庫にある製品に対してすべての権限を持つ
    #       can :manage, Product, stockpile: {owner: user}
    #       # ただし、新規登録、削除はできない
    #       cannot [:create, :destroy], Product
    #     end

    #     if user.customer?
    #       # 複数のモデルに権限を付与できる
    #       can :read, [Stockpile, Product]

    #       # 独自権限も作れる
    #       can :buy, Procuct, stockpile: nil # 倉庫から出されている製品を買える
    #     end
    #   end
    # end

  end
end
