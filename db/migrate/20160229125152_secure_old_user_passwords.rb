class SecureOldUserPasswords < ActiveRecord::Migration
  def change
    User.all.each do
    |each_user|
      new_user = User.new(password: each_user.password, password_confirmation: each_user.password)
      puts new_user.password_digest
      each_user.update(password_digest: new_user.password_digest)
    end
  end
end
