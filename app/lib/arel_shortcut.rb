# frozen_string_literal: true

module ArelShortcut
  refine Arel::Predications do
    alias > gt
    alias >= gteq
    alias < lt
    alias <= lteq
    alias == eq
    alias != not_eq
    alias =~ matches
    alias !~ does_not_match
  end
end
