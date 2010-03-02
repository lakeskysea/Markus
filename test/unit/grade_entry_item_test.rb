require File.dirname(__FILE__) + '/../test_helper'
require File.join(File.dirname(__FILE__),'/../blueprints/blueprints')
require File.join(File.dirname(__FILE__), '/../blueprints/helper')
require 'shoulda'

# Tests for GradeEntryItems
class GradeEntryItemTest < ActiveSupport::TestCase
  
  def setup
    clear_fixtures
  end
  
  should_belong_to :grade_entry_form
  should_have_many :grades
  
  should_validate_presence_of :name, :out_of
  should_validate_uniqueness_of :name, :scoped_to => :grade_entry_form_id, 
                                :message => I18n.t('grade_entry_forms.invalid_name')
                                
  should_validate_numericality_of :out_of, :message => I18n.t('grade_entry_forms.invalid_column_out_of')
  
  should_allow_values_for :out_of, 1, 2, 100
  should_not_allow_values_for :out_of, -1, -100
  
  # Make sure different grade entry forms can have grade entry items 
  # with the same name
  should "allow same column name for different grade entry forms" do
    grade_entry_form_1 = GradeEntryForm.make
    grade_entry_form_2 = GradeEntryForm.make
    column = grade_entry_form_1.grade_entry_items.make(:name => "Q1")
    
    # Re-use the column name for a different grade entry form
    dup_column = GradeEntryItem.new
    dup_column.name = column.name
    dup_column.out_of = column.out_of
    dup_column.grade_entry_form = grade_entry_form_2
    
    assert dup_column.valid?
  end
  
end
