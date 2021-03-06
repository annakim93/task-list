require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
    completed_at: Time.now + 5.days
  }

  let (:task_hash) {
    {
        task: {
            name: "new task",
            description: "new task description",
            completed_at: nil,
        }
    }
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # skip
      # Act
      get task_path(task.id)
      
      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      # skip
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do
      # skip
      
      # Act
      get new_task_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      # skip
      
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end
  
  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      get edit_task_path(task.id)
      must_respond_with :success
    end
    
    it "will respond with redirect when attempting to edit a nonexistant task" do
      get edit_task_path(-1)
      must_respond_with :redirect
    end
  end
  
  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.

    before do
      Task.create(name: "filler", description: "more filler")
    end

    it "can update an existing task" do
      # Arrange
      task = Task.first

      # Act-Assert
      expect {
        patch task_path(task.id), params: task_hash
      }.wont_change 'Task.count'

      task.reload

      expect(task.name).must_equal task_hash[:task][:name]
      expect(task.description).must_equal task_hash[:task][:description]
      expect(task.completed_at).must_equal task_hash[:task][:completed_at]

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
    
    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1), params: task_hash
      must_respond_with :redirect
    end
  end
  
  # Complete these tests for Wave 4
  describe "destroy" do

    it "can destroy a task" do
      id = task.id # this creates the task so count registers as 1
      # Act
      expect {
        delete task_path(id)
      }.must_change 'Task.count', -1 # Assert

      task = Task.find_by(name: "sample task")

      expect(task).must_be_nil

      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "will redirect when trying to delete a task that doesn't exist" do
      expect {
        delete task_path(-1)
      }.wont_change "Task.count"

      must_respond_with :redirect
    end
  end
  
  # Complete for Wave 4
  describe "toggle_complete" do
    it "will change completed_at field from blank to a datestr for an incomplete task being marked complete" do
      test_task = Task.create(name: "filler", description: "more filler")

      patch task_completion_path(test_task.id)
      test_task.reload
      expect(test_task.completed_at.present?).must_equal true
    end

    it "will change completed_at field from a string to blank for an complete task being changed to incomplete" do
      test_task = Task.create(name: "filler", description: "more filler", completed_at: "filler date")

      patch task_completion_path(test_task.id)
      test_task.reload
      expect(test_task.completed_at.blank?).must_equal true
    end
  end
end
