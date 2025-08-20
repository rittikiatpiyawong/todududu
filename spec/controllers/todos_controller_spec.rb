require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  describe 'GET #index' do
    let!(:todo1) { create(:todo, created_at: 1.hour.ago) }
    let!(:todo2) { create(:todo, created_at: 2.hours.ago) }
    let!(:completed_todo) { create(:todo, :completed) }
    let!(:pending_todo) { create(:todo, :pending) }

    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns @todos in recent order' do
      todos_in_recent_order = Todo.recent.to_a
      assigned_todos = assigns(:todos).to_a
      expect(assigned_todos).to eq(todos_in_recent_order)

      # Check that the order is correct
      expect(assigned_todos.first.created_at).to be >= assigned_todos.last.created_at
    end

    it 'assigns a new Todo to @todo' do
      expect(assigns(:todo)).to be_a_new(Todo)
    end

    it 'assigns correct counts' do
      expect(assigns(:total_count)).to eq(Todo.count)
      expect(assigns(:completed_count)).to eq(Todo.completed.count)
      expect(assigns(:pending_count)).to eq(Todo.pending.count)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { todo: { title: 'New todo task' } } }

      it 'creates a new todo' do
        expect {
          post :create, params: valid_params
        }.to change(Todo, :count).by(1)
      end

      it 'redirects to root path for HTML format' do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      context 'with turbo_stream format' do
        it 'returns turbo_stream response' do
          post :create, params: valid_params, format: :turbo_stream
          expect(response.media_type).to eq('text/vnd.turbo-stream.html')
        end
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { todo: { title: '' } } }

      it 'does not create a new todo' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Todo, :count)
      end

      it 'redirects to root path with alert for HTML format' do
        post :create, params: invalid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #toggle' do
    let(:todo) { create(:todo, :pending) }

    it 'toggles the todo completed status' do
      expect {
        patch :toggle, params: { id: todo.id }
      }.to change { todo.reload.completed }.from(false).to(true)
    end

    it 'redirects to root path for HTML format' do
      patch :toggle, params: { id: todo.id }
      expect(response).to redirect_to(root_path)
    end

    context 'with turbo_stream format' do
      it 'returns turbo_stream response' do
        patch :toggle, params: { id: todo.id }, format: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'when todo does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          patch :toggle, params: { id: 99999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:todo) { create(:todo) }

    it 'destroys the todo' do
      expect {
        delete :destroy, params: { id: todo.id }
      }.to change(Todo, :count).by(-1)
    end

    it 'redirects to root path for HTML format' do
      delete :destroy, params: { id: todo.id }
      expect(response).to redirect_to(root_path)
    end

    context 'with turbo_stream format' do
      it 'returns turbo_stream response' do
        delete :destroy, params: { id: todo.id }, format: :turbo_stream
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'when todo does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          delete :destroy, params: { id: 99999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'private methods' do
    describe '#set_todo' do
      let(:todo) { create(:todo) }

      it 'sets @todo for toggle action' do
        patch :toggle, params: { id: todo.id }
        expect(assigns(:todo)).to eq(todo)
      end

      it 'sets @todo for destroy action' do
        delete :destroy, params: { id: todo.id }
        expect(assigns(:todo)).to eq(todo)
      end
    end

    describe '#todo_params' do
      it 'permits title and completed parameters' do
        controller_instance = TodosController.new
        params = ActionController::Parameters.new(todo: { title: 'Test', completed: true, unauthorized: 'value' })
        controller_instance.params = params

        permitted_params = controller_instance.send(:todo_params)
        expect(permitted_params.keys).to contain_exactly('title', 'completed')
      end
    end
  end
end
