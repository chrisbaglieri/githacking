class LabelsTag < ActiveRecord::Base
  belongs_to :label
  belongs_to :issue
end
