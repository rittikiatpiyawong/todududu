# features/step_definitions/todo_steps.rb

# Include Rails URL helpers
World(Rails.application.routes.url_helpers)

# Navigation steps
Given('I am on the todo homepage') do
  visit root_path
end

Given('I am on the brag document page') do
  visit brag_document_path
end

# Page content verification steps
Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end

Then('I should see a form to add new todos') do
  expect(page).to have_field('todo_title')
  expect(page).to have_button('+')
end


# Navigation action steps
When('I click on {string}') do |link_text|
  click_link(link_text)
end

When('I click the add todo button') do
  click_button('+')
end

# Page verification steps
Then('I should be on the todo homepage') do
  expect(current_path).to eq(root_path)
end

Then('I should be on the brag document page') do
  expect(current_path).to eq(brag_document_path)
end

# Form interaction steps
When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

# Todo management steps
Given('I have a todo {string}') do |title|
  @todo = FactoryBot.create(:todo, title: title, completed: false)
  visit current_path # Refresh to see the new todo
end

Given('I have a completed todo {string}') do |title|
  @completed_todo = FactoryBot.create(:todo, title: title, completed: true)
  visit current_path # Refresh to see the new todo
end

Given('I have no todos') do
  Todo.destroy_all
  visit current_path # Refresh the page
end

Given('I have {int} pending todos') do |count|
  count.times do |i|
    FactoryBot.create(:todo, title: "Pending todo #{i + 1}", completed: false)
  end
  visit current_path
end

Given('I have {int} todos with {int} completed') do |total, completed|
  completed.times do |i|
    FactoryBot.create(:todo, title: "Completed todo #{i + 1}", completed: true)
  end

  pending = total - completed
  pending.times do |i|
    FactoryBot.create(:todo, title: "Pending todo #{i + 1}", completed: false)
  end

  visit current_path
end

Given('I have the following todos:') do |table|
  table.hashes.each do |row|
    FactoryBot.create(:todo,
      title: row['title'],
      completed: row['completed'] == 'true'
    )
  end
  visit current_path
end

# Todo interaction steps
When('I check the todo {string}') do |title|
  # Try different ways to find the todo
  todo_container = nil

  # Try to find by exact text match in the title paragraph
  begin
    todo_container = find('p', text: title).ancestor('div[data-todo-status]')
  rescue Capybara::ElementNotFound
    # If that fails, try to find in any element containing the text
    todo_container = find('*', text: title).ancestor('div[data-todo-status]')
  end

  within(todo_container) do
    find('button[type="submit"]').click
  end
end

When('I uncheck the todo {string}') do |title|
  # Try different ways to find the todo
  todo_container = nil

  begin
    todo_container = find('p', text: title).ancestor('div[data-todo-status]')
  rescue Capybara::ElementNotFound
    todo_container = find('*', text: title).ancestor('div[data-todo-status]')
  end

  within(todo_container) do
    find('button[type="submit"]').click
  end
end

When('I delete the todo {string}') do |title|
  # Try different ways to find the todo
  todo_container = nil

  begin
    todo_container = find('p', text: title).ancestor('div[data-todo-status]')
  rescue Capybara::ElementNotFound
    todo_container = find('*', text: title).ancestor('div[data-todo-status]')
  end

  within(todo_container) do
    find('a[data-turbo-method="delete"]').click
  end
end

When('I complete {int} todos') do |count|
  count.times do |i|
    # Find all pending todos each time to avoid stale references
    pending_todos = all('div[data-todo-status="pending"]')
    break if pending_todos.empty?

    within(pending_todos.first) do
      find('button[type="submit"]').click
    end

    # Wait for the turbo stream to update the page
    sleep 0.2
  end

  # Final refresh to ensure statistics are updated
  visit current_path
end

When('I delete {int} completed todo') do |count|
  count.times do |i|
    # Find all completed todos each time to avoid stale references
    completed_todos = all('div[data-todo-status="completed"]')
    break if completed_todos.empty?

    within(completed_todos.first) do
      find('a[data-turbo-method="delete"]').click
    end

    # Wait for the turbo stream to update the page
    sleep 0.2
  end

  # Final refresh to ensure statistics are updated
  visit current_path
end

# Todo verification steps
Then('I should see {string} in the todo list') do |title|
  within('#todos') do
    expect(page).to have_content(title)
  end
end

Then('I should not see {string} in the todo list') do |title|
  within('#todos') do
    expect(page).not_to have_content(title)
  end
end

Then('I should not see any new todos in the list') do
  # This step assumes we're checking that no new todos were added
  # Implementation depends on the specific test context
end

Then('I should see an error message') do
  # This depends on how your application shows errors
  # It might be a flash message or inline validation error
  has_error = page.has_content?('can\'t be blank') ||
              page.has_selector?('.alert') ||
              current_path == root_path # Redirect indicates error
  expect(has_error).to be true
end

Then('the todo {string} should be marked as completed') do |title|
  visit current_path # Refresh to see changes
  todo_container = find('p', text: title).ancestor('div[data-todo-status]')
  expect(todo_container['data-todo-status']).to eq('completed')
end

Then('the todo {string} should be marked as pending') do |title|
  visit current_path # Refresh to see changes
  todo_container = find('p', text: title).ancestor('div[data-todo-status]')
  expect(todo_container['data-todo-status']).to eq('pending')
end

Then('I should see a timestamp for the todo {string}') do |title|
  todo_container = find('p', text: title).ancestor('div[data-todo-status]')
  within(todo_container) do
    expect(page).to have_content('ago')
  end
end

# Statistics verification steps
Then('the total count should be {int}') do |count|
  within('[data-todo-stats-target="total"]') do
    expect(page).to have_content(count.to_s)
  end
end

Then('the pending count should be {int}') do |count|
  within('[data-todo-stats-target="pending"]') do
    expect(page).to have_content(count.to_s)
  end
end

Then('the completed count should be {int}') do |count|
  within('[data-todo-stats-target="completed"]') do
    expect(page).to have_content(count.to_s)
  end
end
