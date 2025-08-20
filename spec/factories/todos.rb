FactoryBot.define do
  factory :todo do
    title { "Sample todo task" }
    completed { false }

    trait :completed do
      completed { true }
    end

    trait :pending do
      completed { false }
    end

    trait :with_long_title do
      title { "This is a very long todo title that should test the maximum length validation" }
    end

    trait :with_empty_title do
      title { "" }
    end
  end
end
