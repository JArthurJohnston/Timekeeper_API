class AddSecurePasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    secure_old_passwords
  end

  def secure_old_passwords
    User.all.each do
    |each_user|
      new_user = User.new(password: each_user.password, password_confirmation: each_user.password)
      each_user.update(password_digest: new_user.password_digest)
    end
  end
end
