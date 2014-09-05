class CreateAdds < ActiveRecord::Migration
  def change
    create_table :adds do |t|
      t.string :campaign
      t.string :budget
      t.string :acount_no

      t.timestamps
    end
  end
end
