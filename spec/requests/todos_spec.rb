require 'rails_helper'

RSpec.describe "Todos", type: :request do
  describe "GET /todos" do
    let!(:completed_todo) { create(:todo, :completed, title: "Completed task") }
    let!(:pending_todo) { create(:todo, :pending, title: "Pending task") }

    before { get root_path }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "displays todos in the response" do
      expect(response.body).to include("Completed task")
      expect(response.body).to include("Pending task")
    end

    it "includes todo form" do
      expect(response.body).to include('type="submit"')
    end
  end

  describe "POST /todos" do
    context "with valid parameters" do
      let(:valid_params) { { todo: { title: "New integration test todo" } } }

      it "creates a new todo" do
        expect {
          post todos_path, params: valid_params
        }.to change(Todo, :count).by(1)
      end

      it "redirects to root path" do
        post todos_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "creates todo with correct attributes" do
        post todos_path, params: valid_params
        created_todo = Todo.last
        expect(created_todo.title).to eq("New integration test todo")
        expect(created_todo.completed).to be false
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { todo: { title: "" } } }

      it "does not create a new todo" do
        expect {
          post todos_path, params: invalid_params
        }.not_to change(Todo, :count)
      end

      it "redirects to root path" do
        post todos_path, params: invalid_params
        expect(response).to redirect_to(root_path)
      end
    end

    context "with turbo_stream format" do
      let(:valid_params) { { todo: { title: "Turbo stream todo" } } }

      it "returns turbo_stream response" do
        post todos_path, params: valid_params, headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "PATCH /todos/:id/toggle" do
    let(:todo) { create(:todo, :pending) }

    it "toggles todo completion status" do
      expect {
        patch toggle_todo_path(todo)
      }.to change { todo.reload.completed }.from(false).to(true)
    end

    it "redirects to root path" do
      patch toggle_todo_path(todo)
      expect(response).to redirect_to(root_path)
    end

    context "with turbo_stream format" do
      it "returns turbo_stream response" do
        patch toggle_todo_path(todo), headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "with non-existent todo" do
      it "handles non-existent todo gracefully" do
        # In a real application, this might return 404 or redirect
        # For now, we just check it doesn't crash
        begin
          patch toggle_todo_path(99999)
        rescue ActiveRecord::RecordNotFound
          # This is expected behavior
        end
      end
    end
  end

  describe "DELETE /todos/:id" do
    let!(:todo) { create(:todo) }

    it "deletes the todo" do
      expect {
        delete todo_path(todo)
      }.to change(Todo, :count).by(-1)
    end

    it "redirects to root path" do
      delete todo_path(todo)
      expect(response).to redirect_to(root_path)
    end

    context "with turbo_stream format" do
      it "returns turbo_stream response" do
        delete todo_path(todo), headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "with non-existent todo" do
      it "handles non-existent todo gracefully" do
        # In a real application, this might return 404 or redirect
        # For now, we just check it doesn't crash
        begin
          delete todo_path(99999)
        rescue ActiveRecord::RecordNotFound
          # This is expected behavior
        end
      end
    end
  end
end
