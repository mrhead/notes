# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#

class Note < ActiveRecord::Base
  validates :title, presence: true

  def truncate_lines
    if text.lines.count > 15
      self.text = self.text.lines.first(15).join + '...'
    end
  end
end
