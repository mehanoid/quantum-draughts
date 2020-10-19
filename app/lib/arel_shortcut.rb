# frozen_string_literal: true

module ArelShortcut
  refine Arel::Predications do
    alias_method :>, :gt
    alias_method :>=, :gteq
    alias_method :<, :lt
    alias_method :<=, :lteq
    alias_method :==, :eq
    alias_method :!=, :not_eq
    alias_method :=~, :matches
    alias_method :!~, :does_not_match
  end
end
