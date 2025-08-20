require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(1).is_at_most(255) }
  end

  describe 'scopes' do
    let!(:completed_todo) { create(:todo, :completed) }
    let!(:pending_todo) { create(:todo, :pending) }
    let!(:older_todo) { create(:todo, created_at: 2.days.ago) }

    describe '.completed' do
      it 'returns only completed todos' do
        expect(Todo.completed).to include(completed_todo)
        expect(Todo.completed).not_to include(pending_todo)
      end
    end

    describe '.pending' do
      it 'returns only pending todos' do
        expect(Todo.pending).to include(pending_todo)
        expect(Todo.pending).not_to include(completed_todo)
      end
    end

    describe '.recent' do
      it 'orders todos by created_at descending' do
        recent_todos = Todo.recent
        expect(recent_todos.first.created_at).to be > recent_todos.last.created_at
      end
    end
  end

  describe '#toggle_completed!' do
    context 'when todo is pending' do
      let(:todo) { create(:todo, :pending) }

      it 'sets completed to true' do
        expect { todo.toggle_completed! }.to change { todo.completed }.from(false).to(true)
      end
    end

    context 'when todo is completed' do
      let(:todo) { create(:todo, :completed) }

      it 'sets completed to false' do
        expect { todo.toggle_completed! }.to change { todo.completed }.from(true).to(false)
      end
    end

    it 'persists the change to database' do
      todo = create(:todo, :pending)
      todo.toggle_completed!
      expect(todo.reload.completed).to be true
    end
  end

  describe 'factory' do
    it 'creates a valid todo' do
      todo = build(:todo)
      expect(todo).to be_valid
    end

    it 'creates a completed todo with trait' do
      todo = create(:todo, :completed)
      expect(todo.completed).to be true
    end

    it 'creates a pending todo with trait' do
      todo = create(:todo, :pending)
      expect(todo.completed).to be false
    end
  end

  describe 'title validation' do
    it 'is invalid with empty title' do
      todo = build(:todo, title: '')
      expect(todo).to be_invalid
      expect(todo.errors[:title]).to include("can't be blank")
    end

    it 'is invalid with title longer than 255 characters' do
      long_title = 'a' * 256
      todo = build(:todo, title: long_title)
      expect(todo).to be_invalid
      expect(todo.errors[:title]).to include("is too long (maximum is 255 characters)")
    end

    it 'is valid with title of 255 characters' do
      valid_title = 'a' * 255
      todo = build(:todo, title: valid_title)
      expect(todo).to be_valid
    end
  end
end
