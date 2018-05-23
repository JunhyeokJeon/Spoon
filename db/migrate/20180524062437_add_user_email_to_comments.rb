class AddUserEmailToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :user_email, :string
  end
end
