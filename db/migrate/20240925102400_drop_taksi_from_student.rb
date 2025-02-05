class DropTaksiFromStudent < ActiveRecord::Migration[7.1]
  def change
    remove_column :students, :taksi
  end
end
