# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.super?
  end

  def show?
    user.super?
  end

  def create?
    user.super?
  end

  def new?
    create?
  end

  def update?
    user.super?
  end

  def edit?
    update?
  end

  def destroy?
    user.super?
  end
end
