class AddUserNicknameToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :user_nickname, :string
  end
end
