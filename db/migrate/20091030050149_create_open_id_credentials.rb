class CreateOpenIdCredentials < ActiveRecord::Migration
  def self.up
    create_table :open_id_credentials do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :open_id_credentials
  end
end
